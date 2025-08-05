import 'package:flutter/material.dart';

class ExpenseAdvanceScreen extends StatefulWidget {
  const ExpenseAdvanceScreen({super.key});

  @override
  State<ExpenseAdvanceScreen> createState() => _ExpenseAdvanceScreenState();
}

class _ExpenseAdvanceScreenState extends State<ExpenseAdvanceScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedAdvanceType;
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();
  DateTime? _requiredDate;

  final List<String> _advanceTypes = [
    'Travel Advance',
    'Project Advance',
    'Emergency Advance',
    'Training Advance',
    'Conference Advance',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Advance'),
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
                  'Request Expense Advance',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 12, 12, 120),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Submit a request for advance payment for upcoming expenses',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Advance Type Dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Advance Type',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  value: _selectedAdvanceType,
                  items: _advanceTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedAdvanceType = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select advance type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Advance Amount',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.monetization_on),
                    prefixText: '\$ ',
                    helperText: 'Maximum advance amount: \$5,000',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter advance amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid amount';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Amount must be greater than 0';
                    }
                    if (double.parse(value) > 5000) {
                      return 'Amount cannot exceed \$5,000';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Required Date
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Required Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                    helperText: 'When do you need this advance?',
                  ),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                    );
                    if (date != null) {
                      setState(() {
                        _requiredDate = date;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: _requiredDate != null
                        ? '${_requiredDate!.day}/${_requiredDate!.month}/${_requiredDate!.year}'
                        : '',
                  ),
                  validator: (value) {
                    if (_requiredDate == null) {
                      return 'Please select required date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Purpose
                TextFormField(
                  controller: _purposeController,
                  decoration: const InputDecoration(
                    labelText: 'Purpose/Description',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                    helperText: 'Provide detailed purpose for the advance',
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide purpose';
                    }
                    if (value.length < 20) {
                      return 'Please provide more detailed purpose';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Current Advance Status
                Card(
                  color: Colors.blue.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Current Advance Status',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Outstanding Advance:'),
                            const Text(
                              '\$ 1,250.00',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Available Limit:'),
                            Text(
                              '\$ ${(5000 - 1250).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Terms and Conditions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.orange.withOpacity(0.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Terms & Conditions:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Advance must be settled within 30 days\n'
                        '• Submit expense claims with receipts\n'
                        '• Unsettled advances will be deducted from salary\n'
                        '• Maximum advance limit: \$5,000\n'
                        '• Approval required from direct supervisor',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitAdvanceRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 12, 12, 120),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Submit Advance Request',
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

  void _submitAdvanceRequest() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically send the data to your backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Advance request submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _purposeController.dispose();
    super.dispose();
  }
}
