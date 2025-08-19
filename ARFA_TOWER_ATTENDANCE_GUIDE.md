# Arfa Tower Location-Based Attendance Guide

## Overview

This guide provides information about the location-based attendance system configured specifically for Arfa Software Technology Park in Lahore.

## Office Location Details

The system is configured to verify attendance at the following location:

- **Location Name**: Arfa Software Technology Park
- **City**: Lahore, Pakistan
- **Coordinates**: 31.4704° N, 74.2724° E
- **Allowed Radius**: 500 meters

## How Verification Works

The attendance system uses two methods to verify your location:

1. **GPS Coordinates**: Checks if you're within 500 meters of the specified coordinates
2. **Location Name**: Additionally checks if your location name contains "Arfa", "Software", or "Technology Park"

Either method can validate your presence at the office, providing flexibility in case GPS is slightly inaccurate.

## Testing the Location Feature

### For Developers

When testing in an emulator or outside the actual location:

1. In Android Emulator:
   - Open the extended controls (three dots in emulator toolbar)
   - Select "Location" tab
   - Enter the coordinates: 31.4704, 74.2724
   - Click "Send" to set the location

2. In iOS Simulator:
   - Open Debug menu
   - Select "Location" > "Custom Location..."
   - Enter the coordinates: 31.4704, 74.2724

### Mock Mode

For testing without actual location hardware:

1. Enable mock mode in the app settings
2. The system will simulate being at Arfa Tower
3. All attendance will be marked as if you were physically present

## Troubleshooting

If you're physically at Arfa Tower but the app doesn't recognize it:

1. Make sure location services are enabled on your device
2. Check that the app has permission to access your location
3. Stand in an open area to get better GPS signal
4. Try refreshing your location by tapping the "Check Location" button
5. If issues persist, contact the system administrator to verify the coordinates

## Privacy and Data Usage

The app only checks your location when you're actively attempting to mark attendance. It does not track your location continuously. Your location data is only used to verify your presence at the office and is not shared with third parties.
