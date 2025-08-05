class AttendanceService {
  static Future<Map<String, dynamic>> markAttendance(
    String type,
    DateTime dateTime,
  ) async {
    // Mock attendance marking
    await Future.delayed(const Duration(seconds: 1));

    return {
      'success': true,
      'data': {
        'id': DateTime.now().millisecondsSinceEpoch,
        'type': type, // 'check_in' or 'check_out'
        'timestamp': dateTime.toString(),
        'location': 'Office',
      },
      'message': '$type successful',
    };
  }

  static Future<Map<String, dynamic>> getAttendanceHistory() async {
    // Mock data
    await Future.delayed(const Duration(seconds: 1));

    return {
      'success': true,
      'data': [
        {
          'date': '2024-01-15',
          'check_in': '09:00 AM',
          'check_out': '06:00 PM',
          'total_hours': '9h 0m',
          'status': 'Present',
        },
        {
          'date': '2024-01-14',
          'check_in': '09:15 AM',
          'check_out': '06:30 PM',
          'total_hours': '9h 15m',
          'status': 'Present',
        },
      ],
      'message': 'Attendance history fetched successfully',
    };
  }

  static Future<Map<String, dynamic>> getTodayAttendance() async {
    await Future.delayed(const Duration(seconds: 1));

    return {
      'success': true,
      'data': {
        'date': DateTime.now().toString().split(' ')[0],
        'check_in': null,
        'check_out': null,
        'total_hours': '0h 0m',
        'status': 'Not Marked',
      },
      'message': 'Today attendance status',
    };
  }
}
