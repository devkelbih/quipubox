import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../ui/feedback/app_toast.dart';
import 'app_routes.dart';

class AppExitHandler {
  AppExitHandler._();

  static DateTime? _lastBackPress;
  static const Duration _exitInterval = Duration(seconds: 2);

  /// Maneja la pulsación del botón o gesto atrás en toda la aplicación.
  ///
  /// 1. Si el Drawer está abierto, lo cierra.
  /// 2. Si el Navigator puede hacer pop (subrutas, modales, bottom sheets), lo hace.
  /// 3. Si la ruta actual no es Home, navega a Home.
  /// 4. Si está en Home, requiere 2 toques en un lapso de 2 segundos para salir.
  static Future<bool> handlePop(BuildContext context) async {
    // 1. Si hay un Drawer abierto en el Scaffold actual, cerrarlo primero
    final scaffoldState = Scaffold.maybeOf(context);
    if (scaffoldState != null && scaffoldState.isDrawerOpen) {
      scaffoldState.closeDrawer();
      return false;
    }

    // 2. Si hay subrutas o diálogos/bottomsheets desapilables en el Navigator
    if (Navigator.of(context).canPop()) {
      context.pop();
      return false;
    }

    // 3. Verificar en qué ruta de GoRouter nos encontramos
    final currentRoute = GoRouterState.of(context).matchedLocation;

    // 4. Si no estamos en Home, regresar a Home
    if (currentRoute != AppRoutes.home) {
      context.go(AppRoutes.home);
      return false;
    }

    // 5. Estamos en Home -> Implementar toque doble para salir
    final now = DateTime.now();

    if (_lastBackPress == null ||
        now.difference(_lastBackPress!) > _exitInterval) {
      _lastBackPress = now;
      AppToast.show('Presiona de nuevo para salir', type: ToastType.info);
      return false;
    }

    await SystemNavigator.pop();
    return true;
  }
}