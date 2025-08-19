import 'api_service.dart';
import 'api_constants.dart';
import '../config/app_config.dart';
import 'mock/mock_expense_service.dart';

class ExpenseService {
  // Submit expense claim using ExecSp
  static Future<Map<String, dynamic>> submitExpense(
    Map<String, dynamic> expenseData,
  ) async {
    // Use mock service if in mock mode
    if (AppConfig.useMockMode) {
      return MockExpenseService.submitExpense(expenseData);
    }

    try {
      print('💰 ExpenseService: Submitting expense claim...');

      final result = await ApiService.post(ApiConstants.commonExecSp, {
        'spName': 'POST_EXPENSE_CLAIM',
        'parameters': expenseData,
      }, requireAuth: true);

      print('✅ Submit expense result: ${result['success']}');

      // If request was successful, automatically refresh the expense history
      if (result['success']) {
        try {
          // Delay slightly to ensure backend has processed the request
          await Future.delayed(Duration(milliseconds: 300));
          print(
            '🔄 Automatically refreshing expense history after successful request...',
          );
          await getExpenseHistory(); // This will update the cached data
        } catch (refreshError) {
          print('⚠️ Could not refresh expense history: $refreshError');
          // Non-fatal error, we'll continue with the main operation
        }
      }

      return result;
    } catch (e) {
      print('❌ Submit expense error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to submit expense claim: ${e.toString()}',
      };
    }
  }

  // Get expense history using ExecSp
  static Future<Map<String, dynamic>> getExpenseHistory() async {
    // Use mock service if in mock mode
    if (AppConfig.useMockMode) {
      return MockExpenseService.getExpenseHistory();
    }

    try {
      print('💰 ExpenseService: Getting expense history...');

      final result = await ApiService.post(ApiConstants.commonExecSp, {
        'spName': 'GET_EXPENSE_HISTORY',
        'parameters': {},
      }, requireAuth: true);

      print('✅ Expense history result: ${result['success']}');
      return result;
    } catch (e) {
      print('❌ Expense history error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to fetch expense history: ${e.toString()}',
      };
    }
  }

  // Get expense types using ExecSp
  static Future<Map<String, dynamic>> getExpenseTypes() async {
    // Use mock service if in mock mode
    if (AppConfig.useMockMode) {
      return MockExpenseService.getExpenseTypes();
    }

    try {
      print('💰 ExpenseService: Getting expense types...');

      final result = await ApiService.post(ApiConstants.commonExecSp, {
        'spName': 'GET_EXPENSE_TYPES',
        'parameters': {},
      }, requireAuth: true);

      print('✅ Expense types result: ${result['success']}');
      return result;
    } catch (e) {
      print('❌ Expense types error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to fetch expense types: ${e.toString()}',
      };
    }
  }

  // Submit advance expense using ExecSp
  static Future<Map<String, dynamic>> submitAdvanceExpense(
    Map<String, dynamic> advanceData,
  ) async {
    // Use mock service if in mock mode
    if (AppConfig.useMockMode) {
      return MockExpenseService.submitAdvanceExpense(advanceData);
    }

    try {
      print('💰 ExpenseService: Submitting advance expense...');

      final result = await ApiService.post(ApiConstants.commonExecSp, {
        'spName': 'POST_ADVANCE_EXPENSE',
        'parameters': advanceData,
      }, requireAuth: true);

      print('✅ Submit advance expense result: ${result['success']}');

      // If request was successful, automatically refresh the expense history
      if (result['success']) {
        try {
          // Delay slightly to ensure backend has processed the request
          await Future.delayed(Duration(milliseconds: 300));
          print(
            '🔄 Automatically refreshing expense history after successful request...',
          );
          await getExpenseHistory(); // This will update the cached data
        } catch (refreshError) {
          print('⚠️ Could not refresh expense history: $refreshError');
          // Non-fatal error, we'll continue with the main operation
        }
      }

      return result;
    } catch (e) {
      print('❌ Submit advance expense error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to submit advance expense: ${e.toString()}',
      };
    }
  }

  // Submit travel expense using ExecSp
  static Future<Map<String, dynamic>> submitTravelExpense(
    Map<String, dynamic> travelData,
  ) async {
    // Use mock service if in mock mode
    if (AppConfig.useMockMode) {
      return MockExpenseService.submitTravelExpense(travelData);
    }

    try {
      print('💰 ExpenseService: Submitting travel expense...');

      final result = await ApiService.post(ApiConstants.commonExecSp, {
        'spName': 'POST_TRAVEL_EXPENSE',
        'parameters': travelData,
      }, requireAuth: true);

      print('✅ Submit travel expense result: ${result['success']}');

      // If request was successful, automatically refresh the expense history
      if (result['success']) {
        try {
          // Delay slightly to ensure backend has processed the request
          await Future.delayed(Duration(milliseconds: 300));
          print(
            '🔄 Automatically refreshing expense history after successful request...',
          );
          await getExpenseHistory(); // This will update the cached data
        } catch (refreshError) {
          print('⚠️ Could not refresh expense history: $refreshError');
          // Non-fatal error, we'll continue with the main operation
        }
      }

      return result;
    } catch (e) {
      print('❌ Submit travel expense error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to submit travel expense: ${e.toString()}',
      };
    }
  }
}
