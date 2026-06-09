import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/catalog/presentation/catalog_modules.dart';
import '../../features/catalog/presentation/pages/catalog_list_page.dart';
import '../../features/company/presentation/pages/company_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'app_routes.dart';

class AppRouter {
  const AppRouter._();

  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashPage()),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),
      GoRoute(path: AppRoutes.home, builder: (_, __) => const HomePage()),
      GoRoute(path: AppRoutes.settings, builder: (_, __) => const SettingsPage()),
      GoRoute(path: AppRoutes.company, builder: (_, __) => const CompanyPage()),
      GoRoute(path: AppRoutes.sedes, builder: (_, __) => CatalogListPage(module: CatalogModules.sedes)),
      GoRoute(path: AppRoutes.roles, builder: (_, __) => CatalogListPage(module: CatalogModules.roles)),
      GoRoute(path: AppRoutes.usuarios, builder: (_, __) => CatalogListPage(module: CatalogModules.usuarios)),
      GoRoute(path: AppRoutes.clientes, builder: (_, __) => CatalogListPage(module: CatalogModules.clientes)),
      GoRoute(path: AppRoutes.frutas, builder: (_, __) => CatalogListPage(module: CatalogModules.frutas)),
      GoRoute(path: AppRoutes.variedades, builder: (_, __) => CatalogListPage(module: CatalogModules.variedades)),
      GoRoute(path: AppRoutes.calidades, builder: (_, __) => CatalogListPage(module: CatalogModules.calidades)),
      GoRoute(path: AppRoutes.tiposJaba, builder: (_, __) => CatalogListPage(module: CatalogModules.tiposJaba)),
      GoRoute(path: AppRoutes.camiones, builder: (_, __) => CatalogListPage(module: CatalogModules.camiones)),
      GoRoute(path: AppRoutes.mercados, builder: (_, __) => CatalogListPage(module: CatalogModules.mercados)),
      GoRoute(path: AppRoutes.puestos, builder: (_, __) => CatalogListPage(module: CatalogModules.puestos)),
    ],
  );
}
