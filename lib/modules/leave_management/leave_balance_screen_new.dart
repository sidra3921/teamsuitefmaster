import 'package:flutter/material.dart';
import '../../services/leave_service.dart';

class LeaveBalanceScreen extends StatefulWidget {
  const LeaveBalanceScreen({super.key});

  @override
  State<LeaveBalanceScreen> createState() => _LeaveBalanceScreenState();
}

class _LeaveBalanceScreenState extends State<LeaveBalanceScreen> {
  Map<String, dynamic>? _leaveBalance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaveBalance();
  }

  Future<void> _loadLeaveBalance() async {
    try {
      final result = await LeaveService.getLeaveBalance();
      if (mounted) {
        setState(() {
          _leaveBalance = result['success'] ? result['data'] : null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Balance'),
        backgroundColor: const Color.fromARGB(255, 12, 12, 120),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _leaveBalance == null
          ? const Center(
              child: Text(
                'Failed to load leave balance',
                style: TextStyle(fontSize: 16),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Leave Balance',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 12, 12, 120),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Annual Summary Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Color.fromARGB(255, 12, 12, 120),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Annual Summary ${DateTime.now().year}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 12, 12, 120),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildSummaryItem(
                                'Total',
                                _getTotalLeaves().toString(),
                                Colors.blue,
                              ),
                              _buildSummaryItem(
                                'Used',
                                _getUsedLeaves().toString(),
                                Colors.orange,
                              ),
                              _buildSummaryItem(
                                'Remaining',
                                _getRemainingLeaves().toString(),
                                Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Leave Types
                  const Text(
                    'Leave Types',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 12, 12, 120),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: ListView(
                      children: [
                        if (_leaveBalance!['annual_leave'] != null)
                          _buildLeaveTypeCard(
                            'Annual Leave',
                            _leaveBalance!['annual_leave']['total'],
                            _leaveBalance!['annual_leave']['used'],
                            _leaveBalance!['annual_leave']['remaining'],
                          ),
                        if (_leaveBalance!['sick_leave'] != null)
                          _buildLeaveTypeCard(
                            'Sick Leave',
                            _leaveBalance!['sick_leave']['total'],
                            _leaveBalance!['sick_leave']['used'],
                            _leaveBalance!['sick_leave']['remaining'],
                          ),
                        if (_leaveBalance!['casual_leave'] != null)
                          _buildLeaveTypeCard(
                            'Casual Leave',
                            _leaveBalance!['casual_leave']['total'],
                            _leaveBalance!['casual_leave']['used'],
                            _leaveBalance!['casual_leave']['remaining'],
                          ),
                        if (_leaveBalance!['maternity_leave'] != null)
                          _buildLeaveTypeCard(
                            'Maternity Leave',
                            _leaveBalance!['maternity_leave']['total'],
                            _leaveBalance!['maternity_leave']['used'],
                            _leaveBalance!['maternity_leave']['remaining'],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildLeaveTypeCard(String title, int total, int used, int remaining) {
    double progress = total > 0 ? used / total : 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$remaining left',
                  style: TextStyle(
                    color: remaining > 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress < 0.7
                    ? Colors.green
                    : progress < 0.9
                    ? Colors.orange
                    : Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Used: $used', style: TextStyle(color: Colors.grey[600])),
                Text(
                  'Total: $total',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _getTotalLeaves() {
    if (_leaveBalance == null) return 0;
    int total = 0;
    _leaveBalance!.forEach((key, value) {
      if (value is Map<String, dynamic> && value['total'] != null) {
        total += value['total'] as int;
      }
    });
    return total;
  }

  int _getUsedLeaves() {
    if (_leaveBalance == null) return 0;
    int used = 0;
    _leaveBalance!.forEach((key, value) {
      if (value is Map<String, dynamic> && value['used'] != null) {
        used += value['used'] as int;
      }
    });
    return used;
  }

  int _getRemainingLeaves() {
    if (_leaveBalance == null) return 0;
    int remaining = 0;
    _leaveBalance!.forEach((key, value) {
      if (value is Map<String, dynamic> && value['remaining'] != null) {
        remaining += value['remaining'] as int;
      }
    });
    return remaining;
  }
}
