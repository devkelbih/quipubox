import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/company/presentation/screens/company_profile_screen.dart';

// Screens simples (Solo ListScreen, sus forms son BottomSheets)
import '../../features/sedes/presentation/screens/sedes_list_screen.dart';
import '../../features/lugares_operativos/presentation/screens/lugares_operativos_list_screen.dart';
import '../../features/puestos/presentation/screens/puestos_list_screen.dart';
import '../../features/frutas/presentation/screens/frutas_list_screen.dart';
import '../../features/variedades/presentation/screens/variedades_list_screen.dart';
import '../../features/calidades/presentation/screens/calidades_list_screen.dart';
import '../../features/tipos_jaba/presentation/screens/tipos_jaba_list_screen.dart';
import '../../features/camiones/presentation/screens/camiones_list_screen.dart';

// Screens complejas (Tienen ListScreen + FormScreen independiente)
import '../../features/usuarios/domain/entities/usuario.dart';
import '../../features/usuarios/presentation/screens/usuarios_form_screen.dart';
import '../../features/usuarios/presentation/screens/usuarios_list_screen.dart';

import '../../features/clientes/domain/entities/cliente.dart';
import '../../features/clientes/presentation/screens/clientes_form_screen.dart';
import '../../features/clientes/presentation/screens/clientes_list_screen.dart';

import 'app_routes.dart';
import 'navigation_keys.dart';

class AppRouter {
  final AuthViewModel authViewModel;
  AppRouter(this.authViewModel);

  late final GoRouter router = GoRouter(
    navigatorKey: NavigationKeys.rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: authViewModel,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isSplash = location == AppRoutes.splash;
      final isLogin = location == AppRoutes.login;
      final isAuthRoute = isSplash || isLogin;
      final canOpenApp = authViewModel.canOpenApp;

      if (authViewModel.isCheckingSession) {
        return isSplash ? null : AppRoutes.splash;
      }

      if (!canOpenApp) {
        return isLogin ? null : AppRoutes.login;
      }

      if (isAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      // -----------------------------------------------------------------------
      // RUTAS PRINCIPALES Y SISTEMA
      // -----------------------------------------------------------------------
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: AppRoutes.home, builder: (_, __) => const HomeScreen()),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.company,
        builder: (_, __) => const CompanyProfileScreen(),
      ),

      // -----------------------------------------------------------------------
      // CATÁLOGOS SIMPLES (Sus formularios se abren en BottomSheet imperativo)
      // -----------------------------------------------------------------------
      GoRoute(
        path: AppRoutes.sedes,
        builder: (_, __) => const SedeListScreen(),
      ),
      GoRoute(
        path: AppRoutes.lugaresOperativos,
        builder: (_, __) => const LugarOperativoListScreen(),
      ),
      GoRoute(
        path: AppRoutes.puestos,
        builder: (_, __) => const PuestoListScreen(),
      ),
      GoRoute(
        path: AppRoutes.frutas,
        builder: (_, __) => const FrutaListScreen(),
      ),
      GoRoute(
        path: AppRoutes.variedades,
        builder: (_, __) => const VariedadListScreen(),
      ),
      GoRoute(
        path: AppRoutes.calidades,
        builder: (_, __) => const CalidadListScreen(),
      ),
      GoRoute(
        path: AppRoutes.tiposJaba,
        builder: (_, __) => const TipoJabaListScreen(),
      ),
      GoRoute(
        path: AppRoutes.camiones,
        builder: (_, __) => const CamionListScreen(),
      ),

      // -----------------------------------------------------------------------
      // FLUJOS COMPLEJOS (El formulario es una Pantalla Completa con Subruta)
      // -----------------------------------------------------------------------
      GoRoute(
        path: AppRoutes.usuarios,
        builder: (_, __) => const UsuarioListScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.formSubRoute,
            builder: (context, state) => UsuariosFormScreen(
              // Corregido nombre de parámetro
              item: state.extra as Usuario?,
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.clientes,
        builder: (_, __) => const ClienteListScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.formSubRoute,
            builder: (context, state) =>
                ClienteFormScreen(item: state.extra as Cliente?),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Ruta no encontrada')),
      body: Center(
        child: Text(state.error?.toString() ?? 'No se encontró la pantalla.'),
      ),
    ),
  );
}
