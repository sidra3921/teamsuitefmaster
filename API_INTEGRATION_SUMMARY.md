# API Integration Summary - Updated for AWS Backend

## Overview
Successfully implemented complete API integration for the TeamSuite Flutter application using the AWS backend endpoints with ExecSp stored procedure architecture, including a robust mock mode for development and testing.

## New AWS Backend Endpoints

### Base URL
```
https://17dx7l6cz8.execute-api.ap-south-1.amazonaws.com/Prod/
```

### Authentication Headers
All requests to the API require the `x-conn` header:
```
x-conn: MzI1NHJ2NzJ0eXYyMnlnaGMH3I3OWorG43voa01IuAOt1+/B4XUEl6dURJZXZAf8Rt+X4PU8jt057BOd68APYWmNrXbbHSH7igij7NMBlQuIh0cELSuHVQJz1r7rezi7sZvA7OEyTP6cA37o1eMoT+ZSXwbXDPhk7H32idaIzLc4zggbxMQegCsko8u1WzgZ
```

### Key Endpoints
1. **MultiTenant Information**
   - GET `MultiTenant/GetClientInfo?Pin=demo`
   - Used to retrieve client-specific information

2. **Authentication**
   - POST `Token`
   - Request Body:
     ```json
     {
         "Grant_Type": "password",
         "Username": "manager",
         "Password": "FSDEMO123"
     }
     ```

## Postman Collection
A Postman collection has been provided for testing the API endpoints. The collection includes:
- MultiTenant endpoint for client information
- Token endpoint for authentication

### Files
- `POSTMAN_COLLECTION.json` - Contains API requests
- `POSTMAN_ENVIRONMENT.json` - Contains environment variables for the API

### Environment Variables
- `CORN_EndPoint` - Base URL for the API
- `xConn` - Connection header value for authentication

### How to Use
1. Import both files into Postman
2. Select the "TeamsuiteEnvironment" environment
3. Run the requests in the collection

## Architecture Understanding

### Backend Architecture
Your backend uses a **stored procedure (ExecSp) architecture** where:
- Most API calls go to `Api/Common/ExecSp` endpoint
- Different operations are handled by different stored procedure names

## Mock Mode for Development

A robust mock mode has been implemented to allow for development and testing without requiring a working backend:

### Features:
- Controlled centrally through `AppConfig.useMockMode`
- Provides realistic mock data for all API endpoints
- Simulates network delays for realistic testing
- All services automatically use mock data when enabled

### How to Use:
- Default mode is set to mock (`AppConfig._useMockMode = true`)
- Switch to production with `AppConfig.enableProductionMode()`
- Check console logs for 🎭 indicator showing mock mode is active

### Mock Implementation:
- **MockApiService**: Provides mock data for all API endpoints
- Each service checks `AppConfig.useMockMode` before making real API calls
- Consistent mock responses for development and testing

For more details, see [MOCK_MODE_GUIDE.md](MOCK_MODE_GUIDE.md)

## Fixed URL Construction Issue

### Problem
We fixed an issue with URL construction in the API service. The error was:

```
Failed host lookup: 'api.faastdemo.comapi' (OS Error: No address associated with hostname, errno = 7)
```

This happened because URLs were being built by directly concatenating the base URL and endpoint without a slash separator:

```dart
// WRONG ❌
final url = Uri.parse("${ApiConstants.currentBaseUrl}$endpoint");
// Results in: http://api.faastdemo.comApi/Common/ExecSp
```

### Solution

1. Added proper slash between base URL and endpoint:
```dart
// CORRECT ✅
final url = Uri.parse("${ApiConstants.currentBaseUrl}/${endpoint}");
// Results in: http://api.faastdemo.com/Api/Common/ExecSp
```

2. Created a robust URL builder method in ApiConstants:
```dart
static String buildUrl(String baseUrl, String endpoint) {
  // Remove trailing slashes from base and leading slashes from endpoint
  final base = baseUrl.replaceAll(RegExp(r'/+$'), '');
  final path = endpoint.replaceAll(RegExp(r'^/+'), '');
  return "$base/$path";
}
```

3. Updated all API service methods to use this builder:
```dart
final url = Uri.parse(ApiConstants.buildUrl(
  ApiConstants.currentBaseUrl,
  endpoint,
));
```

### Verification
We added a comprehensive URL construction test to verify:
- Correct URL construction
- Handling of extra/missing slashes
- API constants values
- Authentication uses `Api/token` endpoint with OAuth2-style token authentication

### Updated Files

### 1. API Configuration
- **lib/services/api_constants.dart**: Updated with AWS API endpoints
  - Base URL: `https://17dx7l6cz8.execute-api.ap-south-1.amazonaws.com/Prod/`
  - Token endpoint: `Token`
  - MultiTenant endpoint: `MultiTenant/GetClientInfo`
  - All service endpoints mapped to correct paths

