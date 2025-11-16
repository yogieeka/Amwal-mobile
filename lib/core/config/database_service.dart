import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

/// Service for managing Hive database initialization and operations
class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  /// Initialize Hive database
  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters here
    // Example: Hive.registerAdapter(TransactionAdapter());
    // Hive.registerAdapter(ZakatAdapter());
    // etc.

    // Open boxes
    await _openBoxes();
  }

  /// Open all required Hive boxes
  Future<void> _openBoxes() async {
    await Future.wait([
      Hive.openBox(AppConstants.hiveBoxName),
      Hive.openBox(AppConstants.transactionsBox),
      Hive.openBox(AppConstants.zakatBox),
      Hive.openBox(AppConstants.investmentBox),
      Hive.openBox(AppConstants.debtBox),
      Hive.openBox(AppConstants.goalsBox),
      Hive.openBox(AppConstants.settingsBox),
    ]);
  }

  /// Get a specific box
  Box getBox(String boxName) {
    return Hive.box(boxName);
  }

  /// Get main app box
  Box getMainBox() {
    return Hive.box(AppConstants.hiveBoxName);
  }

  /// Get transactions box
  Box getTransactionsBox() {
    return Hive.box(AppConstants.transactionsBox);
  }

  /// Get zakat box
  Box getZakatBox() {
    return Hive.box(AppConstants.zakatBox);
  }

  /// Get investment box
  Box getInvestmentBox() {
    return Hive.box(AppConstants.investmentBox);
  }

  /// Get debt box
  Box getDebtBox() {
    return Hive.box(AppConstants.debtBox);
  }

  /// Get goals box
  Box getGoalsBox() {
    return Hive.box(AppConstants.goalsBox);
  }

  /// Get settings box
  Box getSettingsBox() {
    return Hive.box(AppConstants.settingsBox);
  }

  /// Close all boxes
  Future<void> closeAll() async {
    await Hive.close();
  }

  /// Delete all data (for testing or reset)
  Future<void> deleteAll() async {
    await Hive.deleteFromDisk();
  }

  /// Clear specific box
  Future<void> clearBox(String boxName) async {
    final box = Hive.box(boxName);
    await box.clear();
  }
}
