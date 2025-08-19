import 'package:flutter/material.dart';
import '../../services/attendance_service.dart';
import '../../services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceMarkScreen extends StatefulWidget {
  const AttendanceMarkScreen({super.key});

  @override
  State<AttendanceMarkScreen> createState() => _AttendanceMarkScreenState();
}

class _AttendanceMarkScreenState extends State<AttendanceMarkScreen> {
  // Class variables
  bool _isCheckedIn = false;
  TimeOfDay? _checkInTime;
  TimeOfDay? _checkOutTime;
  String _currentStatus = 'Not Checked In';
  bool _isLoading = false;
  bool _isLocationValid = false;
  String _locationMessage = 'Checking location...';
  double _distanceFromOffice = double.infinity;
  bool _manualOverrideActive = false;

  @override
  void initState() {
    super.initState();
    _loadTodayAttendance();
    _checkLocationPermission();

    // Reset any manual override
    setState(() {
      _manualOverrideActive = false;
    });
  }

  Future<void> _checkLocationPermission() async {
    try {
      setState(() {
        _isLoading = true;
        _locationMessage = 'Checking location...';
        _manualOverrideActive = false; // Reset manual override on new check
      });

      debugPrint('🔍 Checking location permissions and validity...');
      final locationData = await LocationService.isWithinOfficeRange();

      setState(() {
        _isLoading = false;
        _isLocationValid = locationData['isWithinRange'];
        _locationMessage = locationData['message'];
        _distanceFromOffice = locationData['distance'];
      });

      // Show a snackbar with the result
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_locationMessage),
            backgroundColor: _isLocationValid ? Colors.green : Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      debugPrint('📍 Location check complete: $_locationMessage');
      debugPrint(
        '📍 Distance from Arfa Tower: ${_distanceFromOffice.toStringAsFixed(2)} meters',
      );
      debugPrint('📍 Location valid: $_isLocationValid');
    } catch (e) {
      debugPrint('❌ Error during location check: $e');
      setState(() {
        _isLoading = false;
        _isLocationValid = false;
        _locationMessage = 'Error checking location: ${e.toString()}';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location check failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Add manual override for Arfa Tower
  void _manualArfaTowerOverride() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Location Override'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'I confirm that I am physically present at Arfa Tower, Lahore.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Note: Falsely claiming your presence at Arfa Tower may result in disciplinary action.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
            const SizedBox(height: 16),
            Text(
              'Current GPS shows you are ${_distanceFromOffice.toStringAsFixed(0)} meters away from Arfa Tower.',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _setManualOverride();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _setManualOverride() {
    setState(() {
      _manualOverrideActive = true;
      _isLocationValid = true;
      _locationMessage = 'Location manually verified (Arfa Tower)';
    });

    // Show a snackbar to indicate override is active
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Manual location verification applied'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _loadTodayAttendance() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AttendanceService.getTodayAttendance();
      if (mounted && result['success']) {
        final data = result['data'];

        if (data != null) {
          setState(() {
            _isCheckedIn = data['checkIn'] != null && data['checkOut'] == null;

            // Parse check-in time if available
            if (data['checkIn'] != null) {
              final timeStr = data['checkIn'].toString();
              try {
                final parts = timeStr.split(':');
                if (parts.length >= 2) {
                  final hourStr = parts[0].replaceAll(RegExp(r'[^\d]'), '');
                  final minuteStr = parts[1].replaceAll(RegExp(r'[^\d]'), '');
                  final hour = int.tryParse(hourStr) ?? 0;
                  final minute = int.tryParse(minuteStr) ?? 0;
                  _checkInTime = TimeOfDay(hour: hour, minute: minute);
                } else {
                  _checkInTime = TimeOfDay.now();
                }
              } catch (_) {
                _checkInTime = TimeOfDay.now();
              }
            } else {
              _checkInTime = null;
            }

            // Parse check-out time if available
            if (data['checkOut'] != null) {
              final timeStr = data['checkOut'].toString();
              try {
                final parts = timeStr.split(':');
                if (parts.length >= 2) {
                  final hourStr = parts[0].replaceAll(RegExp(r'[^\d]'), '');
                  final minuteStr = parts[1].replaceAll(RegExp(r'[^\d]'), '');
                  final hour = int.tryParse(hourStr) ?? 0;
                  final minute = int.tryParse(minuteStr) ?? 0;
                  _checkOutTime = TimeOfDay(hour: hour, minute: minute);
                } else {
                  _checkOutTime = TimeOfDay.now();
                }
              } catch (_) {
                _checkOutTime = TimeOfDay.now();
              }
            } else {
              _checkOutTime = null;
            }

            _currentStatus = data['status'] ?? 'Not Checked In';

            // Log the data to verify it's working
            print('📱 Today\'s attendance loaded: $data');
          });
        }
      }
    } catch (e) {
      print('❌ Error loading today\'s attendance: $e');
      // Handle error silently or show message
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
        backgroundColor: const Color.fromARGB(255, 12, 12, 120),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today\'s Attendance',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 12, 12, 120),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Current Date and Time
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Color.fromARGB(255, 12, 12, 120),
                                size: 30,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _getCurrentDate(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 12, 12, 120),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _getCurrentTime(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 12, 12, 120),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: _getStatusColor()),
                            ),
                            child: Text(
                              _currentStatus,
                              style: TextStyle(
                                color: _getStatusColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _isLocationValid
                                  ? (_manualOverrideActive
                                        ? Colors.orange.withOpacity(0.1)
                                        : Colors.green.withOpacity(0.1))
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _isLocationValid
                                    ? (_manualOverrideActive
                                          ? Colors.orange
                                          : Colors.green)
                                    : Colors.red,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isLocationValid
                                      ? (_manualOverrideActive
                                            ? Icons.verified_user
                                            : Icons.location_on)
                                      : Icons.location_off,
                                  color: _isLocationValid
                                      ? (_manualOverrideActive
                                            ? Colors.orange
                                            : Colors.green)
                                      : Colors.red,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    _isLocationValid
                                        ? (_manualOverrideActive
                                              ? 'Manually verified at Arfa Tower'
                                              : 'You are at Arfa Tower, Lahore')
                                        : 'Not at Arfa Tower (${_distanceFromOffice < double.infinity ? "${_distanceFromOffice.toStringAsFixed(0)}m away" : "unknown distance"})',
                                    style: TextStyle(
                                      color: _isLocationValid
                                          ? (_manualOverrideActive
                                                ? Colors.orange
                                                : Colors.green)
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!_isLocationValid) ...[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton.icon(
                                  onPressed: _checkLocationPermission,
                                  icon: const Icon(Icons.refresh, size: 14),
                                  label: const Text(
                                    'Retry Check',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    minimumSize: Size.zero,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  onPressed: _manualArfaTowerOverride,
                                  icon: const Icon(Icons.business, size: 14),
                                  label: const Text(
                                    'I\'m at Arfa Tower',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    minimumSize: Size.zero,
                                    foregroundColor: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Check In/Out Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _isCheckedIn ? _checkOut : _checkIn,
                      icon: Icon(
                        _isCheckedIn ? Icons.logout : Icons.login,
                        size: 28,
                      ),
                      label: Text(
                        _isCheckedIn ? 'CHECK OUT' : 'CHECK IN',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCheckedIn
                            ? Colors.red
                            : Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Today's Summary
                  if (_checkInTime != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Today\'s Summary',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 12, 12, 120),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.login,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text('Check In'),
                                  ],
                                ),
                                Text(
                                  _checkInTime!.format(context),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            if (_checkOutTime != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Check Out'),
                                    ],
                                  ),
                                  Text(
                                    _checkOutTime!.format(context),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Total Hours'),
                                    ],
                                  ),
                                  Text(
                                    _calculateTotalHours(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                  const Spacer(),

                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/attendance-view');
                          },
                          icon: const Icon(Icons.visibility),
                          label: const Text('View History'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(
                              255,
                              12,
                              12,
                              120,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _checkLocationPermission,
                          icon: const Icon(Icons.location_searching),
                          label: const Text('Check Location'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(
                              255,
                              12,
                              12,
                              120,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/location-test');
                      },
                      icon: const Icon(Icons.bug_report),
                      label: const Text('Location Troubleshooter'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  String _getCurrentTime() {
    final now = TimeOfDay.now();
    return now.format(context);
  }

  Color _getStatusColor() {
    if (_checkOutTime != null) return Colors.blue;
    if (_isCheckedIn) return Colors.orange;
    return Colors.red;
  }

  Future<void> _checkIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Skip location check if manual override is active
      if (!_manualOverrideActive) {
        // First check location before trying to check in
        await _checkLocationPermission();
      }

      // Only proceed with check-in if location is valid
      if (!_isLocationValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_locationMessage),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final result = await AttendanceService.markAttendance(
        'check_in',
        DateTime.now(),
      );

      if (mounted) {
        if (result['success']) {
          setState(() {
            _isCheckedIn = true;
            _checkInTime = TimeOfDay.now();
            _currentStatus = 'Checked In';
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully checked in!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Check-in failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _checkOut() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Skip location check if manual override is active
      if (!_manualOverrideActive) {
        // First check location before trying to check out
        await _checkLocationPermission();
      }

      // Only proceed with check-out if location is valid
      if (!_isLocationValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_locationMessage),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final result = await AttendanceService.markAttendance(
        'check_out',
        DateTime.now(),
      );

      if (mounted) {
        if (result['success']) {
          setState(() {
            _isCheckedIn = false;
            _checkOutTime = TimeOfDay.now();
            _currentStatus = 'Checked Out';
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully checked out!'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Check-out failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _calculateTotalHours() {
    if (_checkInTime != null && _checkOutTime != null) {
      final checkInMinutes = _checkInTime!.hour * 60 + _checkInTime!.minute;
      final checkOutMinutes = _checkOutTime!.hour * 60 + _checkOutTime!.minute;
      final totalMinutes = checkOutMinutes - checkInMinutes;
      final hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;
      return '${hours}h ${minutes}m';
    }
    return '0h 0m';
  }
}
