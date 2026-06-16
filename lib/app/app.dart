import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/network/connectivity_viewmodel.dart';
import 'package:quipubox/core/ui/app_toast.dart';

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
      builder: (context, child) {
        return _ConnectivityListener(child: child ?? const SizedBox.shrink());
      },
    );
  }
}

class _ConnectivityListener extends StatefulWidget {
  final Widget child;

  const _ConnectivityListener({required this.child});

  @override
  State<_ConnectivityListener> createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<_ConnectivityListener> {
  bool? _lastStatus;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final connectivity = context.watch<ConnectivityViewModel>();

    if (!connectivity.hasCheckedOnce) return;

    if (_lastStatus == null) {
      _lastStatus = connectivity.isOnline;
      return;
    }

    if (_lastStatus == connectivity.isOnline) return;

    _lastStatus = connectivity.isOnline;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      AppToast.show(
        connectivity.isOnline
            ? 'Conexión restaurada.'
            : 'Sin conexión a internet.',
        type: connectivity.isOnline ? ToastType.success : ToastType.error,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
