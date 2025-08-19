# Location-Based Attendance System Guide

This guide explains how to configure and use the location-based attendance system in TeamSuite.

## Overview

The location-based attendance system verifies that employees are physically present at the office location when they check in or check out. This helps prevent attendance fraud and ensures accurate time tracking.

## How It Works

1. When an employee attempts to check in or check out, the app requests their current location
2. The system calculates the distance between the employee's current location and the configured office location
3. If the employee is within the allowed distance radius, the attendance is recorded
4. If not, a message is displayed and the attendance is not recorded

## Configuration

### Office Location Coordinates

The office location coordinates are defined in the `LocationService` class. You can modify these values to match your office location:

```dart
// In lib/services/location_service.dart
static const double OFFICE_LATITUDE = 24.8607;  // Example: Karachi
static const double OFFICE_LONGITUDE = 67.0011;
static const double MAX_DISTANCE_METERS = 500.0; // 500 meters radius
```

### Maximum Allowed Distance

The `MAX_DISTANCE_METERS` value determines how far employees can be from the office location to mark attendance. The default is 500 meters, but you can adjust this based on your needs:

- Smaller values (e.g., 100m) for stricter enforcement
- Larger values (e.g., 1000m) for more flexibility

### Mock Mode

When the app is in mock mode (`AppConfig.useMockMode = true`), location verification is bypassed for testing purposes. This allows developers and testers to check functionality without being physically present at the office.

## Required Permissions

The app requires the following permissions to use location services:

### Android

Add these to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS

Add these to your `Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location to verify your presence at the office for attendance.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location to verify your presence at the office for attendance.</string>
```

## Troubleshooting

If users have trouble with location verification:

1. Make sure location services are enabled on their device
2. Check that the app has permission to access location
3. Verify the office coordinates are correctly configured
4. Consider temporarily increasing the maximum allowed distance if needed

## Privacy Considerations

The application only tracks location when the user is actively attempting to check in or check out. No background location tracking is performed. Location data is only sent to the server as part of attendance records.
