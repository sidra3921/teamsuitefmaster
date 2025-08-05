class ApiConstants {
  // Base URL - Replace with your actual API URL
  static const String baseUrl = "https://jsonplaceholder.typicode.com";
  static const String realBaseUrl = "https://your-api-domain.com/api/v1";

  // Use test API for now, change to realBaseUrl when ready
  static const String currentBaseUrl = baseUrl;

  // Authentication
  static const String login = "/users/1"; // Mock login endpoint
  static const String register = "/users";

  // Leave Management
  static const String leaveRequests = "/posts"; // Mock with posts
  static const String leaveBalance = "/users/1";
  static const String leaveHistory = "/posts";

  // Attendance
  static const String attendance = "/posts"; // Mock with posts
  static const String attendanceHistory = "/posts";

  // Loan Management
  static const String loanRequests = "/posts";
  static const String loanBalance = "/users/1";
  static const String loanHistory = "/posts";

  // Expense Management
  static const String expenseRequests = "/posts";
  static const String expenseHistory = "/posts";

  // Document Management
  static const String documents = "/posts";
  static const String reports = "/posts";

  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> getAuthHeaders(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}
