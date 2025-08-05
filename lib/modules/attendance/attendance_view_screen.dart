import 'package:flutter/material.dart';

class AttendanceViewScreen extends StatelessWidget {
  const AttendanceViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance View'),
        backgroundColor: const Color.fromARGB(255, 12, 12, 120),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attendance Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 12, 12, 120),
              ),
            ),
            const SizedBox(height: 20),

            // Monthly Summary Card
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
                          Icons.calendar_month,
                          color: Color.fromARGB(255, 12, 12, 120),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'August 2025 Summary',
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
                        _buildSummaryItem('Present', '18', Colors.green),
                        _buildSummaryItem('Absent', '2', Colors.red),
                        _buildSummaryItem('Late', '3', Colors.orange),
                        _buildSummaryItem('Half Day', '1', Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Filter Row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Month',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'August 2025',
                        child: Text('August 2025'),
                      ),
                      DropdownMenuItem(
                        value: 'July 2025',
                        child: Text('July 2025'),
                      ),
                      DropdownMenuItem(
                        value: 'June 2025',
                        child: Text('June 2025'),
                      ),
                    ],
                    onChanged: (value) {
                      // Implement filter logic
                    },
                    value: 'August 2025',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Daily Attendance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 12, 12, 120),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: [
                  _buildAttendanceCard(
                    '04 Aug 2025',
                    'Sunday',
                    'Present',
                    '09:00 AM',
                    '06:00 PM',
                    '9h 0m',
                    Colors.green,
                  ),
                  _buildAttendanceCard(
                    '03 Aug 2025',
                    'Saturday',
                    'Present',
                    '09:15 AM',
                    '06:15 PM',
                    '9h 0m',
                    Colors.green,
                  ),
                  _buildAttendanceCard(
                    '02 Aug 2025',
                    'Friday',
                    'Late',
                    '09:30 AM',
                    '06:30 PM',
                    '9h 0m',
                    Colors.orange,
                  ),
                  _buildAttendanceCard(
                    '01 Aug 2025',
                    'Thursday',
                    'Present',
                    '08:45 AM',
                    '05:45 PM',
                    '9h 0m',
                    Colors.green,
                  ),
                  _buildAttendanceCard(
                    '31 Jul 2025',
                    'Wednesday',
                    'Half Day',
                    '09:00 AM',
                    '01:00 PM',
                    '4h 0m',
                    Colors.blue,
                  ),
                  _buildAttendanceCard(
                    '30 Jul 2025',
                    'Tuesday',
                    'Absent',
                    '--',
                    '--',
                    '0h 0m',
                    Colors.red,
                  ),
                  _buildAttendanceCard(
                    '29 Jul 2025',
                    'Monday',
                    'Present',
                    '08:50 AM',
                    '05:50 PM',
                    '9h 0m',
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

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceCard(
    String date,
    String day,
    String status,
    String checkIn,
    String checkOut,
    String totalHours,
    Color statusColor,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Date Column
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 12, 12, 120),
                    ),
                  ),
                  Text(
                    day,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            const SizedBox(width: 12),

            // Time Details
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (status != 'Absent') ...[
                    Text(
                      '$checkIn - $checkOut',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      totalHours,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ] else ...[
                    const Text(
                      'No attendance',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
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
}
