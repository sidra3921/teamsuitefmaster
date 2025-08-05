class LeaveService {
  static Future<Map<String, dynamic>> getLeaveBalance() async {
    // Mock data for demo - replace with real API
    await Future.delayed(const Duration(seconds: 1));

    return {
      'success': true,
      'data': {
        'annual_leave': {'total': 25, 'used': 8, 'remaining': 17},
        'sick_leave': {'total': 12, 'used': 3, 'remaining': 9},
        'casual_leave': {'total': 10, 'used': 2, 'remaining': 8},
        'maternity_leave': {'total': 90, 'used': 0, 'remaining': 90},
      },
      'message': 'Leave balance fetched successfully',
    };
  }

  static Future<Map<String, dynamic>> getLeaveHistory() async {
    // Mock data for demo
    await Future.delayed(const Duration(seconds: 1));

    return {
      'success': true,
      'data': [
        {
          'id': 1,
          'type': 'Annual Leave',
          'from_date': '2024-01-15',
          'to_date': '2024-01-17',
          'days': 3,
          'status': 'Approved',
          'reason': 'Family vacation',
        },
        {
          'id': 2,
          'type': 'Sick Leave',
          'from_date': '2024-02-10',
          'to_date': '2024-02-10',
          'days': 1,
          'status': 'Approved',
          'reason': 'Medical appointment',
        },
      ],
      'message': 'Leave history fetched successfully',
    };
  }

  static Future<Map<String, dynamic>> submitLeaveRequest(
    Map<String, dynamic> leaveData,
  ) async {
    // Mock submission
    await Future.delayed(const Duration(seconds: 2));

    return {
      'success': true,
      'data': {
        'id': DateTime.now().millisecondsSinceEpoch,
        'status': 'Pending',
        ...leaveData,
      },
      'message': 'Leave request submitted successfully',
    };
  }
}
