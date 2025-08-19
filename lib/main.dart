import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/api_demo_screen.dart';

// Leave Management
import 'modules/leave_management/leave_request_screen.dart';
import 'modules/leave_management/leave_balance_screen.dart';
import 'modules/leave_management/leave_history_screen.dart';

// Loan Management
import 'modules/loan_management/loan_request_screen.dart';
import 'modules/loan_management/loan_balance_screen.dart';
import 'modules/loan_management/loan_history_screen.dart';

// Attendance
import 'modules/attendance/attendance_mark_screen.dart';
import 'modules/attendance/attendance_view_screen.dart';
import 'modules/attendance/attendance_request_screen.dart';
import 'modules/attendance/location_test_screen.dart';

// Expense Management
import 'modules/expense_management/expense_advance_screen.dart';
import 'modules/expense_management/expense_travel_screen.dart';
import 'modules/expense_management/expense_claim_screen.dart';
import 'modules/expense_management/expense_history_screen.dart';

// Document Management
import 'modules/document_management/reports_screen.dart';
import 'modules/document_management/payslip_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TEMSUITE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 12, 12, 120),
        ),
        primaryColor: const Color.fromARGB(255, 12, 12, 120),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 12, 12, 120),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),

        // Leave Management Routes
        '/leave-request': (context) => const LeaveRequestScreen(),
        '/leave-balance': (context) => const LeaveBalanceScreen(),
        '/leave-history': (context) => const LeaveHistoryScreen(),

        // Loan Management Routes
        '/loan-request': (context) => const LoanRequestScreen(),
        '/loan-balance': (context) => const LoanBalanceScreen(),
        '/loan-history': (context) => const LoanHistoryScreen(),

        // Attendance Routes
        '/attendance-mark': (context) => const AttendanceMarkScreen(),
        '/attendance-view': (context) => const AttendanceViewScreen(),
        '/attendance-request': (context) => const AttendanceRequestScreen(),
        '/location-test': (context) => const LocationTestScreen(),

        // Expense Management Routes
        '/expense-advance': (context) => const ExpenseAdvanceScreen(),
        '/expense-travel': (context) => const ExpenseTravelScreen(),
        '/expense-claim': (context) => const ExpenseClaimScreen(),
        '/expense-history': (context) => const ExpenseHistoryScreen(),

        // Document Management Routes
        '/reports': (context) => const ReportsScreen(),
        '/payslip': (context) => const PaySlipScreen(),

        // API Demo Route
        '/api-demo': (context) => const ApiDemoScreen(),
      },
    );
  }
}
