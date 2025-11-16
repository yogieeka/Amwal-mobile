import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/config/theme_provider.dart';

/// Settings page - App settings and preferences
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Umum'),
          _buildSettingsTile(
            icon: Icons.person_outline,
            title: 'Profil',
            subtitle: 'Kelola informasi profil Anda',
            onTap: () {
              // TODO: Navigate to profile
            },
          ),
          _buildSettingsTile(
            icon: Icons.language,
            title: 'Bahasa',
            subtitle: 'Bahasa Indonesia',
            onTap: () {
              // TODO: Change language
            },
          ),
          _buildSettingsTile(
            icon: Icons.currency_exchange,
            title: 'Mata Uang',
            subtitle: AppConstants.defaultCurrency,
            onTap: () {
              // TODO: Change currency
            },
          ),

          _buildSectionHeader(context, 'Tampilan'),
          _buildSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: 'Mode Gelap',
            subtitle: 'Aktifkan mode gelap',
            value: themeMode == ThemeMode.dark,
            onChanged: (value) {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),

          _buildSectionHeader(context, 'Pengingat'),
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Pengingat Zakat',
            subtitle: 'Pengingat untuk menunaikan zakat',
            value: true,
            onChanged: (value) {
              // TODO: Toggle zakat reminder
            },
          ),
          _buildSwitchTile(
            icon: Icons.volunteer_activism_outlined,
            title: 'Pengingat Sedekah',
            subtitle: 'Pengingat sedekah rutin',
            value: true,
            onChanged: (value) {
              // TODO: Toggle sedekah reminder
            },
          ),

          _buildSectionHeader(context, 'Data'),
          _buildSettingsTile(
            icon: Icons.backup_outlined,
            title: 'Cadangkan Data',
            subtitle: 'Backup data ke cloud',
            onTap: () {
              // TODO: Backup data
            },
          ),
          _buildSettingsTile(
            icon: Icons.restore_outlined,
            title: 'Pulihkan Data',
            subtitle: 'Restore data dari backup',
            onTap: () {
              // TODO: Restore data
            },
          ),

          _buildSectionHeader(context, 'Tentang'),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'Tentang Aplikasi',
            subtitle: 'Versi ${AppConstants.appVersion}',
            onTap: () {
              // TODO: Show about dialog
            },
          ),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Kebijakan Privasi',
            subtitle: 'Baca kebijakan privasi',
            onTap: () {
              // TODO: Show privacy policy
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey500),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.primaryGreen),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primaryGreen,
    );
  }
}
