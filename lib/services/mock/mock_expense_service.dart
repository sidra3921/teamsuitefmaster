// Mock implementation of Expense Service
class MockExpenseService {
  // In-memory storage for expense history to persist between calls
  static List<Map<String, dynamic>> _expenseHistory = List.generate(
    10,
    (index) => {
      'expenseId': 'EXP-${50000 + index}',
      'requestDate': DateTime.now()
          .subtract(Duration(days: index * 15))
          .toIso8601String(),
      'amount': (index * 1500 + 2000).toStringAsFixed(2),
      'type': _getRandomExpenseType(),
      'status': _getRandomStatus(),
      'approvedDate': index % 3 == 0
          ? DateTime.now()
                .subtract(Duration(days: index * 15 - 2))
                .toIso8601String()
          : null,
      'description':
          'Expense claim for ${_getRandomExpenseType().toLowerCase()}',
    },
  );

  // Mock submit expense
  static Future<Map<String, dynamic>> submitExpense(
    Map<String, dynamic> expenseData,
  ) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 800));

    print('💰 MockExpenseService: Submitting mock expense claim...');
    print('📋 Mock expense data: $expenseData');

    // Create a new expense record
    final newExpenseId = 'EXP-${DateTime.now().millisecondsSinceEpoch}';
    final newExpense = {
      'expenseId': newExpenseId,
      'requestDate': DateTime.now().toIso8601String(),
      'amount': expenseData['amount'] ?? '0.00',
      'type': expenseData['type'] ?? 'General Expense',
      'status': 'PENDING',
      'description': expenseData['description'] ?? 'Not specified',
    };

    // Add to history
    _expenseHistory.insert(0, newExpense);
    print('📊 Added new expense claim to history: $newExpenseId');

    // Generate a mock response
    return {
      'success': true,
      'data': {
        'claimId': newExpenseId,
        'status': 'PENDING',
        'message': 'Your expense claim has been submitted successfully',
        'submittedDate': DateTime.now().toIso8601String(),
        'amount': expenseData['amount'] ?? '0.00',
      },
      'message': 'Expense claim submitted successfully',
    };
  }

  // Mock expense history
  static Future<Map<String, dynamic>> getExpenseHistory() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 700));

    print('💰 MockExpenseService: Getting mock expense history...');
    print('📊 Returning ${_expenseHistory.length} expense history records');

    return {
      'success': true,
      'data': _expenseHistory,
      'message': 'Expense history retrieved successfully',
    };
  }

  // Mock expense types
  static Future<Map<String, dynamic>> getExpenseTypes() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    print('💰 MockExpenseService: Getting mock expense types...');

    // Generate mock expense types
    final mockTypes = [
      {
        'id': 1,
        'name': 'Travel',
        'maxAmount': '10000.00',
        'description': 'For business travel expenses',
        'requiresReceipt': true,
      },
      {
        'id': 2,
        'name': 'Food',
        'maxAmount': '2000.00',
        'description': 'For meal expenses during business activities',
        'requiresReceipt': true,
      },
      {
        'id': 3,
        'name': 'Accommodation',
        'maxAmount': '5000.00',
        'description': 'For hotel and accommodation expenses',
        'requiresReceipt': true,
      },
      {
        'id': 4,
        'name': 'Office Supplies',
        'maxAmount': '3000.00',
        'description': 'For office supplies and equipment',
        'requiresReceipt': true,
      },
      {
        'id': 5,
        'name': 'Communication',
        'maxAmount': '1000.00',
        'description': 'For phone and internet expenses',
        'requiresReceipt': false,
      },
    ];

    return {
      'success': true,
      'data': mockTypes,
      'message': 'Expense types retrieved successfully',
    };
  }

  // Mock submit advance expense
  static Future<Map<String, dynamic>> submitAdvanceExpense(
    Map<String, dynamic> advanceData,
  ) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 900));

    print('💰 MockExpenseService: Submitting mock advance expense...');
    print('📋 Mock advance data: $advanceData');

    // Create a new expense record
    final newExpenseId = 'ADV-${DateTime.now().millisecondsSinceEpoch}';
    final newExpense = {
      'expenseId': newExpenseId,
      'requestDate': DateTime.now().toIso8601String(),
      'amount': advanceData['amount'] ?? '0.00',
      'type': 'Advance',
      'status': 'PENDING',
      'description': advanceData['description'] ?? 'Advance request',
    };

    // Add to history
    _expenseHistory.insert(0, newExpense);
    print('📊 Added new advance request to history: $newExpenseId');

    // Generate a mock response
    return {
      'success': true,
      'data': {
        'advanceId': newExpenseId,
        'status': 'PENDING',
        'message': 'Your advance request has been submitted successfully',
        'submittedDate': DateTime.now().toIso8601String(),
        'amount': advanceData['amount'] ?? '0.00',
        'expectedSettlementDate': DateTime.now()
            .add(Duration(days: 30))
            .toIso8601String(),
      },
      'message': 'Advance expense submitted successfully',
    };
  }

  // Mock submit travel expense
  static Future<Map<String, dynamic>> submitTravelExpense(
    Map<String, dynamic> travelData,
  ) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 850));

    print('💰 MockExpenseService: Submitting mock travel expense...');
    print('📋 Mock travel data: $travelData');

    // Create a new expense record
    final newExpenseId = 'TRV-${DateTime.now().millisecondsSinceEpoch}';
    final newExpense = {
      'expenseId': newExpenseId,
      'requestDate': DateTime.now().toIso8601String(),
      'amount': travelData['amount'] ?? '0.00',
      'type': 'Travel',
      'status': 'PENDING',
      'description':
          travelData['description'] ??
          'Travel to ${travelData['destination'] ?? 'Unknown'}',
      'destination': travelData['destination'] ?? 'Not specified',
      'fromDate': travelData['fromDate'],
      'toDate': travelData['toDate'],
    };

    // Add to history
    _expenseHistory.insert(0, newExpense);
    print('📊 Added new travel expense to history: $newExpenseId');

    // Generate a mock response
    return {
      'success': true,
      'data': {
        'travelId': newExpenseId,
        'status': 'PENDING',
        'message': 'Your travel expense has been submitted successfully',
        'submittedDate': DateTime.now().toIso8601String(),
        'amount': travelData['amount'] ?? '0.00',
        'destination': travelData['destination'] ?? 'Not specified',
        'travelDates': {
          'from': travelData['fromDate'],
          'to': travelData['toDate'],
        },
      },
      'message': 'Travel expense submitted successfully',
    };
  }

  // Helper method to generate random expense type
  static String _getRandomExpenseType() {
    final types = [
      'Travel',
      'Food',
      'Accommodation',
      'Office Supplies',
      'Communication',
    ];
    final random = DateTime.now().millisecondsSinceEpoch % types.length;
    return types[random];
  }

  // Helper method to generate random expense status
  static String _getRandomStatus() {
    final statuses = ['APPROVED', 'PENDING', 'REJECTED', 'PAID'];
    final random = DateTime.now().millisecondsSinceEpoch % statuses.length;
    return statuses[random];
  }
}
