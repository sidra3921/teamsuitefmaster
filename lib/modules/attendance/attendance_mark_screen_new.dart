import 'package:flutter/material.dart';

class AttendanceMarkScreen extends StatefulWidget {
  const AttendanceMarkScreen({super.key});

  @override
  State<AttendanceMarkScreen> createState() => _AttendanceMarkScreenState();
}

class _AttendanceMarkScreenState extends State<AttendanceMarkScreen> {
  bool _isCheckedIn = false;
  TimeOfDay? _checkInTime;
  TimeOfDay? _checkOutTime;
  String _currentStatus = 'Not Checked In';

  @override
  void initState() {
    super.initState();
    _loadTodayAttendance();
  }

  void _loadTodayAttendance() {
    // Simulate loading today's attendance status
    // In real app, this would fetch from API
    setState(() {
      // For demo, assume not checked in
      _isCheckedIn = false;
      _currentStatus = 'Not Checked In';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
        backgroundColor: const Color.fromARGB(255, 12, 12, 120),
        foregroundColor: Colors.white,
      ),
      body: Padding(
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
                icon: Icon(_isCheckedIn ? Icons.logout : Icons.login, size: 28),
                label: Text(
                  _isCheckedIn ? 'CHECK OUT' : 'CHECK IN',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isCheckedIn ? Colors.red : Colors.green,
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
                              Icon(Icons.login, color: Colors.green, size: 20),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.logout, color: Colors.red, size: 20),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      foregroundColor: const Color.fromARGB(255, 12, 12, 120),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/attendance-request');
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Request Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 12, 12, 120),
                    ),
                  ),
                ),
              ],
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

  void _checkIn() {
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
  }

  void _checkOut() {
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
