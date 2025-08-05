import '../services/api_service.dart';
import '../services/api_constants.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    // For demo, we'll mock the login
    // Replace this with real API call: return ApiService.post(ApiConstants.login, body);

    // Mock successful login
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    if (email.isNotEmpty && password.isNotEmpty) {
      return {
        'success': true,
        'data': {
          'user': {
            'id': 1,
            'name': 'John Doe',
            'email': email,
            'employee_id': 'EMP001',
          },
          'token': 'mock_token_123456',
        },
        'message': 'Login successful',
      };
    } else {
      return {'success': false, 'data': null, 'message': 'Invalid credentials'};
    }
  }

  static Future<Map<String, dynamic>> register(
    Map<String, dynamic> userData,
  ) async {
    return ApiService.post(ApiConstants.register, userData);
  }

  static Future<void> logout() async {
    await ApiService.logout();
  }

  static Future<bool> isLoggedIn() async {
    return await ApiService.isLoggedIn();
  }
}
