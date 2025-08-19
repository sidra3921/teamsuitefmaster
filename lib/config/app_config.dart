// Environment configuration for TeamSuite
class AppConfig {
  // Toggle between modes
  static bool get useMockMode => _useMockMode;
  static bool _useMockMode = true; // Change to false when backend is ready

  static bool get isProduction => !_useMockMode;
  static bool get isDevelopment => _useMockMode;

  // API Configuration
  static String get apiBaseUrl {
    return _useMockMode
        ? "https://jsonplaceholder.typicode.com" // Public test API for development
        : "https://17dx7l6cz8.execute-api.ap-south-1.amazonaws.com/Prod"; // AWS API Gateway
  }

  // Connection header value
  static const String xConnValue =
      "MzI1NHJ2NzJ0eXYyMnlnaGMH3I3OWorG43voa01IuAOt1+/B4XUEl6dURJZXZAf8Rt+X4PU8jt057BOd68APYWmNrXbbHSH7igij7NMBlQuIh0cELSuHVQJz1r7rezi7sZvA7OEyTP6cA37o1eMoT+ZSXwbXDPhk7H32idaIzLc4zggbxMQegCsko8u1WzgZ";

  // Default credentials for testing
  static const String defaultUsername = "manager";
  static const String defaultPassword = "FSDEMO123";
  static const String defaultPin = "demo";

  // Feature flags
  static bool get enableDebugLogs => isDevelopment;
  static bool get enableMockAuthentication => useMockMode;
  static bool get enableOfflineMode => useMockMode;

  // Methods to switch modes
  static void enableMockMode() {
    _useMockMode = true;
  }

  static void enableProductionMode() {
    _useMockMode = false;
  }

  // Environment info
  static Map<String, dynamic> get environmentInfo => {
    'mode': useMockMode ? 'MOCK' : 'PRODUCTION',
    'apiUrl': apiBaseUrl,
    'version': '1.0.0',
    'timestamp': DateTime.now().toIso8601String(),
  };
}
