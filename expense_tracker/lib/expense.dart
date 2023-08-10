class Expense {
  final String id;
  final String category;
  final double amount;
  final String description;
  final DateTime date;

  Expense({
    required this.id,
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
  });

  @override
  String toString() {
    return 'Expense(id: $id, category: $category, amount: $amount, description: $description, date: $date)';
  }
}

List<String> categories = ['Food', 'Transportation', 'Entertainment', 'Bills'];

