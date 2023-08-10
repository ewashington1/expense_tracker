import 'package:flutter/foundation.dart';
import 'expense.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses {
    return [..._expenses];
  }

  // Get expenses by date range
  List<Expense> getExpensesByDate(DateTime start, DateTime end) {
    return _expenses.where((exp) => exp.date.isAfter(start) && exp.date.isBefore(end)).toList();
  }

  // Get expenses by category
  List<Expense> getExpensesByCategory(String category) {
    return _expenses.where((exp) => exp.category == category).toList();
  }

  // Get expenses by both date range and category
  List<Expense> getExpensesByFilters(DateTime? start, DateTime? end, String category) {
    List<Expense> filteredExpenses = _expenses;

    if (start != null && end != null) {
      filteredExpenses = filteredExpenses.where((exp) => exp.date.isAfter(start) && exp.date.isBefore(end)).toList();
    }

    if (category != 'All') {
      filteredExpenses = filteredExpenses.where((exp) => exp.category == category).toList();
    }

    return filteredExpenses;
  }



  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  void updateExpense(String id, Expense newExpense) {
    final index = _expenses.indexWhere((exp) => exp.id == id);
    _expenses[index] = newExpense;
    notifyListeners();
  }

  void deleteExpense(String id) {
    _expenses.removeWhere((exp) => exp.id == id);
    notifyListeners();
  }
}