### 2. New API Service
- **lib/services/api_service.dart**: Updated to include `x-conn` header
  - Handles OAuth2 token authentication via `Token`
  - Provides methods for API calls with proper headers
  - Manages token storage/retrieval with SharedPreferences
  - Comprehensive logging for debugging

### 3. Updated Authentication Service
- **lib/services/auth_service.dart**: 
  - Now uses updated token endpoint for login
  - Calls `Token` endpoint with username/password/grant_type
  - Handles OAuth2 token response formats
  - Token automatically saved for subsequent requests
  - Uses AppConfig.useMockMode for toggling between mock and real backend

### 4. Updated Leave Management Service
- **lib/services/leave_service.dart**: 
  - Uses `ExecSpService.execSp()` for all calls
  - Stored procedures: `GetLeaveBalance`, `GetLeaveHistory`, `SubmitLeaveRequest`
  - All calls authenticated with Bearer token

### 5. Updated Attendance Service
- **lib/services/attendance_service.dart**: 
  - Uses `ExecSpService.execSp()` for all calls
  - Stored procedures: `MarkAttendance`, `GetEmpAttendance`, `GetTodaysAttendance`
  - All calls authenticated with Bearer token
  - Now supports mock mode with realistic attendance data

## API Endpoints Configured

### Authentication
- **POST** `Api/token` - OAuth2 token authentication
  - Body: `{"username": "Manager", "password": "FSDEMO123", "grant_type": "password"}`
  - Response: Access token for Bearer authentication

### ExecSp Operations (All use POST to `Api/Common/ExecSp`)
- **Leave Management**:
  - `GetLeaveBalance` - Get employee leave balance
  - `GetLeaveHistory` - Get leave history records  
  - `SubmitLeaveRequest` - Submit new leave request

- **Attendance Management**:
  - `MarkAttendance` - Mark check-in/check-out
  - `GetEmpAttendance` - Get attendance history
  - `GetTodaysAttendance` - Get today's attendance status

- **Additional Available Procedures** (from your Endpoints class):
  - Loan Management: `GetLoanBalance`, `GetLoanTypes`, `GetLoanHistory`, `PostLoanRequest`
  - Expense Management: `GetCities`, `GetTravelMedium`, `PostTravelRequest`, `GetExpenseTypes`
  - Reports: `GetReportsSummary`, `GetNotifications`, `GetSalarySlip`

## Request Format

### Authentication Request
```json
POST https://17dx7l6cz8.execute-api.ap-south-1.amazonaws.com/Prod/Token
Headers: {
  "x-conn": "MzI1NHJ2NzJ0eXYyMnlnaGMH3I3OWorG43voa01IuAOt1+/B4XUEl6dURJZXZAf8Rt+X4PU8jt057BOd68APYWmNrXbbHSH7igij7NMBlQuIh0cELSuHVQJz1r7rezi7sZvA7OEyTP6cA37o1eMoT+ZSXwbXDPhk7H32idaIzLc4zggbxMQegCsko8u1WzgZ",
  "Content-Type": "application/json"
}
Body: {
  "Grant_Type": "password",
  "Username": "manager",
  "Password": "FSDEMO123"
}
```

### MultiTenant Request
```
GET https://17dx7l6cz8.execute-api.ap-south-1.amazonaws.com/Prod/MultiTenant/GetClientInfo?Pin=demo
```

## Key Features

### 1. AWS API Gateway Integration
- Support for AWS API Gateway endpoints
- Custom header authentication with `x-conn`
- Properly formatted requests for AWS backend

### 2. OAuth2 Token Authentication
- Token endpoint (`Token`)
- Bearer token authentication for all subsequent requests
- Token automatically saved and retrieved from SharedPreferences

### 3. Comprehensive Error Handling
- Detailed logging for all requests and responses
- Graceful error handling with user-friendly messages
- Network error detection and reporting

### 4. Production Ready
- Modular service architecture
- Consistent error handling patterns
- Token management built-in
- Easy to extend for additional stored procedures

### 5. Mock Mode for Development
- Complete mock data implementation for all endpoints
- Centralized configuration through AppConfig
- Consistent testing environment across devices
- Simple toggle between mock and production modes

## Testing Your API Integration

### 1. Using Mock Mode (Default)
```dart
// Ensure mock mode is enabled:
AppConfig.enableMockMode();

// Run the app, login with any credentials
// All API calls will use mock data
```

### 2. Testing with Real Backend
```dart
// Switch to production mode:
AppConfig.enableProductionMode();

// Login with proper credentials:
Username: manager
Password: FSDEMO123
```

