import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

class LocationService {
  // The company's office location - Arfa Tower, Lahore
  // Precise coordinates for Arfa Software Technology Park
  static const double OFFICE_LATITUDE =
      31.4753; // Updated more accurate coordinates
  static const double OFFICE_LONGITUDE =
      74.3416; // Updated more accurate coordinates
  static const double MAX_DISTANCE_METERS = 500.0; // 500 meters radius

  /// Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    try {
      final result = await Geolocator.isLocationServiceEnabled();
      debugPrint('🧪 Location services enabled: $result');
      return result;
    } catch (e) {
      debugPrint('🧪 Error checking if location services are enabled: $e');
      return false;
    }
  }

  /// Request location permission
  static Future<LocationPermission> requestPermission() async {
    try {
      debugPrint('🧪 Checking current location permission...');
      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('🧪 Current permission status: $permission');

      if (permission == LocationPermission.denied) {
        debugPrint('🧪 Permission denied, requesting permission...');
        permission = await Geolocator.requestPermission();
        debugPrint('🧪 New permission status: $permission');
      }
      return permission;
    } catch (e) {
      debugPrint('🧪 Error requesting location permission: $e');
      if (e.toString().contains('manifest')) {
        debugPrint(
          '🧪 MANIFEST ERROR: Check that permissions are properly defined in AndroidManifest.xml',
        );
        debugPrint(
          '🧪 Make sure the app is rebuilt completely after adding permissions',
        );
      }
      return LocationPermission.denied;
    }
  }

  /// Get the current position
  static Future<Position?> getCurrentPosition() async {
    try {
      debugPrint('🧪 Checking if location services are enabled...');
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('🧪 Location services are disabled on the device');
        return null;
      }

      debugPrint('🧪 Requesting location permission...');
      final permission = await requestPermission();
      debugPrint('🧪 Permission result: $permission');

      if (permission == LocationPermission.denied) {
        debugPrint('🧪 Location permission denied by user');
        return null;
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('🧪 Location permission permanently denied, cannot request');
        return null;
      }

      debugPrint('🧪 Permission granted, getting current position...');
      // Increase accuracy and timeout for better results
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        timeLimit: const Duration(seconds: 15),
        forceAndroidLocationManager:
            false, // Use Google Play Services for better accuracy
      );

      debugPrint(
        '🧪 Position obtained: ${position.latitude}, ${position.longitude}, accuracy: ${position.accuracy} meters',
      );
      return position;
    } catch (e) {
      debugPrint('🧪 Error getting current position: $e');
      if (e.toString().contains('manifest')) {
        debugPrint(
          '🧪 This is a manifest error. Check permissions in AndroidManifest.xml',
        );
      } else if (e.toString().contains('timeout')) {
        debugPrint(
          '🧪 Location request timed out. May be in an area with poor GPS signal',
        );
      }
      return null;
    }
  }

  /// Check if the user is within the allowed office range
  static Future<Map<String, dynamic>> isWithinOfficeRange() async {
    try {
      final position = await getCurrentPosition();
      if (position == null) {
        return {
          'isWithinRange': false,
          'distance': double.infinity,
          'message': 'Unable to get your location',
          'position': null,
          'locationName': null,
        };
      }

      // Calculate distance between current position and office
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        OFFICE_LATITUDE,
        OFFICE_LONGITUDE,
      );

      // Get location name
      String locationName = 'Unknown location';
      try {
        // Use a more accurate geocoding approach with a proper timeout
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        ).timeout(const Duration(seconds: 5));

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          locationName =
              [
                    place.name,
                    place.street,
                    place.locality,
                    place.subAdministrativeArea,
                    place.administrativeArea,
                    place.country,
                  ]
                  .where((element) => element != null && element.isNotEmpty)
                  .join(', ');
        }
      } catch (e) {
        debugPrint('Error getting location name: $e');
        // Even if geocoding fails, continue with coordinate-based check
      }

      final isWithinRange = distance <= MAX_DISTANCE_METERS;

      // Log before performing name-based checks
      debugPrint('📍 Current location: $locationName');
      debugPrint(
        '📍 Coordinates: ${position.latitude}, ${position.longitude}, accuracy: ${position.accuracy} meters',
      );
      debugPrint(
        '📏 Distance from Arfa Tower: ${distance.toStringAsFixed(2)} meters',
      );

      // Determine if this is Arfa Tower based on location name
      bool isArfaTower =
          locationName.toLowerCase().contains('arfa') ||
          locationName.toLowerCase().contains('software') ||
          locationName.toLowerCase().contains('technology park') ||
          locationName.toLowerCase().contains('lahore');

      // Prioritize coordinate-based check, with name as fallback only if very close
      final bool isOfficeLocation =
          isWithinRange || (isArfaTower && distance <= 1000);

      String message;
      if (isOfficeLocation) {
        message = 'You are at Arfa Tower, Lahore';
      } else {
        message = 'You are not at Arfa Tower, Lahore';
      }

      debugPrint('✅ Is at Arfa Tower: $isOfficeLocation');

      return {
        'isWithinRange': isOfficeLocation,
        'distance': distance,
        'message': message,
        'position': position,
        'locationName': locationName,
        'isArfaTower': isArfaTower,
        'isWithinCoordinateRange': isWithinRange,
      };
    } catch (e) {
      debugPrint('Error checking office range: $e');
      return {
        'isWithinRange': false,
        'distance': double.infinity,
        'message': 'Error checking location: $e',
        'position': null,
        'locationName': null,
        'isArfaTower': false,
      };
    }
  }
}
