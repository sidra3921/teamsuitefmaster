import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: const Color.fromARGB(255, 12, 12, 120),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Employee Reports',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 12, 12, 120),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Access and download your reports',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildReportCard(
                    'Attendance Report',
                    Icons.access_time,
                    'Monthly attendance summary',
                    Colors.blue,
                    () => _generateReport(context, 'Attendance'),
                  ),
                  _buildReportCard(
                    'Leave Report',
                    Icons.calendar_month,
                    'Leave history and balance',
                    Colors.green,
                    () => _generateReport(context, 'Leave'),
                  ),
                  _buildReportCard(
                    'Expense Report',
                    Icons.receipt,
                    'Expense claims summary',
                    Colors.orange,
                    () => _generateReport(context, 'Expense'),
                  ),
                  _buildReportCard(
                    'Loan Report',
                    Icons.account_balance,
                    'Loan history and balance',
                    Colors.purple,
                    () => _generateReport(context, 'Loan'),
                  ),
                  _buildReportCard(
                    'Performance Report',
                    Icons.trending_up,
                    'Performance evaluation',
                    Colors.teal,
                    () => _generateReport(context, 'Performance'),
                  ),
                  _buildReportCard(
                    'Training Report',
                    Icons.school,
                    'Training courses completed',
                    Colors.indigo,
                    () => _generateReport(context, 'Training'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(
    String title,
    IconData icon,
    String description,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _generateReport(BuildContext context, String reportType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$reportType Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select report period:'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _downloadReport(context, reportType, 'This Month');
                },
                child: const Text('This Month'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _downloadReport(context, reportType, 'Last 3 Months');
                },
                child: const Text('Last 3 Months'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _downloadReport(context, reportType, 'This Year');
                },
                child: const Text('This Year'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _downloadReport(BuildContext context, String reportType, String period) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$reportType report for $period is being generated...'),
        backgroundColor: Colors.green,
      ),
    );

    // Simulate download process
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$reportType report downloaded successfully!'),
          backgroundColor: Colors.blue,
        ),
      );
    });
  }
}
