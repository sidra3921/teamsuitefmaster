import 'api_service.dart';
import 'api_constants.dart';
import 'mock_api_service.dart';
import '../config/app_config.dart';
import 'location_service.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceService {
  // Mark attendance using ExecSp with location verification
  static Future<Map<String, dynamic>> markAttendance(
    String type,
    DateTime dateTime,
  ) async {
    try {
      print('📋 AttendanceService: Marking $type attendance...');

      // First verify the user's location
      final locationResult = await LocationService.isWithinOfficeRange();

      // Skip location check in mock mode
      if (!AppConfig.useMockMode && !locationResult['isWithinRange']) {
        print('❌ Location verification failed: ${locationResult['message']}');
        final distance = locationResult['distance'] != double.infinity
            ? '${locationResult['distance'].toStringAsFixed(0)} meters away'
            : 'unknown distance';

        return {
          'success': false,
          'data': null,
          'message': 'You are not in the office vicinity ($distance)',
        };
      }

      // Prepare attendance data with location information
      final attendanceData = {
        'type': type,
        'timestamp': dateTime.toIso8601String(),
        'location': locationResult['locationName'] ?? 'Office',
      };

      // Add location data if available
      if (locationResult['position'] != null) {
        final position = locationResult['position'] as Position;
        attendanceData['latitude'] = position.latitude;
        attendanceData['longitude'] = position.longitude;
        attendanceData['accuracy'] = position.accuracy;
        attendanceData['distance'] = locationResult['distance'];
      }

      // Use mock mode if enabled
      if (AppConfig.useMockMode) {
        print('🎭 Using mock mode for attendance...');
        final result = await MockApiService.mockExecSp(
          'POST_MARK_ATTENDANCE',
          attendanceData,
        );

        // After marking attendance, fetch the updated today's attendance
        // to ensure UI reflects the change immediately
        await getTodayAttendance();

        print('✅ Mark attendance result: ${result['success']}');
        return result;
      }

      // For real API, we can POST directly to an endpoint
      final result = await ApiService.post(
        "Attendance/MarkAttendance",
        attendanceData,
        requireAuth: true,
      );

      print('✅ Mark attendance result: ${result['success']}');

      // After marking attendance, fetch the updated today's attendance
      // to ensure UI reflects the change immediately
      if (result['success'] == true) {
        await getTodayAttendance();
      }

      return result;
    } catch (e) {
      print('❌ Mark attendance error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to mark attendance: ${e.toString()}',
      };
    }
  }

  // Get attendance history using ExecSp
  static Future<Map<String, dynamic>> getAttendanceHistory() async {
    try {
      print('📋 AttendanceService: Getting attendance history...');

      // Use mock mode if enabled
      if (AppConfig.useMockMode) {
        print('🎭 Using mock mode for attendance history...');
        return await MockApiService.mockExecSp('GET_EMP_ATTENDANCE', {});
      }

      // For real API, we can GET directly from an endpoint
      final result = await ApiService.get(
        "Attendance/History",
        requireAuth: true,
      );

      print('✅ Attendance history result: ${result['success']}');
      return result;
    } catch (e) {
      print('❌ Attendance history error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to fetch attendance history: ${e.toString()}',
      };
    }
  }

  // Get today's attendance using ExecSp
  static Future<Map<String, dynamic>> getTodayAttendance() async {
    try {
      print('📋 AttendanceService: Getting today\'s attendance...');

      // Use mock mode if enabled
      if (AppConfig.useMockMode) {
        print('🎭 Using mock mode for attendance operations...');
        return await MockApiService.mockExecSp('GET_TODAYS_ATTENDANCE', {});
      }

      // For real API, we can GET directly from an endpoint
      final result = await ApiService.get(
        "Attendance/Today",
        requireAuth: true,
      );

      print('✅ Today attendance result: ${result['success']}');
      return result;
    } catch (e) {
      print('❌ Today attendance error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to fetch today attendance: ${e.toString()}',
      };
    }
  }
}
