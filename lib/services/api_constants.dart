import '../config/app_config.dart';

class ApiConstants {
  // Base URL - Using AppConfig for environment switching
  static String get baseUrl => AppConfig.apiBaseUrl;
  static String get currentBaseUrl => baseUrl;

  // Error Messages
  static const String somethingWentWrong = "Something went wrong...";

  // Authentication Endpoints
  static const String token = "Token";
  static const String getClientInfo = "MultiTenant/GetClientInfo";

  // Common API endpoints
  static const String commonExecSp = "Api/Common/ExecSp";
  static const String getLookupDataSet = "Api/Common/GetLookUpDataSet";

  // Helper method to build URL safely
  static String buildUrl(String baseUrl, String endpoint) {
    // Remove trailing slashes from base and leading slashes from endpoint
    final base = baseUrl.replaceAll(RegExp(r'/+$'), '');
    final path = endpoint.replaceAll(RegExp(r'^/+'), '');
    return "$base/$path";
  }

  // Headers for JSON requests
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'x-conn': AppConfig.xConnValue,
  };

  // Headers with auth token
  static Map<String, String> getAuthHeaders(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    'x-conn': AppConfig.xConnValue,
  };
}
