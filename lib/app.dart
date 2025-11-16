import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';

/// Main application widget
class AmwalIslamicApp extends ConsumerWidget {
  const AmwalIslamicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // TODO: Make this dynamic from settings

      // Routing
      routerConfig: AppRouter.router,

      // Localization
      locale: const Locale('id', 'ID'),
      supportedLocales: const [
        Locale('id', 'ID'), // Indonesian
        Locale('ar', 'SA'), // Arabic (for Islamic content)
      ],

      // Builder for additional wrappers
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0), // Prevent text scaling
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
