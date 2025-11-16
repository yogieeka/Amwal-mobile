import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/transaction_repository.dart';

/// Provider for transaction box
final transactionBoxProvider = Provider<Box<TransactionModel>>((ref) {
  return Hive.box<TransactionModel>(AppConstants.transactionsBox);
});

/// Provider for transaction repository
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final box = ref.watch(transactionBoxProvider);
  return TransactionRepository(box);
});

/// Provider for all transactions
final transactionsProvider = StateNotifierProvider<TransactionsNotifier, List<TransactionModel>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return TransactionsNotifier(repository);
});

/// Notifier for transactions state
class TransactionsNotifier extends StateNotifier<List<TransactionModel>> {
  final TransactionRepository _repository;

  TransactionsNotifier(this._repository) : super([]) {
    loadTransactions();
  }

  /// Load all transactions
  void loadTransactions() {
    state = _repository.getAllTransactions();
  }

  /// Add new transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    await _repository.addTransaction(transaction);
    loadTransactions();
  }

  /// Update transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _repository.updateTransaction(transaction);
    loadTransactions();
  }

  /// Delete transaction
  Future<void> deleteTransaction(String id) async {
    await _repository.deleteTransaction(id);
    loadTransactions();
  }

  /// Get transactions by month
  List<TransactionModel> getTransactionsByMonth(int year, int month) {
    return _repository.getTransactionsByMonth(year, month);
  }

  /// Filter transactions by type
  void filterByType(String type) {
    state = _repository.getTransactionsByType(type);
  }

  /// Filter transactions by category
  void filterByCategory(String category) {
    state = _repository.getTransactionsByCategory(category);
  }

  /// Reset filter (show all)
  void resetFilter() {
    loadTransactions();
  }
}

/// Provider for transaction statistics
final transactionStatsProvider = Provider<TransactionStats>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

  return TransactionStats(
    totalIncome: repository.getTotalIncome(
      startDate: startOfMonth,
      endDate: endOfMonth,
    ),
    totalExpense: repository.getTotalExpense(
      startDate: startOfMonth,
      endDate: endOfMonth,
    ),
    totalZakatSedekah: repository.getTotalZakatSedekah(
      startDate: startOfMonth,
      endDate: endOfMonth,
    ),
    balance: repository.getBalance(
      startDate: startOfMonth,
      endDate: endOfMonth,
    ),
    spendingByCategory: repository.getSpendingByCategory(
      startDate: startOfMonth,
      endDate: endOfMonth,
    ),
  );
});

/// Transaction statistics model
class TransactionStats {
  final double totalIncome;
  final double totalExpense;
  final double totalZakatSedekah;
  final double balance;
  final Map<String, double> spendingByCategory;

  TransactionStats({
    required this.totalIncome,
    required this.totalExpense,
    required this.totalZakatSedekah,
    required this.balance,
    required this.spendingByCategory,
  });
}
