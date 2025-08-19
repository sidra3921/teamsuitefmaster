import 'package:flutter/material.dart';
import '../../services/loan_service.dart';

class LoanHistoryScreen extends StatefulWidget {
  const LoanHistoryScreen({super.key});

  @override
  State<LoanHistoryScreen> createState() => _LoanHistoryScreenState();
}

class _LoanHistoryScreenState extends State<LoanHistoryScreen> {
  String _statusFilter = 'All';
  String _yearFilter = '2025';
  bool _isLoading = true;
  List<Map<String, dynamic>> _loanHistory = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLoanHistory();
  }

  Future<void> _fetchLoanHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await LoanService.getLoanHistory();

      if (result['success']) {
        setState(() {
          _loanHistory = List<Map<String, dynamic>>.from(result['data'] ?? []);
          _isLoading = false;
        });
        print('📊 Fetched ${_loanHistory.length} loan history records');
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load loan history';
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

  List<Map<String, dynamic>> get filteredLoanHistory {
    return _loanHistory.where((loan) {
      // Filter by status if not 'All'
      if (_statusFilter != 'All') {
        final loanStatus = loan['status'] as String?;
        if (loanStatus == null) return false;

        final normalizedStatus = loanStatus.toLowerCase();
        final normalizedFilter = _statusFilter.toLowerCase();

        // Handle different status formats (APPROVED vs Approved)
        if (!normalizedStatus.contains(normalizedFilter.toLowerCase())) {
          return false;
        }
      }

      // Filter by year
      if (_yearFilter.isNotEmpty) {
        final requestDate = loan['requestDate'] as String?;
        if (requestDate != null && requestDate.isNotEmpty) {
          final year = requestDate.split('-')[0];
          if (year != _yearFilter) {
            return false;
          }
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan History'),
        backgroundColor: const Color.fromARGB(255, 12, 12, 120),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchLoanHistory,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Loan Application History',
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
                        DropdownMenuItem(
                          value: 'Disbursed',
                          child: Text('Disbursed'),
                        ),
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Filter by Year',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: '2025', child: Text('2025')),
                        DropdownMenuItem(value: '2024', child: Text('2024')),
                        DropdownMenuItem(value: '2023', child: Text('2023')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _yearFilter = value;
                          });
                        }
                      },
                      value: _yearFilter,
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
                          onPressed: _fetchLoanHistory,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (filteredLoanHistory.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'No loan history found for the selected filters',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredLoanHistory.length,
                    itemBuilder: (context, index) {
                      final loan = filteredLoanHistory[index];

                      // Format date from ISO to readable format
                      final isoDate = loan['requestDate'] as String?;
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

                      return _buildLoanHistoryCard(
                        loan['type'] ?? 'Unknown',
                        formattedDate,
                        '\$ ${loan['amount'] ?? '0.00'}',
                        '${loan['installments'] ?? 12} months',
                        loan['reason'] ?? 'Not specified',
                        loan['status'] ?? 'Unknown',
                        _getStatusColor(loan['status']),
                        loan['loanId'] ?? 'Unknown',
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
      case 'DISBURSED':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildLoanHistoryCard(
    String loanType,
    String appliedDate,
    String amount,
    String tenure,
    String reason,
    String status,
    Color statusColor,
    String loanId,
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
                      loanType,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 12, 12, 120),
                      ),
                    ),
                    Text(
                      'ID: $loanId',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    displayStatus,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Applied: $appliedDate',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Amount: $amount',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tenure: $tenure',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text('Purpose: $reason', style: const TextStyle(fontSize: 14)),

            if (displayStatus == 'Approved' ||
                displayStatus == 'Disbursed') ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // View loan details
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
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // Cancel loan request
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
                      // Edit loan request
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
