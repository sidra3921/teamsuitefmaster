import '../config/app_config.dart';

class MockApiService {
  static bool get useMockMode => AppConfig.useMockMode;

  // In-memory storage for attendance records to persist between calls
  static Map<String, dynamic> _todayAttendance = {};
  static List<Map<String, dynamic>> _attendanceHistory = [
    {
      'date': '2025-08-07',
      'checkIn': '09:00 AM',
      'checkOut': '06:00 PM',
      'hours': 8.0,
      'status': 'Present',
    },
    {
      'date': '2025-08-06',
      'checkIn': '09:15 AM',
      'checkOut': '06:30 PM',
      'hours': 8.25,
      'status': 'Present',
    },
  ];

  // In-memory storage for leave history to persist between calls
  static List<Map<String, dynamic>> _leaveHistory = [
    {
      'id': 1,
      'type': 'Annual Leave',
      'fromDate': '2025-07-01',
      'toDate': '2025-07-05',
      'days': 5,
      'status': 'Approved',
      'reason': 'Family vacation',
    },
    {
      'id': 2,
      'type': 'Sick Leave',
      'fromDate': '2025-06-15',
      'toDate': '2025-06-16',
      'days': 2,
      'status': 'Approved',
      'reason': 'Medical appointment',
    },
  ];

  static Future<Map<String, dynamic>> mockLogin(
    String username,
    String password,
  ) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    // Mock successful authentication
    if (username.toLowerCase() == 'manager' && password == 'FSDEMO123') {
      final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      return {
        'success': true,
        'data': {
          'token': mockToken,
          'access_token': mockToken, // Include both formats for compatibility
          'token_type': 'Bearer',
          'expires_in': 3600,
          'user': {
            'id': 1,
            'username': username,
            'name': 'Test Manager',
            'email': 'manager@test.com',
          },
        },
        'message': 'Mock login successful',
      };
    }

