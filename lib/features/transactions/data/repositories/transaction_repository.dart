import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/transaction_model.dart';

/// Repository for managing transactions
class TransactionRepository {
  final Box<TransactionModel> _box;

  TransactionRepository(this._box);

  /// Get all transactions
  List<TransactionModel> getAllTransactions() {
    return _box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Sort by date descending
  }

  /// Get transaction by id
  TransactionModel? getTransactionById(String id) {
    return _box.get(id);
  }

  /// Get transactions by date range
  List<TransactionModel> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _box.values
        .where((transaction) =>
            transaction.date.isAfter(startDate) &&
            transaction.date.isBefore(endDate))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Get transactions by month
  List<TransactionModel> getTransactionsByMonth(int year, int month) {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59);
    return getTransactionsByDateRange(startDate, endDate);
  }

  /// Get transactions by type
  List<TransactionModel> getTransactionsByType(String type) {
    return _box.values
        .where((transaction) => transaction.type.name == type)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Get transactions by category
  List<TransactionModel> getTransactionsByCategory(String category) {
    return _box.values
        .where((transaction) => transaction.category == category)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Add new transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  /// Update transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  /// Delete transaction
  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  /// Delete all transactions
  Future<void> deleteAllTransactions() async {
    await _box.clear();
  }

  /// Get total income
  double getTotalIncome({DateTime? startDate, DateTime? endDate}) {
    var transactions = _box.values.where((t) =>
      t.type.name == 'income' || t.type.name == 'investment'
    );

    if (startDate != null && endDate != null) {
      transactions = transactions.where((t) =>
          t.date.isAfter(startDate) && t.date.isBefore(endDate));
    }

    return transactions.fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  /// Get total expense
  double getTotalExpense({DateTime? startDate, DateTime? endDate}) {
    var transactions = _box.values.where((t) => t.type.name == 'expense');

    if (startDate != null && endDate != null) {
      transactions = transactions.where((t) =>
          t.date.isAfter(startDate) && t.date.isBefore(endDate));
    }

    return transactions.fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  /// Get total zakat/sedekah
  double getTotalZakatSedekah({DateTime? startDate, DateTime? endDate}) {
    var transactions = _box.values.where((t) =>
      t.type.name == 'zakat' || t.type.name == 'sedekah'
    );

    if (startDate != null && endDate != null) {
      transactions = transactions.where((t) =>
          t.date.isAfter(startDate) && t.date.isBefore(endDate));
    }

    return transactions.fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  /// Get balance
  double getBalance({DateTime? startDate, DateTime? endDate}) {
    final income = getTotalIncome(startDate: startDate, endDate: endDate);
    final expense = getTotalExpense(startDate: startDate, endDate: endDate);
    final zakatSedekah = getTotalZakatSedekah(startDate: startDate, endDate: endDate);
    return income - expense - zakatSedekah;
  }

  /// Get spending by category
  Map<String, double> getSpendingByCategory({DateTime? startDate, DateTime? endDate}) {
    var transactions = _box.values.where((t) => t.type.name == 'expense');

    if (startDate != null && endDate != null) {
      transactions = transactions.where((t) =>
          t.date.isAfter(startDate) && t.date.isBefore(endDate));
    }

    final Map<String, double> categoryTotals = {};
    for (var transaction in transactions) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }

    return categoryTotals;
  }
}
