import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/company/presentation/screens/company_profile_screen.dart';
import '../../features/roles/presentation/screens/roles_list_screen.dart';
import '../../features/sedes/presentation/screens/sedes_list_screen.dart';
import '../../features/usuarios/presentation/screens/usuarios_list_screen.dart';
import '../../features/clientes/presentation/screens/clientes_list_screen.dart';
import '../../features/lugares_operativos/presentation/screens/lugares_operativos_list_screen.dart';
import '../../features/puestos/presentation/screens/puestos_list_screen.dart';
import '../../features/frutas/presentation/screens/frutas_list_screen.dart';
import '../../features/variedades/presentation/screens/variedades_list_screen.dart';
import '../../features/calidades/presentation/screens/calidades_list_screen.dart';
import '../../features/tipos_jaba/presentation/screens/tipos_jaba_list_screen.dart';
import '../../features/camiones/presentation/screens/camiones_list_screen.dart';
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

      if (authViewModel.isLoading) {
        return null;
      }

      final isLogin = location == AppRoutes.login;
      final isSplash = location == AppRoutes.splash;
      final isAuthRoute = isLogin || isSplash;

      if (!authViewModel.isAuthenticated) {
        return isLogin ? null : AppRoutes.login;
      }

      if (isAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashPage()),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),
      GoRoute(path: AppRoutes.home, builder: (_, __) => const HomePage()),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, __) => const SettingsPage(),
      ),
      //TODO: company screen debe verse en el setting, de la cuenta, no en el menu principal, revisar esto luego
      GoRoute(
        path: AppRoutes.company,
        builder: (_, __) => const CompanyProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.roles,
        builder: (_, __) => const RolesListScreen(),
      ),
      GoRoute(
        path: AppRoutes.sedes,
        builder: (_, __) => const SedeListScreen(),
      ),
      GoRoute(
        path: AppRoutes.usuarios,
        builder: (_, __) => const UsuarioListScreen(),
      ),
      GoRoute(
        path: AppRoutes.clientes,
        builder: (_, __) => const ClienteListScreen(),
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
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Ruta no encontrada')),
      body: Center(
        child: Text(state.error?.toString() ?? 'No se encontró la pantalla.'),
      ),
    ),
  );
}
