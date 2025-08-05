import 'package:flutter/material.dart';

class AttendanceRequestScreen extends StatefulWidget {
  const AttendanceRequestScreen({super.key});

  @override
  State<AttendanceRequestScreen> createState() =>
      _AttendanceRequestScreenState();
}

class _AttendanceRequestScreenState extends State<AttendanceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRequestType;
  DateTime? _selectedDate;
  TimeOfDay? _checkInTime;
  TimeOfDay? _checkOutTime;
  final _reasonController = TextEditingController();

  final List<String> _requestTypes = [
    'Missing Check-in',
    'Missing Check-out',
    'Incorrect Time',
    'System Error',
    'Forgot to Mark',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Request'),
        backgroundColor: const Color.fromARGB(255, 12, 12, 120),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attendance Correction Request',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 12, 12, 120),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Submit a request to correct your attendance record',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Request Type Dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Request Type',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  value: _selectedRequestType,
                  items: _requestTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRequestType = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a request type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date Selection
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                    helperText: 'Select the date for attendance correction',
                  ),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(
                        const Duration(days: 1),
                      ),
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 30),
                      ),
                      lastDate: DateTime.now().subtract(
                        const Duration(days: 1),
                      ),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: _selectedDate != null
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : '',
                  ),
                  validator: (value) {
                    if (_selectedDate == null) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Check-in Time (if applicable)
                if (_selectedRequestType == 'Missing Check-in' ||
                    _selectedRequestType == 'Incorrect Time') ...[
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Check-in Time',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 9, minute: 0),
                      );
                      if (time != null) {
                        setState(() {
                          _checkInTime = time;
                        });
                      }
                    },
                    controller: TextEditingController(
                      text: _checkInTime != null
                          ? _checkInTime!.format(context)
                          : '',
                    ),
                    validator: (value) {
                      if ((_selectedRequestType == 'Missing Check-in' ||
                              _selectedRequestType == 'Incorrect Time') &&
                          _checkInTime == null) {
                        return 'Please select check-in time';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Check-out Time (if applicable)
                if (_selectedRequestType == 'Missing Check-out' ||
                    _selectedRequestType == 'Incorrect Time') ...[
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Check-out Time',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.access_time_filled),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 18, minute: 0),
                      );
                      if (time != null) {
                        setState(() {
                          _checkOutTime = time;
                        });
                      }
                    },
                    controller: TextEditingController(
                      text: _checkOutTime != null
                          ? _checkOutTime!.format(context)
                          : '',
                    ),
                    validator: (value) {
                      if ((_selectedRequestType == 'Missing Check-out' ||
                              _selectedRequestType == 'Incorrect Time') &&
                          _checkOutTime == null) {
                        return 'Please select check-out time';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Reason
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Reason/Explanation',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit),
                    helperText: 'Provide detailed explanation for the request',
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide a reason';
                    }
                    if (value.length < 10) {
                      return 'Please provide more detailed explanation';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Current Attendance Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text(
                            'Current Record',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'If you have existing attendance record for the selected date, it will be shown here after date selection.',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                      if (_selectedDate != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Text(
                          'Status: Absent (No record found)',
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 12, 12, 120),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Submit Request',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Note
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning, color: Colors.orange, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Note: All attendance correction requests are subject to approval by your supervisor. Please ensure all information is accurate.',
                          style: TextStyle(fontSize: 12, color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically send the data to your backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Attendance correction request submitted successfully!',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}
