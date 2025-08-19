import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_constants.dart';
import 'mock_api_service.dart';
import '../config/app_config.dart';

class AuthService {
  static bool get useMockMode => AppConfig.useMockMode;
  static String? _token;

  static Future<Map<String, dynamic>> login(
    String username,
    String password, {
    String? pin,
  }) async {
    try {
      print('🔐 AuthService: Attempting login for $username');

      // Use mock mode if enabled
      if (useMockMode) {
        print('🎭 Using mock mode for development...');
        final mockResult = await MockApiService.mockLogin(username, password);

        if (mockResult['success']) {
          // Save mock token
          final token =
              mockResult['data']?['token'] ??
              mockResult['data']?['access_token'] ??
              mockResult['access_token'];

          print('📦 Mock token received: $token');

          if (token != null) {
            await _saveToken(token);
          } else {
            print('❌ No token found in mock response');
          }
        }

        return mockResult;
      }

      // Real login with AWS API
      try {
        final url = Uri.parse(
          ApiConstants.buildUrl(
            ApiConstants.currentBaseUrl,
            ApiConstants.token,
          ),
        );

        print('🚀 Token Request: ${url.toString()}');

        final response = await http.post(
          url,
          headers: ApiConstants.headers,
          body: jsonEncode({
            'Grant_Type': 'password',
            'Username': username,
            'Password': password,
          }),
        );

        print('📝 Token Response Status: ${response.statusCode}');

        final data = jsonDecode(response.body);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          // Extract token from response
          final token =
              data['access_token'] ?? data['token'] ?? data['authToken'];

          if (token != null) {
            // Save token for future requests
            await _saveToken(token);

            return {
              'success': true,
              'data': data,
              'message': 'Login successful',
            };
          } else {
            return {
              'success': false,
              'message': 'Token not found in response',
              'data': data,
            };
          }
        } else {
          return {
            'success': false,
            'status': response.statusCode,
            'message': data['message'] ?? 'Authentication failed',
            'data': data,
          };
        }
      } catch (e) {
        print('❌ Authentication error: $e');
        return {'success': false, 'message': 'Authentication error: $e'};
      }
    } catch (e) {
      print('❌ AuthService: Critical login error - $e');
      return {'success': false, 'message': 'Login failed: ${e.toString()}'};
    }
  }

  static Future<void> _saveToken(String token) async {
    print('💾 Saving auth token: $token');
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> getTokenAsync() async {
    if (_token != null) return _token;

    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  static String? getToken() {
    if (_token != null) {
      return _token;
    }

    // If token is null, try to load it asynchronously (but return null for now)
    getTokenAsync().then((token) {
      _token = token;
    });

    return _token;
  }

  static Future<bool> isLoggedIn() async {
    final token = await getTokenAsync();
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
