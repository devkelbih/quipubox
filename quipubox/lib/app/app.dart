import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../core/navigation/app_router.dart';
import '../core/navigation/navigation_keys.dart';
import '../core/theme/app_theme.dart';
import '../core/ui/widgets/connectivity_banner.dart';
import '../core/ui/feedback/app_blocking_loader_overlay.dart';
import '../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../features/settings/presentation/viewmodels/settings_viewmodel.dart';

class QuipuboxApp extends StatelessWidget {
  const QuipuboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsViewModel>();
    final router = context.watch<AppRouter>().router;

    return MaterialApp.router(
      title: 'Quipubox',
      locale: const Locale('es', 'PE'),
      supportedLocales: const [Locale('es', 'PE')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: NavigationKeys.scaffoldMessengerKey,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      routerConfig: router,
      builder: (context, child) {
        final preparingProfile = context.select<AuthViewModel, bool>(
          (auth) => auth.isPreparingProfile,
        );
        return Stack(
          fit: StackFit.expand,
          children: [
            AbsorbPointer(
              absorbing: preparingProfile,
              child: ConnectivityBanner(
                child: child ?? const SizedBox.shrink(),
              ),
            ),
            if (preparingProfile)
              const Positioned.fill(
                child: AppBlockingLoaderOverlay(
                  text: 'Preparando tu cuenta...',
                  message: 'Estamos cargando tus datos. Espera un momento.',
                ),
              ),
          ],
        );
      },
    );
  }
}
