import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class ApiService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Generic GET request
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    bool requireAuth = false,
  }) async {
    try {
      final url = Uri.parse("${ApiConstants.currentBaseUrl}$endpoint");
      final headers = requireAuth
          ? ApiConstants.getAuthHeaders(await _getToken() ?? '')
          : ApiConstants.headers;

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': json.decode(response.body),
          'message': 'Success',
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': 'Error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'data': null, 'message': 'Network error: $e'};
    }
  }

  // Generic POST request
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requireAuth = false,
  }) async {
    try {
      final url = Uri.parse("${ApiConstants.currentBaseUrl}$endpoint");
      final headers = requireAuth
          ? ApiConstants.getAuthHeaders(await _getToken() ?? '')
          : ApiConstants.headers;

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': json.decode(response.body),
          'message': 'Success',
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': 'Error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'data': null, 'message': 'Network error: $e'};
    }
  }

  // Generic PUT request
  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool requireAuth = false,
  }) async {
    try {
      final url = Uri.parse("${ApiConstants.currentBaseUrl}$endpoint");
      final headers = requireAuth
          ? ApiConstants.getAuthHeaders(await _getToken() ?? '')
          : ApiConstants.headers;

      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': json.decode(response.body),
          'message': 'Success',
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': 'Error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'data': null, 'message': 'Network error: $e'};
    }
  }

  // Generic DELETE request
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool requireAuth = false,
  }) async {
    try {
      final url = Uri.parse("${ApiConstants.currentBaseUrl}$endpoint");
      final headers = requireAuth
          ? ApiConstants.getAuthHeaders(await _getToken() ?? '')
          : ApiConstants.headers;

      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'data': null,
          'message': 'Deleted successfully',
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': 'Error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'data': null, 'message': 'Network error: $e'};
    }
  }

  // Authentication methods
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    // Mock login - replace with real API
    final result = await get('/users/1');
    if (result['success']) {
      await _saveToken('mock_token_123');
      return {
        'success': true,
        'data': result['data'],
        'message': 'Login successful',
      };
    }
    return result;
  }

  static Future<void> logout() async {
    await _removeToken();
  }

  static Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }
}
