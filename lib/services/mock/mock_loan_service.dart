// Mock implementation of Loan Service
class MockLoanService {
  // In-memory storage for loan history to persist between calls
  static List<Map<String, dynamic>> _loanHistory = List.generate(
    5,
    (index) => {
      'loanId': 'LOAN-${10000 + index}',
      'requestDate': DateTime.now()
          .subtract(Duration(days: index * 30))
          .toIso8601String(),
      'amount': (10000.0 * (index + 1)).toStringAsFixed(2),
      'type': index % 2 == 0 ? 'Personal Loan' : 'Education Loan',
      'status': _getRandomStatus(),
      'approvedDate': index % 3 == 0
          ? DateTime.now()
                .subtract(Duration(days: index * 30 - 2))
                .toIso8601String()
          : null,
      'installments': 12,
      'interestRate': '8.5%',
    },
  );

  // Mock loan request submission
  static Future<Map<String, dynamic>> submitLoanRequest(
    Map<String, dynamic> loanData,
  ) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 800));

    print('💳 MockLoanService: Submitting mock loan request...');
    print('📋 Mock loan data: $loanData');

    // Create a new loan record
    final newLoanId = 'LOAN-${DateTime.now().millisecondsSinceEpoch}';
    final newLoan = {
      'loanId': newLoanId,
      'requestDate': DateTime.now().toIso8601String(),
      'amount': loanData['amount'] ?? '10000.00',
      'type': loanData['loanType'] ?? 'Personal Loan',
      'status': 'PENDING',
      'approvedDate': null,
      'installments': loanData['installments'] ?? 12,
      'interestRate': '8.5%',
      'reason': loanData['reason'] ?? 'Not specified',
    };

    // Add to history
    _loanHistory.insert(0, newLoan);
    print('📊 Added new loan request to history: $newLoanId');

    // Generate a mock response
    return {
      'success': true,
      'data': {
        'requestId': newLoanId,
        'status': 'PENDING',
        'message': 'Your loan request has been submitted successfully',
        'submittedDate': DateTime.now().toIso8601String(),
      },
      'message': 'Loan request submitted successfully',
    };
  }

  // Mock loan history
  static Future<Map<String, dynamic>> getLoanHistory() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 800));

    print('💳 MockLoanService: Getting mock loan history...');
    print('📊 Returning ${_loanHistory.length} loan history records');

    return {
      'success': true,
      'data': _loanHistory,
      'message': 'Loan history retrieved successfully',
    };
  }

  // Mock loan balance
  static Future<Map<String, dynamic>> getLoanBalance() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 600));

    print('💳 MockLoanService: Getting mock loan balance...');

    // Generate mock loan balance data
    final mockBalance = {
      'totalLoans': 2,
      'totalOutstanding': '35000.00',
      'nextPaymentDate': DateTime.now()
          .add(Duration(days: 15))
          .toIso8601String(),
      'nextPaymentAmount': '2916.67',
      'loans': [
        {
          'loanId': 'LOAN-10001',
          'type': 'Personal Loan',
          'originalAmount': '25000.00',
          'outstandingAmount': '20833.33',
          'installmentsPaid': 2,
          'installmentsRemaining': 10,
        },
        {
          'loanId': 'LOAN-10003',
          'type': 'Education Loan',
          'originalAmount': '15000.00',
          'outstandingAmount': '14166.67',
          'installmentsPaid': 1,
          'installmentsRemaining': 11,
        },
      ],
    };

    return {
      'success': true,
      'data': mockBalance,
      'message': 'Loan balance retrieved successfully',
    };
  }

  // Mock loan types
  static Future<Map<String, dynamic>> getLoanTypes() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    print('💳 MockLoanService: Getting mock loan types...');

    // Generate mock loan types
    final mockTypes = [
      {
        'id': 1,
        'name': 'Personal Loan',
        'maxAmount': '50000.00',
        'interestRate': '8.5%',
        'maxTenure': 24,
        'description': 'General purpose personal loan',
      },
      {
        'id': 2,
        'name': 'Education Loan',
        'maxAmount': '100000.00',
        'interestRate': '7.0%',
        'maxTenure': 36,
        'description': 'Loan for educational purposes',
      },
      {
        'id': 3,
        'name': 'Medical Loan',
        'maxAmount': '75000.00',
        'interestRate': '6.5%',
        'maxTenure': 24,
        'description': 'Loan for medical emergencies',
      },
      {
        'id': 4,
        'name': 'Housing Loan',
        'maxAmount': '200000.00',
        'interestRate': '9.0%',
        'maxTenure': 60,
        'description': 'Loan for housing and accommodation',
      },
    ];

    return {
      'success': true,
      'data': mockTypes,
      'message': 'Loan types retrieved successfully',
    };
  }

  // Mock loan installments
  static Future<Map<String, dynamic>> getLoanInstallments() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 700));

    print('💳 MockLoanService: Getting mock loan installments...');

    // Generate mock installments data
    final mockInstallments = List.generate(
      12,
      (index) => {
        'installmentId': 'INST-${20000 + index}',
        'loanId': 'LOAN-10001',
        'dueDate': DateTime.now()
            .add(Duration(days: 30 * index))
            .toIso8601String(),
        'amount': '2083.33',
        'status': index < 2 ? 'PAID' : 'PENDING',
        'paidDate': index < 2
            ? DateTime.now()
                  .subtract(Duration(days: 30 * (2 - index)))
                  .toIso8601String()
            : null,
      },
    );

    return {
      'success': true,
      'data': mockInstallments,
      'message': 'Loan installments retrieved successfully',
    };
  }

  // Helper method to generate random loan status
  static String _getRandomStatus() {
    final statuses = ['APPROVED', 'PENDING', 'REJECTED', 'DISBURSED'];
    final random = DateTime.now().millisecondsSinceEpoch % statuses.length;
    return statuses[random];
  }
}
