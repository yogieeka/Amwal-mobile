import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Transactions page - View and manage all transactions
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
      body: _buildEmptyState(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Add new transaction
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Transaksi'),
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
}
