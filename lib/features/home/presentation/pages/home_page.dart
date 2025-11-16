import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../transactions/presentation/providers/transaction_provider.dart';
import '../../../transactions/presentation/pages/add_transaction_page.dart';
import '../../../transactions/presentation/pages/analytics_page.dart';

/// Home page - Main dashboard of the app
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(transactionStatsProvider);
    final transactions = ref.watch(transactionsProvider);
    final recentTransactions = transactions.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Amwal Islamic'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppConstants.routeSettings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Card
            _buildGreetingCard(),

            // Quick Stats
            _buildQuickStats(stats),

            // Quick Actions
            _buildQuickActions(),

            // Recent Transactions
            _buildRecentTransactions(recentTransactions),

            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGreetingCard() {
    return Container(
      margin: const EdgeInsets.all(16),
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
          Text(
            Formatters.getGreeting(),
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pengguna', // TODO: Get from user profile
            style: TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            Formatters.formatHijriDate(DateTime.now()),
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(TransactionStats stats) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Keuangan Bulan Ini',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Pemasukan',
                  Formatters.formatCompactCurrency(stats.totalIncome),
                  Icons.arrow_downward,
                  AppColors.income,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Pengeluaran',
                  Formatters.formatCompactCurrency(stats.totalExpense),
                  Icons.arrow_upward,
                  AppColors.expense,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Zakat/Sedekah',
                  Formatters.formatCompactCurrency(stats.totalZakatSedekah),
                  Icons.volunteer_activism,
                  AppColors.zakat,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Saldo',
                  Formatters.formatCompactCurrency(stats.balance),
                  Icons.account_balance_wallet,
                  stats.balance >= 0 ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: AppColors.grey700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menu Utama',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildActionButton(
                'Zakat',
                Icons.volunteer_activism,
                AppColors.zakat,
                () => context.push(AppConstants.routeZakat),
              ),
              _buildActionButton(
                'Transaksi',
                Icons.receipt_long,
                AppColors.accentBlue,
                () => context.push(AppConstants.routeTransactions),
              ),
              _buildActionButton(
                'Investasi',
                Icons.trending_up,
                AppColors.investment,
                () => context.push(AppConstants.routeInvestment),
              ),
              _buildActionButton(
                'Hutang',
                Icons.credit_card,
                AppColors.error,
                () => context.push(AppConstants.routeDebt),
              ),
              _buildActionButton(
                'Target',
                Icons.flag,
                AppColors.secondaryGold,
                () => context.push(AppConstants.routeGoals),
              ),
              _buildActionButton(
                'Edukasi',
                Icons.school,
                AppColors.accentPurple,
                () => context.push(AppConstants.routeEducation),
              ),
              _buildActionButton(
                'Analisis',
                Icons.analytics,
                AppColors.secondaryGold,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AnalyticsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(List transactions) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transaksi Terbaru',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () => context.push(AppConstants.routeTransactions),
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          transactions.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: transactions.map((transaction) {
                    Color typeColor;
                    IconData typeIcon;

                    switch (transaction.type.name) {
                      case 'income':
                        typeColor = AppColors.income;
                        typeIcon = Icons.arrow_downward;
                        break;
                      case 'expense':
                        typeColor = AppColors.expense;
                        typeIcon = Icons.arrow_upward;
                        break;
                      case 'zakat':
                      case 'sedekah':
                        typeColor = AppColors.zakat;
                        typeIcon = Icons.volunteer_activism;
                        break;
                      default:
                        typeColor = AppColors.accentBlue;
                        typeIcon = Icons.trending_up;
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(typeIcon, color: typeColor, size: 20),
                        ),
                        title: Text(
                          transaction.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          '${transaction.category} • ${Formatters.formatDate(transaction.date)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey600,
                          ),
                        ),
                        trailing: Text(
                          '${transaction.type.name == 'expense' || transaction.type.name == 'zakat' || transaction.type.name == 'sedekah' ? '-' : '+'} ${Formatters.formatCompactCurrency(transaction.amount)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: typeColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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
              Icons.receipt_long_outlined,
              size: 64,
              color: AppColors.grey400,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada transaksi',
              style: TextStyle(
                color: AppColors.grey600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap tombol + untuk menambah transaksi',
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

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        switch (index) {
          case 0:
            context.go(AppConstants.routeHome);
            break;
          case 1:
            context.push(AppConstants.routeTransactions);
            break;
          case 2:
            context.push(AppConstants.routeInvestment);
            break;
          case 3:
            context.push(AppConstants.routeSettings);
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          activeIcon: Icon(Icons.receipt_long),
          label: 'Transaksi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up_outlined),
          activeIcon: Icon(Icons.trending_up),
          label: 'Investasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Pengaturan',
        ),
      ],
    );
  }

  void _showAddTransactionDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tambah Transaksi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.arrow_downward, color: AppColors.income),
              title: const Text('Pemasukan'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to add income
              },
            ),
            ListTile(
              leading: const Icon(Icons.arrow_upward, color: AppColors.expense),
              title: const Text('Pengeluaran'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to add expense
              },
            ),
            ListTile(
              leading: const Icon(Icons.volunteer_activism, color: AppColors.zakat),
              title: const Text('Zakat/Sedekah'),
              onTap: () {
                Navigator.pop(context);
                context.push(AppConstants.routeZakat);
              },
            ),
          ],
        ),
      ),
    );
  }
}
