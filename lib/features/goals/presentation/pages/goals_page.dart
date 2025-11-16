import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Goals page - Financial goals management
class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Target Keuangan'),
      ),
      body: _buildEmptyState(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Add new goal
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Target'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flag_outlined,
            size: 100,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 24),
          Text(
            'Belum Ada Target',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Buat target keuangan Anda',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey600,
                ),
          ),
        ],
      ),
    );
  }
}
