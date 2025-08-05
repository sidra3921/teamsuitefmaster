import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 213, 212, 212),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 12, 120),
        leading: const Icon(Icons.menu),
        foregroundColor: Colors.white,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.message),
                onPressed: () {
                  // Add message icon logic here
                },
              ),
              Positioned(
                top: 10,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '13',
                    style: TextStyle(
                      color: Color.fromARGB(255, 12, 12, 120),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dashboard_bg_shapre.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/bottom_curve.png',
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 80,
                  right: 30,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '+',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 45,
                  right: 80,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 50,
                  child: Transform.rotate(
                    angle: 0.8,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(context, 'Leave Management', [
                    _buildTile(
                      context,
                      'Request',
                      'assets/images/ic_leave_request.png',
                      '/leave-request',
                    ),
                    _buildTile(
                      context,
                      'Balance',
                      'assets/images/ic_leave_balance.png',
                      '/leave-balance',
                    ),
                    _buildTile(
                      context,
                      'History',
                      'assets/images/ic_leave_history.png',
                      '/leave-history',
                    ),
                  ]),
                  _buildSection(context, 'Loan Management', [
                    _buildTile(
                      context,
                      'Request',
                      'assets/images/ic_loan_request.png',
                      '/loan-request',
                    ),
                    _buildTile(
                      context,
                      'Balance',
                      'assets/images/ic_loan_balance.png',
                      '/loan-balance',
                    ),
                    _buildTile(
                      context,
                      'History',
                      'assets/images/ic_loan_history.png',
                      '/loan-history',
                    ),
                  ]),
                  _buildSection(context, 'Attendance', [
                    _buildTile(
                      context,
                      'Mark',
                      'assets/images/ic_attendance_mark.png',
                      '/attendance-mark',
                    ),
                    _buildTile(
                      context,
                      'View',
                      'assets/images/ic_attendance_view.png',
                      '/attendance-view',
                    ),
                    _buildTile(
                      context,
                      'Request',
                      'assets/images/ic_leave_request.png',
                      '/attendance-request',
                    ),
                  ]),
                  _buildSection(context, 'Expense Management', [
                    _buildTile(
                      context,
                      'Advance',
                      'assets/images/ic_expense_advance.png',
                      '/expense-advance',
                    ),
                    _buildTile(
                      context,
                      'Travel',
                      'assets/images/ic_expense_travel.png',
                      '/expense-travel',
                    ),
                    _buildTile(
                      context,
                      'Claim',
                      'assets/images/ic_expense_claim.png',
                      '/expense-claim',
                    ),
                    _buildTile(
                      context,
                      'History',
                      'assets/images/ic_expense_history.png',
                      '/expense-history',
                    ),
                  ]),
                  _buildSection(context, 'Document', [
                    _buildTile(
                      context,
                      'Reports',
                      'assets/images/ic_reports.png',
                      '/reports',
                    ),
                    _buildTile(
                      context,
                      'PaySlip',
                      'assets/images/ic_payslip.png',
                      '/payslip',
                    ),
                  ]),
                  const SizedBox(height: 60), // Reduced space at bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, top: 4.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14, // Smaller title
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 12, 12, 120),
            ),
          ),
        ),
        const SizedBox(height: 6), // Less spacing
        Wrap(
          spacing: 6, // Less spacing
          runSpacing: 6, // Less spacing
          children: tiles,
        ),
        const SizedBox(height: 10), // Less spacing
      ],
    );
  }

  Widget _buildTile(
    BuildContext context,
    String label,
    String imagePath,
    String? route,
  ) {
    // Calculate a smaller size for each tile to fit in one screen
    final tileWidth = (MediaQuery.of(context).size.width - 48) / 3;

    return GestureDetector(
      onTap: () {
        if (route != null) {
          Navigator.pushNamed(context, route);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label feature coming soon!'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      },
      child: Container(
        width: tileWidth,
        height: tileWidth * 0.75, // Reduce height significantly
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: tileWidth * 0.3, // Smaller icon
              child: Image.asset(imagePath),
            ),
            const SizedBox(height: 4), // Less spacing
            Text(
              label,
              style: const TextStyle(
                fontSize: 11, // Smaller text
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 12, 12, 120),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
