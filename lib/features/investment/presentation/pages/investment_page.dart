import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Investment page - Manage syariah investments
class InvestmentPage extends StatelessWidget {
  const InvestmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investasi Syariah'),
      ),
      body: _buildEmptyState(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Add new investment
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Investasi'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_up_outlined,
            size: 100,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 24),
          Text(
            'Belum Ada Investasi',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Kelola portfolio investasi syariah Anda',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey600,
                ),
          ),
        ],
      ),
    );
  }
}
