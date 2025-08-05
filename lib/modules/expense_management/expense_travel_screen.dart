import 'package:flutter/material.dart';

class ExpenseTravelScreen extends StatefulWidget {
  const ExpenseTravelScreen({super.key});

  @override
  State<ExpenseTravelScreen> createState() => _ExpenseTravelScreenState();
}

class _ExpenseTravelScreenState extends State<ExpenseTravelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _purposeController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedTransportation;
  String? _selectedAccommodation;
  final _estimatedCostController = TextEditingController();

  final List<String> _transportationModes = [
    'Flight',
    'Train',
    'Bus',
    'Taxi/Cab',
    'Personal Vehicle',
    'Rental Car',
  ];

  final List<String> _accommodationTypes = [
    'Hotel',
    'Guest House',
    'Company Accommodation',
    'Home Stay',
    'Not Required',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Expense'),
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
                  'Travel Expense Request',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 12, 12, 120),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Submit your travel expense request for business trips',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Destination
                TextFormField(
                  controller: _destinationController,
                  decoration: const InputDecoration(
                    labelText: 'Destination',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                    helperText: 'City, State/Country',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter destination';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // From Date
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'From Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 30),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _fromDate = date;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: _fromDate != null
                        ? '${_fromDate!.day}/${_fromDate!.month}/${_fromDate!.year}'
                        : '',
                  ),
                  validator: (value) {
                    if (_fromDate == null) {
                      return 'Please select from date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // To Date
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'To Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _fromDate ?? DateTime.now(),
                      firstDate: _fromDate ?? DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _toDate = date;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: _toDate != null
                        ? '${_toDate!.day}/${_toDate!.month}/${_toDate!.year}'
                        : '',
                  ),
                  validator: (value) {
                    if (_toDate == null) {
                      return 'Please select to date';
                    }
                    if (_fromDate != null && _toDate!.isBefore(_fromDate!)) {
                      return 'To date cannot be before from date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Duration (calculated)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule),
                      const SizedBox(width: 12),
                      Text(
                        'Duration: ${_calculateDuration()} days',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Transportation Mode
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Transportation Mode',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.directions),
                  ),
                  value: _selectedTransportation,
                  items: _transportationModes.map((String mode) {
                    return DropdownMenuItem<String>(
                      value: mode,
                      child: Text(mode),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTransportation = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select transportation mode';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Accommodation Type
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Accommodation Type',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.hotel),
                  ),
                  value: _selectedAccommodation,
                  items: _accommodationTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedAccommodation = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select accommodation type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Estimated Cost
                TextFormField(
                  controller: _estimatedCostController,
                  decoration: const InputDecoration(
                    labelText: 'Estimated Total Cost',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.monetization_on),
                    prefixText: '\$ ',
                    helperText:
                        'Include transportation, accommodation, and meals',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter estimated cost';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid amount';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Amount must be greater than 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Purpose
                TextFormField(
                  controller: _purposeController,
                  decoration: const InputDecoration(
                    labelText: 'Purpose of Travel',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                    helperText:
                        'Provide detailed purpose and business justification',
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide purpose of travel';
                    }
                    if (value.length < 20) {
                      return 'Please provide more detailed purpose';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Travel Policy Information
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
                      const Row(
                        children: [
                          Icon(Icons.policy, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Travel Policy Guidelines',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Flight: Economy class for domestic, Business for international (>8hrs)\n'
                        '• Hotel: Maximum \$200/night for domestic, \$300/night international\n'
                        '• Meals: \$50/day domestic, \$75/day international\n'
                        '• Local transport: Actual expenses with receipts\n'
                        '• Advance booking required for better rates',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitTravelRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 12, 12, 120),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Submit Travel Request',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _calculateDuration() {
    if (_fromDate != null && _toDate != null) {
      return _toDate!.difference(_fromDate!).inDays + 1;
    }
    return 0;
  }

  void _submitTravelRequest() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically send the data to your backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Travel expense request submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _purposeController.dispose();
    _estimatedCostController.dispose();
    super.dispose();
  }
}
