import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

/// Zakat calculation and management page
class ZakatPage extends StatelessWidget {
  const ZakatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Zakat'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              _buildInfoCard(context),
              const SizedBox(height: 24),

              // Zakat Types
              Text(
                'Jenis Zakat',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              _buildZakatTypeCard(
                context,
                'Zakat Mal (Harta)',
                'Zakat atas harta yang mencapai nisab',
                Icons.account_balance_wallet,
                AppColors.primaryGreen,
              ),
              _buildZakatTypeCard(
                context,
                'Zakat Penghasilan',
                'Zakat atas gaji dan penghasilan',
                Icons.payments,
                AppColors.secondaryGold,
              ),
              _buildZakatTypeCard(
                context,
                'Zakat Perdagangan',
                'Zakat atas usaha dan perdagangan',
                Icons.store,
                AppColors.accentBlue,
              ),
              _buildZakatTypeCard(
                context,
                'Zakat Pertanian',
                'Zakat atas hasil pertanian',
                Icons.agriculture,
                AppColors.success,
              ),
              _buildZakatTypeCard(
                context,
                'Zakat Fitrah',
                'Zakat yang wajib di bulan Ramadan',
                Icons.mosque,
                AppColors.accentPurple,
              ),

              const SizedBox(height: 24),

              // Nisab Info
              _buildNisabInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.zakatGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.volunteer_activism, color: AppColors.white, size: 32),
              SizedBox(width: 12),
              Text(
                'Zakat',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Zakat adalah salah satu rukun Islam yang menyucikan harta dan menolong sesama.',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nisab: ${AppConstants.nisabPercentage}% dari harta yang telah mencapai haul (1 tahun)',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZakatTypeCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to specific zakat calculator
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.grey500),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNisabInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Nisab',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _buildNisabRow('Nisab Emas', '${AppConstants.goldNisab} gram'),
          _buildNisabRow('Nisab Perak', '${AppConstants.silverNisab} gram'),
          _buildNisabRow('Kadar Zakat', '${AppConstants.nisabPercentage}%'),
          _buildNisabRow('Haul (Periode)', '${AppConstants.nisabMonths} bulan Hijriyah'),
        ],
      ),
    );
  }

  Widget _buildNisabRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.grey700)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}
