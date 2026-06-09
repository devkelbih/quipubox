import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../features/settings/presentation/viewmodels/settings_viewmodel.dart';

class QuipuboxApp extends StatelessWidget {
  const QuipuboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsViewModel>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Quipubox',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      routerConfig: AppRouter.router,
    );
  }
}
