import 'api_service.dart';
import 'api_constants.dart';
import '../config/app_config.dart';
import 'mock/mock_payslip_service.dart';

class PayslipService {
  // Get payslip data using ExecSp
  static Future<Map<String, dynamic>> getPayslip(String monthYear) async {
    // Use mock service if in mock mode
    if (AppConfig.useMockMode) {
      return MockPayslipService.getPayslip(monthYear);
    }

    try {
      print('📄 PayslipService: Getting payslip for $monthYear...');

      final result = await ApiService.post(ApiConstants.commonExecSp, {
        'spName': 'GET_PAYSLIP',
        'parameters': {'monthYear': monthYear},
      }, requireAuth: true);

      print('✅ Get payslip result: ${result['success']}');
      return result;
    } catch (e) {
      print('❌ Get payslip error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to fetch payslip: ${e.toString()}',
      };
    }
  }

  // Get payslip history using ExecSp
  static Future<Map<String, dynamic>> getPayslipHistory() async {
    // Use mock service if in mock mode
    if (AppConfig.useMockMode) {
      return MockPayslipService.getPayslipHistory();
    }

    try {
      print('📄 PayslipService: Getting payslip history...');

      final result = await ApiService.post(ApiConstants.commonExecSp, {
        'spName': 'GET_PAYSLIP_HISTORY',
        'parameters': {},
      }, requireAuth: true);

      print('✅ Payslip history result: ${result['success']}');
      return result;
    } catch (e) {
      print('❌ Payslip history error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to fetch payslip history: ${e.toString()}',
      };
    }
  }

  // Download payslip PDF using ExecSp
  static Future<Map<String, dynamic>> downloadPayslipPDF(
    String monthYear,
  ) async {
    // Use mock service if in mock mode
    if (AppConfig.useMockMode) {
      return MockPayslipService.downloadPayslipPDF(monthYear);
    }

    try {
      print('📄 PayslipService: Downloading payslip PDF for $monthYear...');

      final result = await ApiService.post(ApiConstants.commonExecSp, {
        'spName': 'DOWNLOAD_PAYSLIP_PDF',
        'parameters': {'monthYear': monthYear},
      }, requireAuth: true);

      print('✅ Download payslip PDF result: ${result['success']}');
      return result;
    } catch (e) {
      print('❌ Download payslip PDF error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Failed to download payslip PDF: ${e.toString()}',
      };
    }
  }
}
