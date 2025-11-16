import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/investment_model.dart';
import '../providers/investment_provider.dart';
import 'add_investment_page.dart';

/// Investment tracking page - Main page for managing investments
class InvestmentPage extends ConsumerWidget {
  const InvestmentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final investments = ref.watch(investmentsProvider);
    final stats = ref.watch(investmentStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Investasi Syariah'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stats Overview
          _buildStatsCard(stats),
          const SizedBox(height: 24),

          // Portfolio Breakdown
          if (stats.investmentByType.isNotEmpty) ...[
            Text(
              'Portofolio Investasi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildPortfolioBreakdown(stats),
            const SizedBox(height: 24),
          ],

          // Investments List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daftar Investasi',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                '${investments.length} investasi',
                style: TextStyle(
                  color: AppColors.grey600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (investments.isEmpty)
            _buildEmptyState(context)
          else
            ...investments.map((investment) => _buildInvestmentCard(
                  context,
                  ref,
                  investment,
                )),

          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddInvestmentPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatsCard(InvestmentStats stats) {
    final profitPercentage = stats.totalReturn;
    final isProfit = stats.totalProfit >= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.islamicGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up, color: AppColors.white, size: 28),
              SizedBox(width: 12),
              Text(
                'Total Investasi',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            Formatters.formatCurrency(stats.totalCurrentValue),
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isProfit ? Icons.arrow_upward : Icons.arrow_downward,
                color: AppColors.white,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${isProfit ? '+' : ''}${Formatters.formatCurrency(stats.totalProfit)} (${profitPercentage.toStringAsFixed(2)}%)',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Divider(height: 32, color: AppColors.white),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Modal',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.formatCompactCurrency(stats.totalInvested),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Investasi Aktif',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${stats.activeInvestments}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioBreakdown(InvestmentStats stats) {
    final sortedTypes = stats.investmentByType.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: sortedTypes.map((entry) {
            final percentage =
                (entry.value / stats.totalCurrentValue * 100).toStringAsFixed(1);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getTypeColor(entry.key).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getTypeIcon(entry.key),
                      color: _getTypeColor(entry.key),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$percentage%',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    Formatters.formatCompactCurrency(entry.value),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getTypeColor(entry.key),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInvestmentCard(
    BuildContext context,
    WidgetRef ref,
    InvestmentModel investment,
  ) {
    final profit = investment.currentValue - investment.initialAmount;
    final profitPercentage =
        (profit / investment.initialAmount * 100).toStringAsFixed(2);
    final isProfit = profit >= 0;

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _editInvestment(context, investment),
            backgroundColor: AppColors.accentBlue,
            foregroundColor: AppColors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (_) => _deleteInvestment(context, ref, investment),
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.white,
            icon: Icons.delete,
            label: 'Hapus',
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: () => _showInvestmentDetail(context, ref, investment),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _getTypeColor(investment.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getTypeIcon(investment.type),
                        color: _getTypeColor(investment.type),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            investment.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                investment.type.displayName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grey600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: investment.isActive
                                      ? AppColors.success.withOpacity(0.1)
                                      : AppColors.grey300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  investment.isActive ? 'Aktif' : 'Selesai',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: investment.isActive
                                        ? AppColors.success
                                        : AppColors.grey600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nilai Saat Ini',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Formatters.formatCurrency(investment.currentValue),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Keuntungan',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              isProfit ? Icons.trending_up : Icons.trending_down,
                              size: 16,
                              color: isProfit ? AppColors.success : AppColors.error,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${isProfit ? '+' : ''}${Formatters.formatCompactCurrency(profit)} ($profitPercentage%)',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isProfit ? AppColors.success : AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.trending_up_outlined,
              size: 64,
              color: AppColors.grey400,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada investasi',
              style: TextStyle(
                color: AppColors.grey600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap tombol + untuk menambah investasi',
              style: TextStyle(
                color: AppColors.grey500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(InvestmentType type) {
    switch (type) {
      case InvestmentType.sukuk:
        return AppColors.primaryGreen;
      case InvestmentType.sahamSyariah:
        return AppColors.accentBlue;
      case InvestmentType.reksadanaSyariah:
        return AppColors.accentPurple;
      case InvestmentType.emas:
        return AppColors.secondaryGold;
      case InvestmentType.properti:
        return AppColors.investment;
      case InvestmentType.deposito:
        return AppColors.success;
      case InvestmentType.bisnis:
        return AppColors.zakat;
    }
  }

  IconData _getTypeIcon(InvestmentType type) {
    switch (type) {
      case InvestmentType.sukuk:
        return Icons.account_balance;
      case InvestmentType.sahamSyariah:
        return Icons.show_chart;
      case InvestmentType.reksadanaSyariah:
        return Icons.pie_chart;
      case InvestmentType.emas:
        return Icons.diamond;
      case InvestmentType.properti:
        return Icons.home;
      case InvestmentType.deposito:
        return Icons.savings;
      case InvestmentType.bisnis:
        return Icons.store;
    }
  }

  void _editInvestment(BuildContext context, InvestmentModel investment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddInvestmentPage(investment: investment),
      ),
    );
  }

  void _deleteInvestment(
    BuildContext context,
    WidgetRef ref,
    InvestmentModel investment,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Investasi'),
        content: Text('Apakah Anda yakin ingin menghapus "${investment.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              ref.read(investmentsProvider.notifier).deleteInvestment(investment.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Investasi berhasil dihapus')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showInvestmentDetail(
    BuildContext context,
    WidgetRef ref,
    InvestmentModel investment,
  ) {
    final profit = investment.currentValue - investment.initialAmount;
    final profitPercentage =
        (profit / investment.initialAmount * 100).toStringAsFixed(2);
    final isProfit = profit >= 0;
    final daysInvested = DateTime.now().difference(investment.startDate).inDays;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _getTypeColor(investment.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getTypeIcon(investment.type),
                      color: _getTypeColor(investment.type),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          investment.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          investment.type.displayName,
                          style: TextStyle(
                            color: AppColors.grey600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              _buildDetailRow('Modal Awal', Formatters.formatCurrency(investment.initialAmount)),
              const SizedBox(height: 12),
              _buildDetailRow('Nilai Saat Ini', Formatters.formatCurrency(investment.currentValue)),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Keuntungan',
                '${isProfit ? '+' : ''}${Formatters.formatCurrency(profit)} ($profitPercentage%)',
                valueColor: isProfit ? AppColors.success : AppColors.error,
              ),
              const SizedBox(height: 12),
              _buildDetailRow('Return Ekspektasi', '${investment.expectedReturn}% p.a.'),
              const SizedBox(height: 12),
              _buildDetailRow('Tanggal Mulai', Formatters.formatDate(investment.startDate)),
              const SizedBox(height: 12),
              _buildDetailRow('Durasi', '$daysInvested hari'),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Status',
                investment.isActive ? 'Aktif' : 'Selesai',
                valueColor: investment.isActive ? AppColors.success : AppColors.grey600,
              ),
              if (investment.description.isNotEmpty) ...[
                const Divider(height: 32),
                Text(
                  'Deskripsi',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(investment.description),
              ],
              if (investment.notes.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Catatan',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(investment.notes),
              ],
              const SizedBox(height: 24),
              if (investment.isActive)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _closeInvestment(context, ref, investment);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Tutup Investasi'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.grey700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.primaryGreen,
          ),
        ),
      ],
    );
  }

  void _closeInvestment(
    BuildContext context,
    WidgetRef ref,
    InvestmentModel investment,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tutup Investasi'),
        content: Text(
          'Apakah Anda yakin ingin menutup investasi "${investment.name}"? '
          'Investasi yang ditutup tidak dapat diaktifkan kembali.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              ref.read(investmentsProvider.notifier).closeInvestment(investment.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Investasi berhasil ditutup')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.warning),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Investasi Syariah'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Investasi Syariah',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Investasi yang sesuai dengan prinsip-prinsip syariah Islam, '
                'menghindari riba, gharar (ketidakpastian), dan maysir (spekulasi).',
              ),
              SizedBox(height: 16),
              Text(
                'Jenis Investasi:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• Sukuk: Obligasi syariah\n'
                '• Saham Syariah: Saham halal\n'
                '• Reksadana Syariah: Dana investasi halal\n'
                '• Emas: Investasi logam mulia\n'
                '• Properti: Investasi tanah/bangunan\n'
                '• Deposito Syariah: Tabungan berjangka\n'
                '• Bisnis: Usaha halal',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
