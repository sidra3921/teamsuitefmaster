import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../services/location_service.dart';

class LocationTestScreen extends StatefulWidget {
  const LocationTestScreen({super.key});

  @override
  State<LocationTestScreen> createState() => _LocationTestScreenState();
}

class _LocationTestScreenState extends State<LocationTestScreen> {
  bool _isLoading = false;
  String _statusMessage = 'Ready to test location services';
  Position? _currentPosition;
  String _currentAddress = 'Unknown';
  bool _servicesEnabled = false;
  LocationPermission _permissionStatus = LocationPermission.denied;
  double _distanceFromArfa = 0.0;

  @override
  void initState() {
    super.initState();
    _checkInitialState();
  }

  Future<void> _checkInitialState() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Checking location services...';
    });

    try {
      // Check if services are enabled
      final servicesEnabled = await Geolocator.isLocationServiceEnabled();

      // Check permission status
      final permission = await Geolocator.checkPermission();

      setState(() {
        _servicesEnabled = servicesEnabled;
        _permissionStatus = permission;
        _isLoading = false;
        _statusMessage = _getStatusMessage(servicesEnabled, permission);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error: ${e.toString()}';
      });
    }
  }

  String _getStatusMessage(
    bool servicesEnabled,
    LocationPermission permission,
  ) {
    if (!servicesEnabled) {
      return 'Location services are disabled on this device';
    }

    switch (permission) {
      case LocationPermission.denied:
        return 'Location permission is denied, tap "Request Permission" to request it';
      case LocationPermission.deniedForever:
        return 'Location permission is permanently denied. Enable it in Settings';
      case LocationPermission.whileInUse:
        return 'Location permission granted (while in use)';
      case LocationPermission.always:
        return 'Location permission granted (always)';
      default:
        return 'Unknown permission status';
    }
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Requesting permission...';
    });

    try {
      final permission = await Geolocator.requestPermission();

      setState(() {
        _permissionStatus = permission;
        _isLoading = false;
        _statusMessage = 'Permission result: $permission';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error requesting permission: ${e.toString()}';
      });
    }
  }

  Future<void> _getCurrentPosition() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Getting position...';
    });

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Calculate distance from Arfa Tower
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        LocationService.OFFICE_LATITUDE,
        LocationService.OFFICE_LONGITUDE,
      );

      // Log position details for debugging
      debugPrint('Position accuracy: ${position.accuracy} meters');
      debugPrint(
        'Latitude: ${position.latitude}, Longitude: ${position.longitude}',
      );
      debugPrint('Distance from Arfa Tower: $distance meters');

      setState(() {
        _currentPosition = position;
        _distanceFromArfa = distance;
        _statusMessage = 'Position obtained successfully';
      });

      _getAddressFromPosition(position);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error getting position: ${e.toString()}';
      });
    }
  }

  Future<void> _getAddressFromPosition(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = [
          place.name,
          place.street,
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((element) => element != null && element.isNotEmpty).join(', ');

        setState(() {
          _currentAddress = address;
          _isLoading = false;
        });
      } else {
        setState(() {
          _currentAddress = 'No address found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = 'Error getting address: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _checkArfaTower() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Checking if at Arfa Tower...';
    });

    try {
      final result = await LocationService.isWithinOfficeRange();
      final bool isWithinRange = result['isWithinRange'] ?? false;
      final bool isWithinCoordinateRange =
          result['isWithinCoordinateRange'] ?? false;
      final bool isArfaTower = result['isArfaTower'] ?? false;

      setState(() {
        _isLoading = false;
        _statusMessage =
            result['message'] +
            '\n\nCoordinate check: ${isWithinCoordinateRange ? "Pass" : "Fail"}' +
            '\nLocation name check: ${isArfaTower ? "Pass" : "Fail"}' +
            '\nFinal result: ${isWithinRange ? "Pass" : "Fail"}';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    'Status',
                    _statusMessage,
                    Icons.info,
                    Colors.blue,
                  ),
                  const SizedBox(height: 16),

                  _buildInfoCard(
                    'Services',
                    'Location services: ${_servicesEnabled ? "Enabled" : "Disabled"}',
                    Icons.settings,
                    _servicesEnabled ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 16),

                  _buildInfoCard(
                    'Permission',
                    'Permission status: $_permissionStatus',
                    Icons.security,
                    _permissionStatus == LocationPermission.denied ||
                            _permissionStatus ==
                                LocationPermission.deniedForever
                        ? Colors.red
                        : Colors.green,
                  ),
                  const SizedBox(height: 16),

                  if (_currentPosition != null) ...[
                    _buildInfoCard(
                      'Current Position',
                      'Lat: ${_currentPosition!.latitude}\nLng: ${_currentPosition!.longitude}\nAccuracy: ${_currentPosition!.accuracy.toStringAsFixed(2)}m\nAltitude: ${_currentPosition!.altitude.toStringAsFixed(2)}m\nSpeed: ${_currentPosition!.speed.toStringAsFixed(2)} m/s',
                      Icons.location_on,
                      Colors.orange,
                    ),
                    const SizedBox(height: 16),

                    _buildInfoCard(
                      'Address',
                      _currentAddress,
                      Icons.home,
                      Colors.purple,
                    ),
                    const SizedBox(height: 16),

                    _buildInfoCard(
                      'Arfa Tower',
                      'Distance: ${_distanceFromArfa.toStringAsFixed(2)} meters\n${_distanceFromArfa <= LocationService.MAX_DISTANCE_METERS ? "You are within range!" : "You are outside the allowed range"}',
                      Icons.business,
                      _distanceFromArfa <= LocationService.MAX_DISTANCE_METERS
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(height: 16),
                  ],

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _requestPermission,
                        icon: const Icon(Icons.security),
                        label: const Text('Request Permission'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _getCurrentPosition,
                        icon: const Icon(Icons.my_location),
                        label: const Text('Get Position'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _checkArfaTower,
                      icon: const Icon(Icons.business),
                      label: const Text('Check Arfa Tower'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Troubleshooting Steps:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildTroubleshootingStep(
                    '1. Make sure location services are enabled on your device',
                  ),
                  _buildTroubleshootingStep(
                    '2. Grant location permission when prompted',
                  ),
                  _buildTroubleshootingStep(
                    '3. If permission is "deniedForever", go to device settings to enable it',
                  ),
                  _buildTroubleshootingStep(
                    '4. Try getting position in an open area for better GPS signal',
                  ),
                  _buildTroubleshootingStep(
                    '5. If you\'re inside Arfa Tower but the app doesn\'t recognize it, use the "I\'m at Arfa Tower" button on the Attendance Mark screen',
                  ),
                  _buildTroubleshootingStep(
                    '6. If still not working, try restarting the app or device',
                  ),
                  const SizedBox(height: 16),
                  if (_distanceFromArfa > 0 && _distanceFromArfa < 10000) ...[
                    Card(
                      color: Colors.orange.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.info, color: Colors.orange),
                                SizedBox(width: 8),
                                Text(
                                  'Are you at Arfa Tower?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'If you are physically at Arfa Tower but the GPS shows you\'re not, this could be due to:',
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            const Text('• Indoor location inaccuracy'),
                            const Text(
                              '• GPS signal interference from the building',
                            ),
                            const Text('• Device hardware limitations'),
                            const SizedBox(height: 12),
                            const Text(
                              'Solution: Use the "I\'m at Arfa Tower" button on the attendance screen to manually verify your location.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(content, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildTroubleshootingStep(String step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 18, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(child: Text(step)),
        ],
      ),
    );
  }
}
