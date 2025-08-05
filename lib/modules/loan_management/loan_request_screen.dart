import 'package:flutter/material.dart';
import 'dart:math' show pow;

class LoanRequestScreen extends StatefulWidget {
  const LoanRequestScreen({super.key});

  @override
  State<LoanRequestScreen> createState() => _LoanRequestScreenState();
}

class _LoanRequestScreenState extends State<LoanRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedLoanType;
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();
  final _installmentsController = TextEditingController();

  final List<String> _loanTypes = [
    'Personal Loan',
    'Emergency Loan',
    'Educational Loan',
    'Medical Loan',
    'Housing Loan',
    'Vehicle Loan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Request'),
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
                  'Submit Loan Request',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 12, 12, 120),
                  ),
                ),
                const SizedBox(height: 20),

                // Loan Type Dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Loan Type',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  value: _selectedLoanType,
                  items: _loanTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLoanType = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a loan type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Loan Amount
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Loan Amount',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.money),
                    prefixText: '\$ ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter loan amount';
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

                // Number of Installments
                TextFormField(
                  controller: _installmentsController,
                  decoration: const InputDecoration(
                    labelText: 'Number of Installments',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers),
                    helperText: 'Maximum 60 installments',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of installments';
                    }
                    final installments = int.tryParse(value);
                    if (installments == null) {
                      return 'Please enter a valid number';
                    }
                    if (installments <= 0 || installments > 60) {
                      return 'Installments must be between 1 and 60';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Monthly Installment (calculated)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calculate,
                        color: Color.fromARGB(255, 12, 12, 120),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Monthly Installment',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 12, 12, 120),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$ ${_calculateMonthlyInstallment()}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 12, 12, 120),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Reason
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Reason for Loan',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit),
                    helperText: 'Please provide detailed reason',
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a reason';
                    }
                    if (value.length < 10) {
                      return 'Please provide more detailed reason';
                    }
                    return null;
                  },
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
                        '• Interest rate: 5% per annum\n'
                        '• Processing fee: 2% of loan amount\n'
                        '• Late payment penalty: \$50\n'
                        '• Maximum loan amount: \$50,000\n'
                        '• Repayment will be deducted from salary',
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
                    onPressed: _submitLoanRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 12, 12, 120),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Submit Loan Request',
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

  String _calculateMonthlyInstallment() {
    final amount = double.tryParse(_amountController.text);
    final installments = int.tryParse(_installmentsController.text);

    if (amount != null && installments != null && installments > 0) {
      // Simple calculation with 5% annual interest
      final monthlyInterestRate = 0.05 / 12;
      final monthlyPayment =
          amount *
          (monthlyInterestRate * pow(1 + monthlyInterestRate, installments)) /
          (pow(1 + monthlyInterestRate, installments) - 1);
      return monthlyPayment.toStringAsFixed(2);
    }
    return '0.00';
  }

  void _submitLoanRequest() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically send the data to your backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Loan request submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    _installmentsController.dispose();
    super.dispose();
  }
}
