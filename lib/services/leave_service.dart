import 'api_service.dart';
import 'api_constants.dart';
import 'mock_api_service.dart';
import '../config/app_config.dart';

class LeaveService {
  // Get leave balance
  static Future<Map<String, dynamic>> getLeaveBalance() async {
    try {
      print('📋 LeaveService: Getting leave balance...');

      // Use mock mode if enabled
      if (AppConfig.useMockMode) {
        print('🎭 Using mock mode for leave balance...');
        return await MockApiService.mockExecSp('GET_LEAVE_BALANCE', {});
      }

      final result = await ApiService.get("Leave/Balance", requireAuth: true);

      print('✅ Leave balance result: ${result['success']}');
      return result;
    } catch (e) {
      print('❌ Leave balance error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to fetch leave balance: ${e.toString()}',
      };
    }
  }

  // Get leave history
  static Future<Map<String, dynamic>> getLeaveHistory() async {
    try {
      print('📋 LeaveService: Getting leave history...');

      // Use mock mode if enabled
      if (AppConfig.useMockMode) {
        print('🎭 Using mock mode for leave history...');
        return await MockApiService.mockExecSp('GET_LEAVE_HISTORY', {});
      }

      final result = await ApiService.get("Leave/History", requireAuth: true);

      print('✅ Leave history result: ${result['success']}');
      return result;
    } catch (e) {
      print('❌ Leave history error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to fetch leave history: ${e.toString()}',
      };
    }
  }

  // Submit leave request
  static Future<Map<String, dynamic>> submitLeaveRequest(
    Map<String, dynamic> leaveData,
  ) async {
    try {
      print('📋 LeaveService: Submitting leave request...');

      // Use mock mode if enabled
      if (AppConfig.useMockMode) {
        print('🎭 Using mock mode for leave request...');
        return await MockApiService.mockExecSp('POST_LEAVE_REQUEST', leaveData);
      }

      final result = await ApiService.post(
        "Leave/Request",
        leaveData,
        requireAuth: true,
      );

      print('✅ Leave request result: ${result['success']}');

      // If request was successful, automatically refresh the leave history
      if (result['success']) {
        try {
          // Delay slightly to ensure backend has processed the request
          await Future.delayed(Duration(milliseconds: 300));
          print(
            '🔄 Automatically refreshing leave history after successful request...',
          );
          await getLeaveHistory(); // This will update the cached data
        } catch (refreshError) {
          print('⚠️ Could not refresh leave history: $refreshError');
          // Non-fatal error, we'll continue with the main operation
        }
      }

      return result;
    } catch (e) {
      print('❌ Leave request error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to submit leave request: ${e.toString()}',
      };
    }
  }
}
