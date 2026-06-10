import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/navigation/app_router.dart';
import '../core/navigation/navigation_keys.dart';
import '../core/theme/app_theme.dart';
import '../features/settings/presentation/viewmodels/settings_viewmodel.dart';

class QuipuboxApp extends StatelessWidget {
  const QuipuboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsViewModel>();
    final router = context.watch<AppRouter>().router;

    return MaterialApp.router(
      title: 'Quipubox',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: NavigationKeys.scaffoldMessengerKey,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      routerConfig: router,
    );
  }
}
