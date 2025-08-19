import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class ExecSpService {
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

  // Most of your API calls use ExecSp with different stored procedures
  static Future<Map<String, dynamic>> execSp(
    String spName, {
    Map<String, dynamic>? parameters,
    bool requireAuth = false,
  }) async {
    try {
      final url = Uri.parse(
        "${ApiConstants.currentBaseUrl}/${ApiConstants.commonExecSp}",
      );

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (requireAuth) {
        final token = await _getToken();
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }
      }

      final body = {
        'spName': spName, // The stored procedure name
        'parameters': parameters ?? {}, // Parameters for the stored procedure
      };

      print('ExecSp Request: $url');
      print('ExecSp Headers: $headers');
      print('ExecSp Body: ${json.encode(body)}');

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      print('ExecSp Response Status: ${response.statusCode}');
      print('ExecSp Response Body: ${response.body}');

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
          'message': 'Error: ${response.statusCode} - ${response.body}',
        };
      }
    } catch (e) {
      print('ExecSp Error: $e');
      return {'success': false, 'data': null, 'message': 'Network error: $e'};
    }
  }

  // Authentication using token endpoint
  static Future<Map<String, dynamic>> authenticate(
    String username,
    String password,
  ) async {
    try {
      final url = Uri.parse(
        "${ApiConstants.currentBaseUrl}/${ApiConstants.token}",
      );

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Common OAuth2 token request format
      final body = {
        'username': username,
        'password': password,
        'grant_type': 'password',
      };

      print('Token Request: $url');
      print('Token Headers: $headers');
      print('Token Body: ${json.encode(body)}');

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      print('Token Response Status: ${response.statusCode}');
      print('Token Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);

        // Save token - common field names for OAuth2
        final token =
            responseData['access_token'] ??
            responseData['token'] ??
            responseData['authToken'] ??
            responseData['accessToken'];

        if (token != null) {
          await _saveToken(token);
        }

        return {
          'success': true,
          'data': responseData,
          'message': 'Authentication successful',
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message':
              'Authentication failed: ${response.statusCode} - ${response.body}',
        };
      }
    } catch (e) {
      print('Authentication Error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Authentication error: $e',
      };
    }
  }

  static Future<void> logout() async {
    await _removeToken();
  }

  static Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }
}
