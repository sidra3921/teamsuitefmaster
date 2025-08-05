import 'package:flutter/material.dart';

class ExpenseClaimScreen extends StatefulWidget {
  const ExpenseClaimScreen({super.key});

  @override
  State<ExpenseClaimScreen> createState() => _ExpenseClaimScreenState();
}

class _ExpenseClaimScreenState extends State<ExpenseClaimScreen> {
  final List<ExpenseItem> _expenses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Claim'),
        backgroundColor: const Color.fromARGB(255, 12, 12, 120),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Submit Expense Claim',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 12, 12, 120),
              ),
            ),
            const SizedBox(height: 20),

            // Add Expense Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addExpenseItem,
                icon: const Icon(Icons.add),
                label: const Text('Add Expense Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 12, 12, 120),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Expense Items List
            Expanded(
              child: _expenses.isEmpty
                  ? const Center(
                      child: Text(
                        'No expense items added yet.\nTap "Add Expense Item" to get started.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _expenses.length,
                      itemBuilder: (context, index) {
                        return _buildExpenseCard(_expenses[index], index);
                      },
                    ),
            ),

            // Total Amount
            if (_expenses.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    12,
                    12,
                    120,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$ ${_calculateTotal().toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 12, 12, 120),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _expenses.isEmpty ? null : _submitClaim,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 12, 12, 120),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Submit Expense Claim',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseCard(ExpenseItem expense, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  expense.category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 12, 12, 120),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '\$ ${expense.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _removeExpenseItem(index),
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
            Text(expense.description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              'Date: ${expense.date.day}/${expense.date.month}/${expense.date.year}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _addExpenseItem() {
    showDialog(
      context: context,
      builder: (context) => _ExpenseItemDialog(
        onAdd: (expense) {
          setState(() {
            _expenses.add(expense);
          });
        },
      ),
    );
  }

  void _removeExpenseItem(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  double _calculateTotal() {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  void _submitClaim() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Expense claim submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }
}

class ExpenseItem {
  final String category;
  final String description;
  final double amount;
  final DateTime date;

  ExpenseItem({
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
  });
}

class _ExpenseItemDialog extends StatefulWidget {
  final Function(ExpenseItem) onAdd;

  const _ExpenseItemDialog({required this.onAdd});

  @override
  State<_ExpenseItemDialog> createState() => _ExpenseItemDialogState();
}

class _ExpenseItemDialogState extends State<_ExpenseItemDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  final List<String> _categories = [
    'Travel',
    'Meals',
    'Accommodation',
    'Fuel',
    'Office Supplies',
    'Training',
    'Communication',
    'Entertainment',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Expense Item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 90),
                    ),
                    lastDate: DateTime.now(),
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
                    return 'Please select date';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final expense = ExpenseItem(
                category: _selectedCategory!,
                description: _descriptionController.text,
                amount: double.parse(_amountController.text),
                date: _selectedDate!,
              );
              widget.onAdd(expense);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
