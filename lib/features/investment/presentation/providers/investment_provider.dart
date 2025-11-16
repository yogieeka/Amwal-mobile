import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/investment_model.dart';
import '../../data/repositories/investment_repository.dart';

/// Provider for investment repository
final investmentRepositoryProvider = Provider<InvestmentRepository>((ref) {
  return InvestmentRepository();
});

/// Provider for all investments
final investmentsProvider =
    StateNotifierProvider<InvestmentsNotifier, List<InvestmentModel>>((ref) {
  final repository = ref.watch(investmentRepositoryProvider);
  return InvestmentsNotifier(repository);
});

/// Provider for investment statistics
final investmentStatsProvider = Provider<InvestmentStats>((ref) {
  final repository = ref.watch(investmentRepositoryProvider);
  ref.watch(investmentsProvider); // Re-compute when investments change
  return repository.getInvestmentStats();
});

/// Provider for active investments
final activeInvestmentsProvider = Provider<List<InvestmentModel>>((ref) {
  final investments = ref.watch(investmentsProvider);
  return investments.where((inv) => inv.isActive).toList();
});

/// Notifier for managing investments state
class InvestmentsNotifier extends StateNotifier<List<InvestmentModel>> {
  final InvestmentRepository _repository;

  InvestmentsNotifier(this._repository) : super([]) {
    _loadInvestments();
  }

  void _loadInvestments() {
    state = _repository.getAllInvestments();
  }

  Future<void> addInvestment(InvestmentModel investment) async {
    await _repository.addInvestment(investment);
    _loadInvestments();
  }

  Future<void> updateInvestment(InvestmentModel investment) async {
    await _repository.updateInvestment(investment);
    _loadInvestments();
  }

  Future<void> deleteInvestment(String id) async {
    await _repository.deleteInvestment(id);
    _loadInvestments();
  }

  Future<void> closeInvestment(String id) async {
    await _repository.closeInvestment(id);
    _loadInvestments();
  }

  void refresh() {
    _loadInvestments();
  }
}
