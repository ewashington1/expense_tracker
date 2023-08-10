import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../expense.dart';
import '../expense_provider.dart';
import './add_expense_screen.dart';

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedCategory = 'All';

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseData = Provider.of<ExpenseProvider>(context);
    List<Expense> expenses = expenseData.expenses;

    print("Start Date: $_startDate"); // Log start date
    print("End Date: $_endDate"); // Log end date
    print("Selected Category: $_selectedCategory"); // Log selected category
    print("All Expenses: $expenses"); // Log all expenses

    // Apply date filter
    if (_startDate != null && _endDate != null) {
      expenses = expenses.where((exp) => exp.date.isAfter(_startDate!) && exp.date.isBefore(_endDate!)).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      expenses = expenses.where((exp) => exp.category == _selectedCategory).toList();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              items: ['All', ...categories].map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value!),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () => _selectStartDate(context),
                child: Text(_startDate?.toString() ?? 'Select Start Date'),
              ),
              TextButton(
                onPressed: () => _selectEndDate(context),
                child: Text(_endDate?.toString() ?? 'Select End Date'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (ctx, index) {
                final expense = expenses[index];
                return ListTile(
                  title: Text(expense.category),
                  subtitle: Text(expense.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('\$${expense.amount}'),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => AddExpenseScreen(expense: expense),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          expenseData.deleteExpense(expense.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AddExpenseScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
