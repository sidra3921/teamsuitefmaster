import 'package:flutter/material.dart';

class LeaveHistoryScreen extends StatelessWidget {
  const LeaveHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave History'),
        backgroundColor: const Color.fromARGB(255, 12, 12, 120),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Leave Application History',
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
                  _buildLeaveHistoryCard(
                    'Annual Leave',
                    '15 Jul 2025 - 19 Jul 2025',
                    '5 days',
                    'Family vacation',
                    'Approved',
                    Colors.green,
                  ),
                  _buildLeaveHistoryCard(
                    'Sick Leave',
                    '02 Aug 2025 - 03 Aug 2025',
                    '2 days',
                    'Fever and cold',
                    'Approved',
                    Colors.green,
                  ),
                  _buildLeaveHistoryCard(
                    'Emergency Leave',
                    '10 Aug 2025',
                    '1 day',
                    'Personal emergency',
                    'Pending',
                    Colors.orange,
                  ),
                  _buildLeaveHistoryCard(
                    'Casual Leave',
                    '25 Jun 2025',
                    '1 day',
                    'Personal work',
                    'Rejected',
                    Colors.red,
                  ),
                  _buildLeaveHistoryCard(
                    'Annual Leave',
                    '10 May 2025 - 12 May 2025',
                    '3 days',
                    'Wedding ceremony',
                    'Approved',
                    Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveHistoryCard(
    String leaveType,
    String dateRange,
    String duration,
    String reason,
    String status,
    Color statusColor,
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
                Text(
                  leaveType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 12, 12, 120),
                  ),
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
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  dateRange,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),

            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  duration,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text('Reason: $reason', style: const TextStyle(fontSize: 14)),

            if (status == 'Pending') ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // Cancel leave request
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Edit leave request
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 12, 12, 120),
                      foregroundColor: Colors.white,
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
