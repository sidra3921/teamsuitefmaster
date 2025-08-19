import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'auth_service.dart';

class ApiService {
  // Method to get client info
  static Future<Map<String, dynamic>> getClientInfo({
    String pin = 'demo',
  }) async {
    try {
      final url = Uri.parse(
        ApiConstants.buildUrl(
          ApiConstants.currentBaseUrl,
          '${ApiConstants.getClientInfo}?Pin=$pin',
        ),
      );
      print('🔍 Getting client info: $url');

      final response = await http.get(url, headers: ApiConstants.headers);

      print('📊 Client Info Status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': json.decode(response.body),
          'message': 'Success',
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': 'Failed to get client info: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('❌ Client Info Error: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Client info request failed: $e',
      };
    }
  }

  // Generic GET request
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requireAuth = false,
  }) async {
    try {
      final uri = Uri.parse(
        ApiConstants.buildUrl(ApiConstants.currentBaseUrl, endpoint),
      ).replace(queryParameters: queryParams);

      Map<String, String> headers;
      if (requireAuth) {
        final token = await AuthService.getTokenAsync();
        if (token == null) {
          print('⚠️ Warning: No auth token available for request');
          return {
            'success': false,
            'data': null,
            'message': 'Authentication token not available',
          };
        }
        headers = ApiConstants.getAuthHeaders(token);
      } else {
        headers = ApiConstants.headers;
      }

      print('GET Request: $uri');

      final response = await http.get(uri, headers: headers);

      print('GET Response Status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
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
      print('GET Error: $e');
      return {'success': false, 'data': null, 'message': 'Network error: $e'};
    }
  }

  // Generic POST request
  static Future<Map<String, dynamic>> post(
    String endpoint,
    dynamic body, {
    bool requireAuth = false,
  }) async {
    try {
      final url = Uri.parse(
        ApiConstants.buildUrl(ApiConstants.currentBaseUrl, endpoint),
      );

      Map<String, String> headers;
      if (requireAuth) {
        final token = await AuthService.getTokenAsync();
        if (token == null) {
          print('⚠️ Warning: No auth token available for request');
          return {
            'success': false,
            'data': null,
            'message': 'Authentication token not available',
          };
        }
        headers = ApiConstants.getAuthHeaders(token);
      } else {
        headers = ApiConstants.headers;
      }

      print('POST Request: $url');

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      print('POST Response Status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
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
      print('POST Error: $e');
      return {'success': false, 'data': null, 'message': 'Network error: $e'};
    }
  }
}
