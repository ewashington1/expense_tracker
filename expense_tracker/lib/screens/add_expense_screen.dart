import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../expense.dart';
import '../expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;

  AddExpenseScreen({this.expense});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}
class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now(); // Adding the selected date variable

  @override
  void initState() {
    if (widget.expense != null) {
      _amountController.text = widget.expense!.amount.toString();
      _descriptionController.text = widget.expense!.description;
      _selectedCategory = widget.expense!.category;
    }
    super.initState();
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final expense = Expense(
        id: widget.expense?.id ?? DateTime.now().toString(),
        category: _selectedCategory,
        description: _descriptionController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate, // Adding the selected date to the Expense object
      );

      if (widget.expense == null) {
        Provider.of<ExpenseProvider>(context, listen: false).addExpense(expense);
      } else {
        Provider.of<ExpenseProvider>(context, listen: false).updateExpense(widget.expense!.id, expense);
      }

      Navigator.of(context).pop();
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: categories.map((category) { // Use the categories defined in expense.dart
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value!),
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
                validator: (value) {
                  if (value!.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text('Select Date: ${_selectedDate.toLocal()}'),
              ),
              ElevatedButton(
                onPressed: _saveExpense,
                child: Text('Save Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
