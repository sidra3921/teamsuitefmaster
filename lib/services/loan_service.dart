import 'api_service.dart';
import 'api_constants.dart';
import '../config/app_config.dart';
import 'mock/mock_loan_service.dart';

class LoanService {
  // Submit loan request using ExecSp
  static Future<Map<String, dynamic>> submitLoanRequest(
    Map<String, dynamic> loanData,
  ) async {
    // Use mock service if in mock mode
    if (AppConfig.useMockMode) {
      return MockLoanService.submitLoanRequest(loanData);
    }

    try {
      print('💳 LoanService: Submitting loan request...');

      final result = await ApiService.post(ApiConstants.commonExecSp, {
        'spName': 'POST_LOAN_REQUEST',
        'parameters': loanData,
      }, requireAuth: true);

      print('✅ Submit loan request result: ${result['success']}');

      // If request was successful, automatically refresh the loan history
      if (result['success']) {
        try {
          // Delay slightly to ensure backend has processed the request
          await Future.delayed(Duration(milliseconds: 300));
          print(
            '🔄 Automatically refreshing loan history after successful request...',
          );
          await getLoanHistory(); // This will update the cached data
        } catch (refreshError) {
          print('⚠️ Could not refresh loan history: $refreshError');
          // Non-fatal error, we'll continue with the main operation
        }
      }

      return result;
    } catch (e) {
      print('❌ Submit loan request error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to submit loan request: ${e.toString()}',
      };
    }
  }

  // Get loan history using ExecSp
  static Future<Map<String, dynamic>> getLoanHistory() async {
    // Use mock service if in mock mode
    if (AppConfig.useMockMode) {
      return MockLoanService.getLoanHistory();
    }

    try {
      print('💳 LoanService: Getting loan history...');

      final result = await ApiService.post(ApiConstants.commonExecSp, {
        'spName': 'GET_LOAN_HISTORY',
        'parameters': {},
      }, requireAuth: true);

      print('✅ Loan history result: ${result['success']}');
      return result;
    } catch (e) {
      print('❌ Loan history error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to fetch loan history: ${e.toString()}',
      };
    }
  }

  // Get loan balance using ExecSp
  static Future<Map<String, dynamic>> getLoanBalance() async {
    // Use mock service if in mock mode
    if (AppConfig.useMockMode) {
      return MockLoanService.getLoanBalance();
    }

    try {
      print('💳 LoanService: Getting loan balance...');

      final result = await ApiService.post(ApiConstants.commonExecSp, {
        'spName': 'GET_LOAN_BALANCE',
        'parameters': {},
      }, requireAuth: true);

      print('✅ Loan balance result: ${result['success']}');
      return result;
    } catch (e) {
      print('❌ Loan balance error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to fetch loan balance: ${e.toString()}',
      };
    }
  }

  // Get loan types using ExecSp
  static Future<Map<String, dynamic>> getLoanTypes() async {
    // Use mock service if in mock mode
    if (AppConfig.useMockMode) {
      return MockLoanService.getLoanTypes();
    }

    try {
      print('💳 LoanService: Getting loan types...');

      final result = await ApiService.post(ApiConstants.commonExecSp, {
        'spName': 'GET_LOAN_TYPES',
        'parameters': {},
      }, requireAuth: true);

      print('✅ Loan types result: ${result['success']}');
      return result;
    } catch (e) {
      print('❌ Loan types error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to fetch loan types: ${e.toString()}',
      };
    }
  }

  // Get loan installments using ExecSp
  static Future<Map<String, dynamic>> getLoanInstallments() async {
    // Use mock service if in mock mode
    if (AppConfig.useMockMode) {
      return MockLoanService.getLoanInstallments();
    }

    try {
      print('💳 LoanService: Getting loan installments...');

      final result = await ApiService.post(ApiConstants.commonExecSp, {
        'spName': 'GET_LOAN_INSTALLMENTS',
        'parameters': {},
      }, requireAuth: true);

      print('✅ Loan installments result: ${result['success']}');
      return result;
    } catch (e) {
      print('❌ Loan installments error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to fetch loan installments: ${e.toString()}',
      };
    }
  }
}
