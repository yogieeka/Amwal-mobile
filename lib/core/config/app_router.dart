import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/zakat/presentation/pages/zakat_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../features/investment/presentation/pages/investment_page.dart';
import '../../features/debt/presentation/pages/debt_page.dart';
import '../../features/goals/presentation/pages/goals_page.dart';
import '../../features/education/presentation/pages/education_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/gamification/presentation/pages/achievements_page.dart';
import '../constants/app_constants.dart';

/// GoRouter configuration for the app
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppConstants.routeHome,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppConstants.routeHome,
        name: 'home',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeZakat,
        name: 'zakat',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ZakatPage(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeTransactions,
        name: 'transactions',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const TransactionsPage(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeInvestment,
        name: 'investment',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const InvestmentPage(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeDebt,
        name: 'debt',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const DebtPage(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeGoals,
        name: 'goals',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const GoalsPage(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeEducation,
        name: 'education',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const EducationPage(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeSettings,
        name: 'settings',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SettingsPage(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeAchievements,
        name: 'achievements',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const AchievementsPage(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Halaman tidak ditemukan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.routeHome),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    ),
  );
}
