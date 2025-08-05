import 'package:flutter/material.dart';

class PaySlipScreen extends StatelessWidget {
  const PaySlipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PaySlip'),
        backgroundColor: const Color.fromARGB(255, 12, 12, 120),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PaySlip History',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 12, 12, 120),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'View and download your monthly payslips',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Filter Row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Year',
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
                  _buildPaySlipCard('July 2025', 'Paid', '\$ 5,500.00', true),
                  _buildPaySlipCard('June 2025', 'Paid', '\$ 5,500.00', true),
                  _buildPaySlipCard('May 2025', 'Paid', '\$ 5,200.00', true),
                  _buildPaySlipCard('April 2025', 'Paid', '\$ 5,500.00', true),
                  _buildPaySlipCard('March 2025', 'Paid', '\$ 5,500.00', true),
                  _buildPaySlipCard(
                    'February 2025',
                    'Paid',
                    '\$ 5,500.00',
                    true,
                  ),
                  _buildPaySlipCard(
                    'January 2025',
                    'Paid',
                    '\$ 5,500.00',
                    true,
                  ),
                  _buildPaySlipCard(
                    'December 2024',
                    'Paid',
                    '\$ 5,200.00',
                    true,
                  ),
                  _buildPaySlipCard(
                    'November 2024',
                    'Paid',
                    '\$ 5,500.00',
                    true,
                  ),
                  _buildPaySlipCard(
                    'October 2024',
                    'Paid',
                    '\$ 5,500.00',
                    true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaySlipCard(
    String month,
    String status,
    String amount,
    bool isAvailable,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Month and Status
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    month,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 12, 12, 120),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: status == 'Paid'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: status == 'Paid' ? Colors.green : Colors.orange,
                      ),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: status == 'Paid' ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Amount
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Net Pay',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            // Actions
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  if (isAvailable) ...[
                    ElevatedButton.icon(
                      onPressed: () => _viewPaySlip(month),
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('View', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 12, 12, 120),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(80, 32),
                      ),
                    ),
                    const SizedBox(height: 4),
                    OutlinedButton.icon(
                      onPressed: () => _downloadPaySlip(month),
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('PDF', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 12, 12, 120),
                        minimumSize: const Size(80, 32),
                      ),
                    ),
                  ] else ...[
                    const Text(
                      'Not Available',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewPaySlip(String month) {
    // This would typically navigate to a detailed payslip view
    // For now, we'll show a dialog
    // You can implement a detailed payslip screen here
  }

  void _downloadPaySlip(String month) {
    // This would typically download the payslip PDF
    // For now, we'll show a success message
  }
}
