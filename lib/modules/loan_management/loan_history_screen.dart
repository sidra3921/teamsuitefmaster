import 'package:flutter/material.dart';

class LoanHistoryScreen extends StatelessWidget {
  const LoanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan History'),
        backgroundColor: const Color.fromARGB(255, 12, 12, 120),
        foregroundColor: Colors.white,
      ),
      body: Padding(
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
                        value: 'Completed',
                        child: Text('Completed'),
                      ),
                    ],
                    onChanged: (value) {
                      // Implement filter logic
                    },
                    value: 'All',
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
                      // Implement filter logic
                    },
                    value: '2025',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  _buildLoanHistoryCard(
                    'Personal Loan',
                    '15 Jan 2025',
                    '\$ 25,000',
                    '36 months',
                    'Home renovation',
                    'Approved',
                    Colors.green,
                    'PL001',
                  ),
                  _buildLoanHistoryCard(
                    'Emergency Loan',
                    '10 Mar 2025',
                    '\$ 5,000',
                    '12 months',
                    'Medical emergency',
                    'Completed',
                    Colors.blue,
                    'EL002',
                  ),
                  _buildLoanHistoryCard(
                    'Educational Loan',
                    '05 Aug 2025',
                    '\$ 15,000',
                    '48 months',
                    'Masters degree',
                    'Pending',
                    Colors.orange,
                    'EDL003',
                  ),
                  _buildLoanHistoryCard(
                    'Vehicle Loan',
                    '20 Jun 2025',
                    '\$ 8,000',
                    '24 months',
                    'Car purchase assistance',
                    'Rejected',
                    Colors.red,
                    'VL004',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                    status,
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

            if (status == 'Approved') ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // View loan details
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
            ] else if (status == 'Pending') ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // Cancel loan request
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
            ] else if (status == 'Completed') ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Download completion certificate
                    },
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Certificate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(120, 32),
                    ),
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
