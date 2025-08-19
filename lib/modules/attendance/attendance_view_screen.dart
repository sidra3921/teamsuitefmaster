import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Added for date formatting
import '../../services/attendance_service.dart';

class AttendanceViewScreen extends StatefulWidget {
  const AttendanceViewScreen({super.key});

  @override
  State<AttendanceViewScreen> createState() => _AttendanceViewScreenState();
}

class _AttendanceViewScreenState extends State<AttendanceViewScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _attendanceHistory = [];
  Map<String, dynamic> _todayAttendance = {};

  // Summary counts
  int _presentCount = 0;
  int _absentCount = 0;
  int _lateCount = 0;
  int _halfDayCount = 0;

  String _selectedMonth = 'August 2025';

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get today's attendance
      final todayResult = await AttendanceService.getTodayAttendance();
      if (todayResult['success'] && todayResult['data'] != null) {
        _todayAttendance = todayResult['data'];
      }

      // Get attendance history
      final historyResult = await AttendanceService.getAttendanceHistory();
      if (historyResult['success'] && historyResult['data'] != null) {
        _attendanceHistory = List<Map<String, dynamic>>.from(
          historyResult['data'],
        );

        // Calculate summary statistics
        _calculateSummary();
      }
    } catch (e) {
      debugPrint('Error loading attendance data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _calculateSummary() {
    _presentCount = 0;
    _absentCount = 0;
    _lateCount = 0;
    _halfDayCount = 0;

    for (final record in _attendanceHistory) {
      final status = record['status']?.toString().toLowerCase() ?? '';

      if (status == 'present') {
        _presentCount++;
      } else if (status == 'absent') {
        _absentCount++;
      } else if (status == 'late') {
        _lateCount++;
      } else if (status == 'half day') {
        _halfDayCount++;
      }
    }
  }

  String _getDayName(String date) {
    try {
      final parsedDate = DateFormat('yyyy-MM-dd').parse(date);
      return DateFormat(
        'EEEE',
      ).format(parsedDate); // Returns day name like Monday, Tuesday, etc.
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return 'Unknown Day';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance View'),
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
                    'Attendance Overview',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 12, 12, 120),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Monthly Summary Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Color.fromARGB(255, 12, 12, 120),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$_selectedMonth Summary',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 12, 12, 120),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Show today's attendance if available
                          if (_todayAttendance.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Today's Status:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _todayAttendance['status'] ??
                                        'Not Available',
                                    style: TextStyle(
                                      color: _getStatusColor(
                                        _todayAttendance['status'],
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildSummaryItem(
                                'Present',
                                _presentCount.toString(),
                                Colors.green,
                              ),
                              _buildSummaryItem(
                                'Absent',
                                _absentCount.toString(),
                                Colors.red,
                              ),
                              _buildSummaryItem(
                                'Late',
                                _lateCount.toString(),
                                Colors.orange,
                              ),
                              _buildSummaryItem(
                                'Half Day',
                                _halfDayCount.toString(),
                                Colors.blue,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Filter Row
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Select Month',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'August 2025',
                              child: Text('August 2025'),
                            ),
                            DropdownMenuItem(
                              value: 'July 2025',
                              child: Text('July 2025'),
                            ),
                            DropdownMenuItem(
                              value: 'June 2025',
                              child: Text('June 2025'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedMonth = value;
                              });
                              // Implement filter logic
                            }
                          },
                          value: _selectedMonth,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Daily Attendance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 12, 12, 120),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: _attendanceHistory.isEmpty
                        ? const Center(
                            child: Text(
                              'No attendance records found',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _attendanceHistory.length,
                            itemBuilder: (context, index) {
                              final record = _attendanceHistory[index];
                              final date = record['date'] ?? 'Unknown Date';
                              final day =
                                  record['day'] ??
                                  _getDayName(
                                    date,
                                  ); // Use calculated day name if not provided
                              return _buildAttendanceCard(
                                date,
                                day,
                                record['status'] ?? 'Unknown',
                                record['checkIn'] ?? '--',
                                record['checkOut'] ?? '--',
                                record['totalHours'] ?? '0h 0m',
                                _getStatusColor(record['status']),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceCard(
    String date,
    String day,
    String status,
    String checkIn,
    String checkOut,
    String totalHours,
    Color statusColor,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Date Column
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 12, 12, 120),
                    ),
                  ),
                  Text(
                    day,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Time Details
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (status != 'Absent') ...[
                    Text(
                      '$checkIn - $checkOut',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      totalHours,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ] else ...[
                    const Text(
                      'No attendance',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;

    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'late':
        return Colors.orange;
      case 'half day':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
