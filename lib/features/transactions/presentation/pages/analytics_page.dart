import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/expense_pie_chart.dart';
import '../../../../shared/widgets/income_expense_bar_chart.dart';
import '../providers/transaction_provider.dart';

/// Analytics page for transaction statistics and charts
class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(transactionStatsProvider);
    final repository = ref.watch(transactionRepositoryProvider);

    // Get current month date range
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    // Get spending by category for current month
    final spendingByCategory = repository.getSpendingByCategory(
      startDate: startOfMonth,
      endDate: endOfMonth,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analisis Keuangan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              // TODO: Show month picker
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur filter bulan akan segera hadir'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: AppColors.primaryGreen.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Periode Analisis',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_getMonthName(now.month)} ${now.year}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),

            // Overview Cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildOverviewCard(
                          'Total Pemasukan',
                          stats.totalIncome,
                          AppColors.income,
                          Icons.arrow_downward,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildOverviewCard(
                          'Total Pengeluaran',
                          stats.totalExpense + stats.totalZakatSedekah,
                          AppColors.expense,
                          Icons.arrow_upward,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildBalanceCard(stats.balance),
                ],
              ),
            ),

            // Income vs Expense Bar Chart
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Perbandingan Keuangan',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      IncomeExpenseBarChart(
                        income: stats.totalIncome,
                        expense: stats.totalExpense,
                        zakatSedekah: stats.totalZakatSedekah,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Spending by Category Pie Chart
            if (spendingByCategory.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pengeluaran per Kategori',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        ExpensePieChart(
                          categoryData: spendingByCategory,
                          totalAmount: stats.totalExpense,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Category Details List
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Kategori',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ..._buildCategoryList(spendingByCategory, stats.totalExpense),
                  ],
                ),
              ),
            ],

            // Tips Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: AppColors.primaryGreen.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb, color: AppColors.secondaryGold),
                          const SizedBox(width: 8),
                          Text(
                            'Tips Keuangan',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTip(stats),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(String title, double amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grey700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatCurrency(amount),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(double balance) {
    final isPositive = balance >= 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isPositive
            ? LinearGradient(
                colors: [AppColors.success, AppColors.success.withOpacity(0.7)],
              )
            : LinearGradient(
                colors: [AppColors.error, AppColors.error.withOpacity(0.7)],
              ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Saldo Bulan Ini',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatCurrency(balance.abs()),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isPositive ? 'Surplus' : 'Defisit',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryList(Map<String, double> categories, double total) {
    final sortedEntries = categories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.map((entry) {
      final percentage = (entry.value / total * 100);
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
            child: Text(
              '${percentage.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
          title: Text(entry.key),
          trailing: Text(
            _formatCurrency(entry.value),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.expense,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildTip(TransactionStats stats) {
    String tip = '';

    if (stats.balance < 0) {
      tip = 'Pengeluaran Anda melebihi pemasukan. Pertimbangkan untuk mengurangi pengeluaran atau mencari sumber pemasukan tambahan.';
    } else if (stats.totalZakatSedekah == 0 && stats.totalIncome > 0) {
      tip = 'Pertimbangkan untuk menyisihkan sebagian rezeki untuk zakat dan sedekah.';
    } else if (stats.balance > 0) {
      final savingsRate = (stats.balance / stats.totalIncome * 100);
      if (savingsRate < 10) {
        tip = 'Tingkat tabungan Anda ${savingsRate.toStringAsFixed(1)}%. Usahakan menabung minimal 10-20% dari penghasilan.';
      } else {
        tip = 'Bagus! Tingkat tabungan Anda ${savingsRate.toStringAsFixed(1)}%. Pertahankan pola keuangan yang sehat ini.';
      }
    } else {
      tip = 'Mulailah mencatat setiap transaksi untuk mendapatkan analisis keuangan yang akurat.';
    }

    return Text(
      tip,
      style: const TextStyle(fontSize: 13),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}jt';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(0)}rb';
    }
    return 'Rp ${amount.toStringAsFixed(0)}';
  }

  String _getMonthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }
}
