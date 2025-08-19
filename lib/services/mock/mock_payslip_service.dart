// Mock implementation of Payslip Service
class MockPayslipService {
  // Mock get payslip
  static Future<Map<String, dynamic>> getPayslip(String monthYear) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 800));

    print('📄 MockPayslipService: Getting mock payslip for $monthYear...');

    // Parse the month and year from the monthYear string
    final parts = monthYear.split('-');
    final month = int.tryParse(parts[0]) ?? 1;
    final year = int.tryParse(parts[1]) ?? 2023;

    // Generate a mock payslip
    final mockPayslip = {
      'employeeId': 'EMP-1001',
      'employeeName': 'John Doe',
      'department': 'Engineering',
      'designation': 'Senior Developer',
      'monthYear': monthYear,
      'dateOfJoining': '2019-06-15',
      'bankAccount': 'XXXX-XXXX-1234',
      'uan': '1001-2345-6789',
      'basicSalary': '45000.00',
      'houseRentAllowance': '18000.00',
      'conveyanceAllowance': '3000.00',
      'medicalAllowance': '2500.00',
      'specialAllowance': '7500.00',
      'grossEarnings': '76000.00',
      'providentFund': '5400.00',
      'professionalTax': '200.00',
      'incomeTax': '5800.00',
      'totalDeductions': '11400.00',
      'netPayable': '64600.00',
      'paidOn': '${year}-${month.toString().padLeft(2, '0')}-28',
      'leaves': {'casual': '1.0', 'sick': '0.5', 'earned': '0.0'},
    };

    return {
      'success': true,
      'data': mockPayslip,
      'message': 'Payslip retrieved successfully',
    };
  }

  // Mock payslip history
  static Future<Map<String, dynamic>> getPayslipHistory() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 700));

    print('📄 MockPayslipService: Getting mock payslip history...');

    // Generate a mock payslip history
    final currentDate = DateTime.now();
    final mockHistory = List.generate(12, (index) {
      final month = (currentDate.month - index) <= 0
          ? (currentDate.month - index + 12)
          : (currentDate.month - index);
      final year = (currentDate.month - index) <= 0
          ? (currentDate.year - 1)
          : currentDate.year;

      return {
        'monthYear': '${month.toString().padLeft(2, '0')}-$year',
        'netPayable': (60000 + (index * 1000 % 5000)).toStringAsFixed(2),
        'grossEarnings': (76000 + (index * 1500 % 7000)).toStringAsFixed(2),
        'paidOn': '${year}-${month.toString().padLeft(2, '0')}-28',
        'hasDownloadedPDF': index < 6, // Last 6 months have PDFs
      };
    });

    return {
      'success': true,
      'data': mockHistory,
      'message': 'Payslip history retrieved successfully',
    };
  }

  // Mock download payslip PDF
  static Future<Map<String, dynamic>> downloadPayslipPDF(
    String monthYear,
  ) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 1200));

    print(
      '📄 MockPayslipService: Downloading mock payslip PDF for $monthYear...',
    );

    // Generate a mock PDF download response
    return {
      'success': true,
      'data': {
        'pdfBase64': 'JVBERi0xLjMKJcTl8uXrp...', // Mock truncated base64 string
        'filename': 'payslip_$monthYear.pdf',
        'mimeType': 'application/pdf',
      },
      'message': 'Payslip PDF downloaded successfully',
    };
  }
}
