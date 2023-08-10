import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'expense_provider.dart';
import 'screens/expense_screen.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => ExpenseProvider(),
    child: ExpenseTrackerApp(),
  ),
);
// Rest of the code remains unchanged.

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpenseScreen(); // Use ExpenseScreen instead of the previous scaffold
  }
}
