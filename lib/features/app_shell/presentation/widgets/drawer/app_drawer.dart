import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../../../settings/presentation/viewmodels/settings_viewmodel.dart';
import '../../../../../core/navigation/app_routes.dart';
import '../../../../../core/ui/feedback/app_toast.dart';
import 'app_drawer_footer.dart';
import 'app_drawer_header.dart';
import 'app_drawer_items.dart';
import 'app_drawer_module.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isNavigating = false;
  Future<void> _open(BuildContext context, String route) async {
    if (_isNavigating) return;

    final currentRoute = GoRouterState.of(context).matchedLocation;

    _isNavigating = true;

    Navigator.of(context).pop();

    await Future<void>.delayed(const Duration(milliseconds: 180));

    if (!context.mounted) return;

    if (currentRoute != route) {
      context.go(route);
    }

    if (mounted) {
      _isNavigating = false;
    }
  }

  void _notAvailable(BuildContext context) {
    if (_isNavigating) return;

    _isNavigating = true;

    Navigator.of(context).pop();
    AppToast.show('Módulo aún no disponible', type: ToastType.warning);

    Future<void>.delayed(const Duration(milliseconds: 250), () {
      if (mounted) _isNavigating = false;
    });
  }

  Future<void> _logout(BuildContext context) async {
    if (_isNavigating) return;

    _isNavigating = true;

    Navigator.of(context).pop();
    await context.read<AuthViewModel>().logout();

    if (mounted) {
      _isNavigating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final settings = context.watch<SettingsViewModel>();
    final user = auth.user;
    final theme = Theme.of(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    return Drawer(
      width: MediaQuery.sizeOf(context).width * .86,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
      ),
      child: ColoredBox(
        color: theme.colorScheme.surface,
        child: Column(
          children: [
            AppDrawerHeader(
              topPadding: topPadding,
              avatarUrl: user?.avatarUrl,
              name: user?.fullName ?? 'Usuario',
              email: user?.email ?? '',
              role: user?.roleNames.join(', ') ?? '-',
              company: user?.empresa.razonSocial ?? '-',
              site: user?.sede.nombre ?? '-',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                children: [
                  const SizedBox(height: 18),
                  AppDrawerSimpleItem(
                    icon: Icons.dashboard_rounded,
                    title: 'Inicio',
                    onTap: () => _open(context, AppRoutes.home),
                  ),
                  const SizedBox(height: 18),
                  const AppDrawerSectionTitle('Administración'),
                  AppDrawerModule(
                    icon: Icons.business_center_rounded,
                    title: 'Sedes y operaciones',
                    subtitle: 'Sedes, lugares operativos y puestos',
                    children: [
                      AppDrawerSubItem(
                        title: 'Sedes',
                        onTap: () => _open(context, AppRoutes.sedes),
                      ),
                      AppDrawerSubItem(
                        title: 'Lugares operativos',
                        onTap: () =>
                            _open(context, AppRoutes.lugaresOperativos),
                      ),
                      AppDrawerSubItem(
                        title: 'Puestos',
                        onTap: () => _open(context, AppRoutes.puestos),
                      ),
                    ],
                  ),
                  AppDrawerModule(
                    icon: Icons.admin_panel_settings_rounded,
                    title: 'Usuarios y roles',
                    subtitle: 'Accesos, roles y permisos',
                    children: [
                      AppDrawerSubItem(
                        title: 'Usuarios',
                        onTap: () => _open(context, AppRoutes.usuarios),
                      ),
                      AppDrawerSubItem(
                        title: 'Roles',
                        onTap: () => _open(context, AppRoutes.roles),
                      ),
                      AppDrawerSubItem(
                        title: 'Permisos',
                        onTap: () => _notAvailable(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const AppDrawerSectionTitle('Catálogos'),
                  AppDrawerModule(
                    icon: Icons.inventory_2_rounded,
                    title: 'Productos',
                    subtitle: 'Frutas, variedades, calidades y jabas',
                    children: [
                      AppDrawerSubItem(
                        title: 'Frutas',
                        onTap: () => _open(context, AppRoutes.frutas),
                      ),
                      AppDrawerSubItem(
                        title: 'Variedades',
                        onTap: () => _open(context, AppRoutes.variedades),
                      ),
                      AppDrawerSubItem(
                        title: 'Calidades',
                        onTap: () => _open(context, AppRoutes.calidades),
                      ),
                      AppDrawerSubItem(
                        title: 'Tipos de jaba',
                        onTap: () => _open(context, AppRoutes.tiposJaba),
                      ),
                      AppDrawerSubItem(
                        title: 'Camiones',
                        onTap: () => _open(context, AppRoutes.camiones),
                      ),
                    ],
                  ),
                  AppDrawerModule(
                    icon: Icons.groups_2_rounded,
                    title: 'Clientes',
                    subtitle: 'Clientes, puestos y relación comercial',
                    children: [
                      AppDrawerSubItem(
                        title: 'Clientes',
                        onTap: () => _open(context, AppRoutes.clientes),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const AppDrawerSectionTitle('Operaciones'),
                  AppDrawerModule(
                    icon: Icons.local_shipping_rounded,
                    title: 'Carga y reparto',
                    subtitle: 'Carga, reparto, entregas y guías',
                    children: [
                      AppDrawerSubItem(
                        title: 'Nueva carga',
                        onTap: () => _notAvailable(context),
                      ),
                      AppDrawerSubItem(
                        title: 'Cargas registradas',
                        onTap: () => _notAvailable(context),
                      ),
                      AppDrawerSubItem(
                        title: 'Reparto y entregas',
                        onTap: () => _notAvailable(context),
                      ),
                    ],
                  ),
                  AppDrawerModule(
                    icon: Icons.assignment_return_rounded,
                    title: 'Control de jabas',
                    subtitle: 'Movimientos, retornos y saldos',
                    children: [
                      AppDrawerSubItem(
                        title: 'Movimientos',
                        onTap: () => _notAvailable(context),
                      ),
                      AppDrawerSubItem(
                        title: 'Retornos pendientes',
                        onTap: () => _notAvailable(context),
                      ),
                      AppDrawerSubItem(
                        title: 'Saldos por cliente',
                        onTap: () => _notAvailable(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const AppDrawerSectionTitle('Seguimiento'),
                  AppDrawerSimpleItem(
                    icon: Icons.photo_camera_rounded,
                    title: 'Evidencias',
                    onTap: () => _notAvailable(context),
                  ),
                  AppDrawerSimpleItem(
                    icon: Icons.report_problem_rounded,
                    title: 'Incidencias',
                    onTap: () => _notAvailable(context),
                  ),
                  AppDrawerSimpleItem(
                    icon: Icons.query_stats_rounded,
                    title: 'Reportes',
                    onTap: () => _notAvailable(context),
                  ),
                  AppDrawerSimpleItem(
                    icon: Icons.settings_rounded,
                    title: 'Ajustes',
                    onTap: () => _open(context, AppRoutes.settings),
                  ),
                ],
              ),
            ),
            AppDrawerFooter(
              isDarkMode: settings.isEffectiveDarkMode(context),
              onToggleTheme: () =>
                  context.read<SettingsViewModel>().toggleDarkMode(context),
              onLogout: () => _logout(context),
              isSigningOut: auth.isSigningOut,
            ),
          ],
        ),
      ),
    );
  }
}
