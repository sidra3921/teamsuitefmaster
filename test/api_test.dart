import 'package:flutter_test/flutter_test.dart';
import 'package:teamsuitefmaster/services/api_service.dart';
import 'package:teamsuitefmaster/services/auth_service.dart';
import 'package:teamsuitefmaster/services/attendance_service.dart';
import 'package:teamsuitefmaster/config/app_config.dart';

void main() {
  // Enable mock mode for all tests
  setUp(() {
    AppConfig.enableMockMode();
  });

  group('API Integration Tests', () {
    test('API Service should initialize correctly', () {
      expect(ApiService, isNotNull);
    });

    test('Auth Service should initialize correctly', () {
      expect(AuthService, isNotNull);
    });

    test('Auth Service login method should exist', () {
      expect(AuthService.login, isA<Function>());
    });

    test('API Service post method should exist', () {
      expect(ApiService.post, isA<Function>());
    });
  });

  group('Service Method Tests', () {
    test('AuthService login should return a Map', () async {
      // Test with dummy credentials - should return error but not crash
      final result = await AuthService.login('test', 'test');
      expect(result, isA<Map<String, dynamic>>());
      expect(result.containsKey('success'), true);
    });

    test('AttendanceService markAttendance should work in mock mode', () async {
      final result = await AttendanceService.markAttendance(
        'check_in',
        DateTime.now(),
      );
      expect(result, isA<Map<String, dynamic>>());
      expect(result.containsKey('success'), true);
      expect(result['success'], true);
    });

    test(
      'AttendanceService getTodayAttendance should work in mock mode',
      () async {
        final result = await AttendanceService.getTodayAttendance();
        expect(result, isA<Map<String, dynamic>>());
        expect(result.containsKey('success'), true);
        expect(result['success'], true);
      },
    );

    test(
      'Marking attendance should update today\'s attendance record',
      () async {
        // First, check the initial state - may not have check-in yet
        final initialState = await AttendanceService.getTodayAttendance();

        // Mark check-in
        await AttendanceService.markAttendance('check_in', DateTime.now());

        // Get updated attendance
        final updatedState = await AttendanceService.getTodayAttendance();

        // Verify check-in is recorded
        expect(updatedState['success'], true);
        expect(updatedState['data']['checkIn'], isNotNull);

        // Mark check-out
        await AttendanceService.markAttendance('check_out', DateTime.now());

        // Get final state
        final finalState = await AttendanceService.getTodayAttendance();

        // Verify both check-in and check-out are recorded
        expect(finalState['success'], true);
        expect(finalState['data']['checkIn'], isNotNull);
        expect(finalState['data']['checkOut'], isNotNull);
      },
    );
  });
}
