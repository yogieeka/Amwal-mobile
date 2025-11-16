import 'package:hive/hive.dart';
import '../models/investment_model.dart';

/// Repository for managing investments
class InvestmentRepository {
  static const String _boxName = 'investments';
  late Box<InvestmentModel> _box;

  InvestmentRepository() {
    _box = Hive.box<InvestmentModel>(_boxName);
  }

  /// Get all investments
  List<InvestmentModel> getAllInvestments() {
    return _box.values.toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  /// Get active investments
  List<InvestmentModel> getActiveInvestments() {
    return _box.values.where((inv) => inv.isActive).toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  /// Get investments by type
  List<InvestmentModel> getInvestmentsByType(InvestmentType type) {
    return _box.values.where((inv) => inv.type == type).toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  /// Get investment by ID
  InvestmentModel? getInvestmentById(String id) {
    return _box.values.firstWhere(
      (inv) => inv.id == id,
      orElse: () => throw Exception('Investment not found'),
    );
  }

  /// Add new investment
  Future<void> addInvestment(InvestmentModel investment) async {
    await _box.put(investment.id, investment);
  }

  /// Update investment
  Future<void> updateInvestment(InvestmentModel investment) async {
    await _box.put(investment.id, investment);
  }

  /// Delete investment
  Future<void> deleteInvestment(String id) async {
    await _box.delete(id);
  }

  /// Get total invested amount
  double getTotalInvested() {
    return _box.values.fold(0.0, (sum, inv) => sum + inv.initialAmount);
  }

  /// Get total current value
  double getTotalCurrentValue() {
    return _box.values.fold(0.0, (sum, inv) => sum + inv.currentValue);
  }

  /// Get total profit
  double getTotalProfit() {
    return getTotalCurrentValue() - getTotalInvested();
  }

  /// Get total return percentage
  double getTotalReturnPercentage() {
    final invested = getTotalInvested();
    if (invested == 0) return 0.0;
    return (getTotalProfit() / invested) * 100;
  }

  /// Get investment statistics
  InvestmentStats getInvestmentStats() {
    final allInvestments = getAllInvestments();
    final activeInvestments = allInvestments.where((inv) => inv.isActive).length;

    final investmentByType = <InvestmentType, double>{};
    for (var type in InvestmentType.values) {
      final typeInvestments = getInvestmentsByType(type);
      final total = typeInvestments.fold(0.0, (sum, inv) => sum + inv.currentValue);
      if (total > 0) {
        investmentByType[type] = total;
      }
    }

    return InvestmentStats(
      totalInvested: getTotalInvested(),
      totalCurrentValue: getTotalCurrentValue(),
      totalProfit: getTotalProfit(),
      totalReturn: getTotalReturnPercentage(),
      activeInvestments: activeInvestments,
      investmentByType: investmentByType,
    );
  }

  /// Get investments by date range
  List<InvestmentModel> getInvestmentsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _box.values.where((inv) {
      return inv.startDate.isAfter(startDate) && inv.startDate.isBefore(endDate);
    }).toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  /// Close all ended investments
  Future<void> closeInvestment(String id) async {
    final investment = getInvestmentById(id);
    if (investment != null) {
      final updatedInvestment = investment.copyWith(
        isActive: false,
        endDate: DateTime.now(),
      );
      await updateInvestment(updatedInvestment);
    }
  }
}
