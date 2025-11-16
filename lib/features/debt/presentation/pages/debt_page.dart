import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Debt page - Manage debts and receivables
class DebtPage extends StatelessWidget {
  const DebtPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hutang Piutang'),
      ),
      body: _buildEmptyState(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Add new debt/receivable
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Hutang/Piutang'),
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
            'Belum Ada Hutang/Piutang',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Catat dan kelola hutang piutang Anda',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey600,
                ),
          ),
        ],
      ),
    );
  }
}
