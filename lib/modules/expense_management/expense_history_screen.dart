import 'package:flutter/material.dart';

class ExpenseHistoryScreen extends StatelessWidget {
  const ExpenseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense History'),
        backgroundColor: const Color.fromARGB(255, 12, 12, 120),
        foregroundColor: Colors.white,
      ),
      body: Padding(
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
                      DropdownMenuItem(value: 'Travel', child: Text('Travel')),
                      DropdownMenuItem(value: 'Claim', child: Text('Claim')),
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
                    ],
                    onChanged: (value) {
                      // Implement filter logic
                    },
                    value: 'All',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  _buildExpenseHistoryCard(
                    'Travel Advance',
                    '25 Jul 2025',
                    '\$ 1,500.00',
                    'Business trip to New York',
                    'Approved',
                    Colors.green,
                    'EXP001',
                  ),
                  _buildExpenseHistoryCard(
                    'Expense Claim',
                    '20 Jul 2025',
                    '\$ 450.00',
                    'Client meeting expenses',
                    'Approved',
                    Colors.green,
                    'EXP002',
                  ),
                  _buildExpenseHistoryCard(
                    'Travel Expense',
                    '15 Jul 2025',
                    '\$ 2,200.00',
                    'Conference attendance',
                    'Pending',
                    Colors.orange,
                    'EXP003',
                  ),
                  _buildExpenseHistoryCard(
                    'Office Supplies',
                    '10 Jul 2025',
                    '\$ 125.00',
                    'Stationery and equipment',
                    'Rejected',
                    Colors.red,
                    'EXP004',
                  ),
                  _buildExpenseHistoryCard(
                    'Training Advance',
                    '05 Jul 2025',
                    '\$ 800.00',
                    'Professional certification course',
                    'Approved',
                    Colors.green,
                    'EXP005',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                        status,
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

            if (status == 'Approved') ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // View expense details
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
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // Cancel expense request
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
