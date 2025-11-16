import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/enums.dart';
import '../../data/models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import 'add_transaction_page.dart';

/// Transactions page - View and manage all transactions
class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  String _filterType = 'all';

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider);
    final stats = ref.watch(transactionStatsProvider);

    final filteredTransactions = _filterType == 'all'
        ? transactions
        : transactions.where((t) => t.type.name == _filterType).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filterType = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('Semua')),
              const PopupMenuItem(value: 'income', child: Text('Pemasukan')),
              const PopupMenuItem(value: 'expense', child: Text('Pengeluaran')),
              const PopupMenuItem(value: 'zakat', child: Text('Zakat')),
              const PopupMenuItem(value: 'sedekah', child: Text('Sedekah')),
              const PopupMenuItem(value: 'investment', child: Text('Investasi')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Summary Card
          _buildStatsSummary(stats),

          // Transactions List
          Expanded(
            child: filteredTransactions.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];
                      return _buildTransactionItem(context, transaction);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionPage(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }

  Widget _buildStatsSummary(TransactionStats stats) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan Bulan Ini',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Pemasukan',
                    stats.totalIncome,
                    AppColors.income,
                    Icons.arrow_downward,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    'Pengeluaran',
                    stats.totalExpense,
                    AppColors.expense,
                    Icons.arrow_upward,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Zakat/Sedekah',
                    stats.totalZakatSedekah,
                    AppColors.zakat,
                    Icons.volunteer_activism,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    'Saldo',
                    stats.balance,
                    stats.balance >= 0 ? AppColors.success : AppColors.error,
                    Icons.account_balance_wallet,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, double amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            Formatters.formatCompactCurrency(amount),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, TransactionModel transaction) {
    Color typeColor;
    IconData typeIcon;

    switch (transaction.type) {
      case TransactionType.income:
        typeColor = AppColors.income;
        typeIcon = Icons.arrow_downward;
        break;
      case TransactionType.expense:
        typeColor = AppColors.expense;
        typeIcon = Icons.arrow_upward;
        break;
      case TransactionType.zakat:
        typeColor = AppColors.zakat;
        typeIcon = Icons.volunteer_activism;
        break;
      case TransactionType.sedekah:
        typeColor = AppColors.sedekah;
        typeIcon = Icons.favorite;
        break;
      case TransactionType.investment:
        typeColor = AppColors.investment;
        typeIcon = Icons.trending_up;
        break;
    }

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTransactionPage(
                    transaction: transaction,
                  ),
                ),
              );
            },
            backgroundColor: AppColors.accentBlue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) {
              _showDeleteConfirmation(transaction);
            },
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Hapus',
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: typeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(typeIcon, color: typeColor),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${transaction.category} • ${Formatters.formatDate(transaction.date)}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey600,
              ),
            ),
            if (transaction.description != null)
              Text(
                transaction.description!,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.grey500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: Text(
          '${transaction.type == TransactionType.expense || transaction.type == TransactionType.zakat || transaction.type == TransactionType.sedekah ? '-' : '+'} ${Formatters.formatCurrency(transaction.amount)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: typeColor,
            fontSize: 14,
          ),
        ),
        onTap: () {
          _showTransactionDetail(transaction);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 100,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 24),
          Text(
            'Belum Ada Transaksi',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai catat transaksi keuangan Anda',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey600,
                ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetail(TransactionModel transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  transaction.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  Formatters.formatCurrency(transaction.amount),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                _buildDetailRow('Tipe', transaction.type.displayName),
                _buildDetailRow('Kategori', transaction.category),
                _buildDetailRow('Tanggal', Formatters.formatDateLong(transaction.date)),
                if (transaction.description != null)
                  _buildDetailRow('Deskripsi', transaction.description!),
                if (transaction.notes != null)
                  _buildDetailRow('Catatan', transaction.notes!),
                if (transaction.isRecurring)
                  _buildDetailRow('Berulang', transaction.recurringPeriod ?? '-'),
                _buildDetailRow(
                  'Dibuat',
                  Formatters.formatDateTime(transaction.createdAt),
                ),
                if (transaction.updatedAt != null)
                  _buildDetailRow(
                    'Diupdate',
                    Formatters.formatDateTime(transaction.updatedAt!),
                  ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTransactionPage(
                                transaction: transaction,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showDeleteConfirmation(transaction);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Hapus'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                        ),
                      ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.grey600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(TransactionModel transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Transaksi'),
        content: Text(
          'Apakah Anda yakin ingin menghapus transaksi "${transaction.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(transactionsProvider.notifier).deleteTransaction(transaction.id);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transaksi berhasil dihapus'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
