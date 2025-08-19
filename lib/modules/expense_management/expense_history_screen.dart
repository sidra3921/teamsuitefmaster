import 'package:flutter/material.dart';
import '../../services/expense_service.dart';

class ExpenseHistoryScreen extends StatefulWidget {
  const ExpenseHistoryScreen({super.key});

  @override
  State<ExpenseHistoryScreen> createState() => _ExpenseHistoryScreenState();
}

class _ExpenseHistoryScreenState extends State<ExpenseHistoryScreen> {
  String _typeFilter = 'All';
  String _statusFilter = 'All';
  bool _isLoading = true;
  List<Map<String, dynamic>> _expenseHistory = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchExpenseHistory();
  }

  Future<void> _fetchExpenseHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await ExpenseService.getExpenseHistory();

      if (result['success']) {
        setState(() {
          _expenseHistory = List<Map<String, dynamic>>.from(
            result['data'] ?? [],
          );
          _isLoading = false;
        });
        print('📊 Fetched ${_expenseHistory.length} expense history records');
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load expense history';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get filteredExpenseHistory {
    return _expenseHistory.where((expense) {
      // Filter by type if not 'All'
      if (_typeFilter != 'All') {
        final expenseType = expense['type'] as String?;
        if (expenseType == null) return false;

        if (!expenseType.toLowerCase().contains(_typeFilter.toLowerCase())) {
          return false;
        }
      }

      // Filter by status if not 'All'
      if (_statusFilter != 'All') {
        final expenseStatus = expense['status'] as String?;
        if (expenseStatus == null) return false;

        if (!expenseStatus.toLowerCase().contains(
          _statusFilter.toLowerCase(),
        )) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense History'),
        backgroundColor: const Color.fromARGB(255, 12, 12, 120),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchExpenseHistory,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Expense History',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 12, 12, 120),
                ),
              ),
              const SizedBox(height: 20),

              // Filter Row
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Filter by Type',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('All')),
                        DropdownMenuItem(
                          value: 'Advance',
                          child: Text('Advance'),
                        ),
                        DropdownMenuItem(
                          value: 'Travel',
                          child: Text('Travel'),
                        ),
                        DropdownMenuItem(value: 'Food', child: Text('Food')),
                        DropdownMenuItem(
                          value: 'Office',
                          child: Text('Office'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _typeFilter = value;
                          });
                        }
                      },
                      value: _typeFilter,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Filter by Status',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('All')),
                        DropdownMenuItem(
                          value: 'Approved',
                          child: Text('Approved'),
                        ),
                        DropdownMenuItem(
                          value: 'Pending',
                          child: Text('Pending'),
                        ),
                        DropdownMenuItem(
                          value: 'Rejected',
                          child: Text('Rejected'),
                        ),
                        DropdownMenuItem(value: 'Paid', child: Text('Paid')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _statusFilter = value;
                          });
                        }
                      },
                      value: _statusFilter,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (_isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_errorMessage != null)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchExpenseHistory,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (filteredExpenseHistory.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'No expense history found for the selected filters',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredExpenseHistory.length,
                    itemBuilder: (context, index) {
                      final expense = filteredExpenseHistory[index];

                      // Format date from ISO to readable format
                      final isoDate = expense['requestDate'] as String?;
                      String formattedDate = 'Unknown date';
                      if (isoDate != null && isoDate.isNotEmpty) {
                        try {
                          final dateTime = DateTime.parse(isoDate);
                          formattedDate =
                              '${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}';
                        } catch (e) {
                          formattedDate = isoDate;
                        }
                      }

                      return _buildExpenseHistoryCard(
                        expense['type'] ?? 'Unknown',
                        formattedDate,
                        '\$ ${expense['amount'] ?? '0.00'}',
                        expense['description'] ?? 'No description provided',
                        expense['status'] ?? 'Unknown',
                        _getStatusColor(expense['status']),
                        expense['expenseId'] ?? 'Unknown',
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;

    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'REJECTED':
        return Colors.red;
      case 'PAID':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildExpenseHistoryCard(
    String expenseType,
    String date,
    String amount,
    String description,
    String status,
    Color statusColor,
    String expenseId,
  ) {
    // Normalize status for display
    final displayStatus =
        status.substring(0, 1).toUpperCase() +
        status.substring(1).toLowerCase();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expenseType,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 12, 12, 120),
                      ),
                    ),
                    Text(
                      'ID: $expenseId',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      amount,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: statusColor),
                      ),
                      child: Text(
                        displayStatus,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text(description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),

            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Date: $date',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            if (displayStatus == 'Approved' || displayStatus == 'Paid') ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // View expense details
                      // TODO: Implement view details functionality
                    },
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 12, 12, 120),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(120, 32),
                    ),
                  ),
                ],
              ),
            ] else if (displayStatus == 'Pending') ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // Cancel expense request
                      // TODO: Implement cancel functionality
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Edit expense request
                      // TODO: Implement edit functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 12, 12, 120),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(80, 32),
                    ),
                    child: const Text('Edit'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