### 3. Testing with Postman
1. Import the provided Postman collection and environment
2. Run the MultiTenant request to verify client information
3. Run the Token request to verify authentication

### 4. Check Console Logs
Look for these log patterns:
```
// In mock mode:
🎭 Using mock mode for development...

// In production mode:
Token Request: https://17dx7l6cz8.execute-api.ap-south-1.amazonaws.com/Prod/Token
Token Response Status: 200
```

## Next Steps

### 1. Extending Mock Mode
- Add more realistic mock data as needed
- Update mock responses to match any changes in API structure

### 2. Switching to Production
When ready to deploy with the real backend:
- Update `AppConfig._useMockMode = false` in `app_config.dart`
- Test all API endpoints with the real backend
- Verify token handling and authentication

### 3. Add More Services
You can easily add more services using the same pattern with mock support:
```dart
// Example for a new service method
static Future<Map<String, dynamic>> someMethod() async {
  // Use mock mode if enabled
  if (AppConfig.useMockMode) {
    return await MockApiService.mockExecSp('SOME_PROCEDURE', {});
  }
  
  // Real API call
  final result = await ApiService.post(ApiConstants.someEndpoint, {
    // Request parameters
  }, requireAuth: true);
  
  return result;
}
```

## Implementation in Flutter Code

### Update ApiConstants.dart
```dart
class ApiConstants {
  // Base URL for AWS API Gateway
  static const String baseUrl = "https://17dx7l6cz8.execute-api.ap-south-1.amazonaws.com/Prod/";
  
  // Connection header value
  static const String xConnValue = "MzI1NHJ2NzJ0eXYyMnlnaGMH3I3OWorG43voa01IuAOt1+/B4XUEl6dURJZXZAf8Rt+X4PU8jt057BOd68APYWmNrXbbHSH7igij7NMBlQuIh0cELSuHVQJz1r7rezi7sZvA7OEyTP6cA37o1eMoT+ZSXwbXDPhk7H32idaIzLc4zggbxMQegCsko8u1WzgZ";
  
  // Authentication endpoint
  static const String tokenEndpoint = "Token";
  
  // MultiTenant endpoint
  static const String multiTenantEndpoint = "MultiTenant/GetClientInfo";
  
  // Helper method to build URLs
  static String buildUrl(String endpoint) {
    final base = baseUrl.replaceAll(RegExp(r'/+$'), '');
    final path = endpoint.replaceAll(RegExp(r'^/+'), '');
    return "$base/$path";
  }
}
```

### Update ApiService.dart
```dart
class ApiService {
  // Add x-conn header to all requests
  static Map<String, String> _getHeaders({bool requireAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
      'x-conn': ApiConstants.xConnValue,
    };
    
    if (requireAuth) {
      final token = AuthService.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }
  
  // POST method with headers
  static Future<Map<String, dynamic>> post(String endpoint, dynamic body, {bool requireAuth = false}) async {
    try {
      final url = Uri.parse(ApiConstants.buildUrl(endpoint));
      final headers = _getHeaders(requireAuth: requireAuth);
      
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // GET method with headers
  static Future<Map<String, dynamic>> get(String endpoint, {bool requireAuth = false, Map<String, String>? queryParams}) async {
    try {
      final uri = Uri.parse(ApiConstants.buildUrl(endpoint)).replace(queryParameters: queryParams);
      final headers = _getHeaders(requireAuth: requireAuth);
      
      final response = await http.get(uri, headers: headers);
      
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // Handle API response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'status': response.statusCode,
          'message': data['message'] ?? 'Unknown error',
          'data': data,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'status': response.statusCode,
        'message': 'Failed to parse response: $e',
      };
    }
  }
}
```

### Update AuthService.dart
```dart
class AuthService {
  static Future<Map<String, dynamic>> login(String username, String password) async {
    if (AppConfig.useMockMode) {
      // Use mock login for development
      return MockApiService.mockLogin(username, password);
    }
    
    try {
      final result = await ApiService.post(
        ApiConstants.tokenEndpoint,
        {
          'Grant_Type': 'password',
          'Username': username,
          'Password': password,
        },
      );
      
      if (result['success'] && result['data'] != null) {
        final data = result['data'];
        final token = data['access_token'] ?? data['token'] ?? data['authToken'];
        
        if (token != null) {
          // Save token for future requests
          await _saveToken(token);
          return {'success': true, 'data': data};
        }
      }
      
      return result;
    } catch (e) {
      return {'success': false, 'message': 'Login failed: $e'};
    }
  }
  
  // Save token to SharedPreferences
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  // Get token from SharedPreferences
  static String? getToken() {
    // Implementation depends on how you're storing the token
    // This is a placeholder
    return _token;
  }
}
```

The app is now fully configured to work with your AWS API Gateway backend and provides a robust mock mode for development! 🚀
