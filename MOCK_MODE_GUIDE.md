# Mock Mode Implementation Guide

## Overview

This document explains the mock mode implementation in the TeamSuite application, which allows for testing and development without relying on a working backend.

## Mock Mode Configuration

The mock mode is controlled by the `AppConfig` class in `lib/config/app_config.dart`:

```dart
// Toggle between modes
static bool get useMockMode => _useMockMode;
static bool _useMockMode = true; // Change to false when backend is ready
```

You can switch between mock and production modes using:

```dart
// Switch to mock mode (for development)
AppConfig.enableMockMode();

// Switch to production mode (real API)
AppConfig.enableProductionMode();
```

## Services Using Mock Mode

The following services have been configured to use mock data when in mock mode:

### 1. AuthService
- Uses mock login data when `AppConfig.useMockMode` is true
- Provides test credentials that work in mock mode

### 2. AttendanceService
- All methods (markAttendance, getTodayAttendance, getAttendanceHistory) use mock data
- Each method checks `AppConfig.useMockMode` to determine whether to use real or mock data

### 3. MockApiService
- Provides mock implementations for all API endpoints
- Simulates network delays to mimic real-world behavior
- Returns realistic test data that matches the expected API response format

## Using Mock Mode for Testing

The mock mode implementation allows for:

1. **Unit testing**: Test files in the `/test` directory can easily test service logic without real API calls
2. **UI development**: Develop and test UI components with consistent mock data
3. **Offline development**: Work on the app without needing a connection to the backend

## Mock Data Implementation

Mock data is implemented in `MockApiService.mockExecSp()` with specific responses for:

- GET_LEAVE_BALANCE
- GET_LEAVE_HISTORY
- POST_LEAVE_REQUEST
- GET_EMP_ATTENDANCE
- POST_MARK_ATTENDANCE
- GET_TODAYS_ATTENDANCE

For any unimplemented stored procedures, a default mock response is provided.

## Testing Mock Mode

Run tests using:

```bash
flutter test test/api_test.dart
```

This verifies that all mock implementations are working correctly.

## Switching to Production

When the backend is ready:

1. Update `AppConfig._useMockMode = false` in `app_config.dart`
2. Test all API endpoints with the real backend
3. Update any API response handling if the real API format differs from mock data

## Notes for Developers

- Always check console logs for mock mode indicators (🎭)
- If you add new API endpoints, remember to add mock implementations
- Keep mock data realistic but simple for testing