    return {'success': false, 'message': 'Invalid credentials'};
  }

  static Future<Map<String, dynamic>> mockExecSp(
    String spName,
    Map<String, dynamic>? parameters,
  ) async {
    await Future.delayed(Duration(milliseconds: 300));

    switch (spName) {
      case 'GET_LEAVE_BALANCE':
        return {
          'success': true,
          'data': [
            {'leaveType': 'Annual', 'balance': 15, 'used': 5, 'total': 20},
            {'leaveType': 'Sick', 'balance': 8, 'used': 2, 'total': 10},
            {'leaveType': 'Personal', 'balance': 3, 'used': 2, 'total': 5},
          ],
        };

      case 'GET_LEAVE_HISTORY':
        return {
          'success': true,
          'data': _leaveHistory,
          'message': 'Leave history retrieved successfully',
        };

      case 'POST_LEAVE_REQUEST':
        // Create a new leave request and add to history
        final newLeaveId = _leaveHistory.length > 0
            ? _leaveHistory
                      .map((e) => e['id'] as int)
                      .reduce((a, b) => a > b ? a : b) +
                  1
            : 1;

        final fromDate =
            parameters?['fromDate'] ??
            DateTime.now().toIso8601String().substring(0, 10);
        final toDate =
            parameters?['toDate'] ??
            DateTime.now()
                .add(Duration(days: 1))
                .toIso8601String()
                .substring(0, 10);

        // Calculate days between dates
        final from = DateTime.parse(fromDate);
        final to = DateTime.parse(toDate);
        final days = to.difference(from).inDays + 1;

        final newLeave = {
          'id': newLeaveId,
          'type': parameters?['leaveType'] ?? 'Annual Leave',
          'fromDate': fromDate,
          'toDate': toDate,
          'days': days,
          'status': 'Pending',
          'reason': parameters?['reason'] ?? 'Not specified',
        };

        // Add to history
        _leaveHistory.insert(0, newLeave);
        print('📊 Added new leave request to history: #$newLeaveId');

        return {
          'success': true,
          'data': {
            'id': newLeaveId,
            'status': 'Pending',
            'message': 'Leave request submitted successfully',
          },
          'message': 'Leave request submitted successfully',
        };

      case 'GET_EMP_ATTENDANCE':
        return {'success': true, 'data': _attendanceHistory};

      case 'POST_MARK_ATTENDANCE':
        final now = DateTime.now();
        final formattedDate = now.toString().substring(0, 10);
        final time =
            now.hour.toString().padLeft(2, '0') +
            ':' +
            now.minute.toString().padLeft(2, '0') +
            ' ' +
            (now.hour < 12 ? 'AM' : 'PM');

        // Extract location data from parameters if available
        final location = parameters?['location'] ?? 'Office';
        final latitude = parameters?['latitude'] ?? 0.0;
        final longitude = parameters?['longitude'] ?? 0.0;
        final distance = parameters?['distance'] ?? 0.0;

        // Save attendance data for today
        if (parameters?['type'] == 'check_in') {
          _todayAttendance = {
            'date': formattedDate,
            'checkIn': time,
            'checkOut': null,
            'hours': null,
            'status': 'Present',
            'location': location,
            'latitude': latitude,
            'longitude': longitude,
            'distance': distance,
          };

          // Update or add to attendance history
          bool found = false;
          for (var i = 0; i < _attendanceHistory.length; i++) {
            if (_attendanceHistory[i]['date'] == formattedDate) {
              _attendanceHistory[i]['checkIn'] = time;
              _attendanceHistory[i]['location'] = location;
              found = true;
              break;
            }
          }

          if (!found) {
            _attendanceHistory.insert(0, {
              'date': formattedDate,
              'checkIn': time,
              'checkOut': null,
              'hours': null,
              'status': 'Present',
              'location': location,
              'latitude': latitude,
              'longitude': longitude,
            });
          }
        } else if (parameters?['type'] == 'check_out') {
          // Update existing record with check-out time
          if (_todayAttendance.isNotEmpty) {
            _todayAttendance['checkOut'] = time;
            _todayAttendance['checkOutLocation'] = location;

            // Calculate hours if we have both check-in and check-out
            if (_todayAttendance['checkIn'] != null) {
              _todayAttendance['hours'] = 8.0; // Simplified calculation
            }
          }

          // Update attendance history
          for (var i = 0; i < _attendanceHistory.length; i++) {
            if (_attendanceHistory[i]['date'] == formattedDate) {
              _attendanceHistory[i]['checkOut'] = time;
              _attendanceHistory[i]['checkOutLocation'] = location;
              _attendanceHistory[i]['hours'] = 8.0; // Simplified calculation
              break;
            }
          }
        }

        print(
          '📊 Mock attendance updated: ${parameters?['type']} at $time in $location',
        );
        print(
          '📍 Location data: lat $latitude, lng $longitude, distance $distance meters',
        );

        return {
          'success': true,
          'data': {
            'timestamp': now.toIso8601String(),
            'type': parameters?['type'] ?? 'check_in',
            'location': location,
            'message': 'Attendance marked successfully',
          },
        };

      case 'GET_TODAYS_ATTENDANCE':
        final now = DateTime.now();
        final formattedDate = now.toString().substring(0, 10);
        final isWeekend =
            now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;

        // If we have today's attendance record, return it
        if (_todayAttendance.isNotEmpty &&
            _todayAttendance['date'] == formattedDate) {
          return {'success': true, 'data': _todayAttendance};
        }

        // Otherwise generate a default record
        _todayAttendance = {
          'date': formattedDate,
          'checkIn': isWeekend ? null : null, // Start with no check-in
          'checkOut': isWeekend ? null : null,
          'status': isWeekend ? 'Weekend' : 'Not Marked',
          'hours': isWeekend ? 0 : null,
          'location': 'Arfa Tower, Lahore',
          'latitude': 31.4704,
          'longitude': 74.2724,
        };

        return {'success': true, 'data': _todayAttendance};

      default:
        return {
          'success': true,
          'data': {'message': 'Mock response for $spName'},
          'mockData': true,
        };
    }
  }
}
