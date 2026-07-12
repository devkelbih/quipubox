import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../../../settings/presentation/viewmodels/settings_viewmodel.dart';
import '../../../../../core/navigation/app_routes.dart';
import '../../../../../core/ui/feedback/app_toast.dart';
import 'app_drawer_footer.dart';
import 'app_drawer_header.dart';
import 'app_drawer_tile.dart';
import 'app_drawer_subtile.dart';
import 'app_drawer_section.dart';
import 'drawer_metrics.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isNavigating = false;

  // =============================================================
  // Navegación
  // =============================================================

  Future<void> _navigateTo(String route) async {
    if (_isNavigating || !mounted) return;

    final currentRoute = GoRouterState.of(context).matchedLocation;

    if (currentRoute == route) {
      Navigator.of(context).pop();
      return;
    }

    _isNavigating = true;

    Navigator.of(context).pop();

    await Future<void>.delayed(const Duration(milliseconds: 180));

    if (!mounted) {
      _isNavigating = false;
      return;
    }

    try {
      if (mounted) {
        context.go(route);
      }
    } finally {
      if (mounted) {
        _isNavigating = false;
      }
    }
  }

  Future<void> _showNotAvailable() async {
    if (_isNavigating) return;

    if (!mounted) return;

    _isNavigating = true;
    Navigator.of(context).pop();
    AppToast.show('Módulo aún no disponible', type: ToastType.warning);

    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (mounted) {
      _isNavigating = false;
    }
  }

  Future<void> _logout() async {
    if (_isNavigating) return;

    if (!mounted) return;

    _isNavigating = true;
    Navigator.of(context).pop();
    await context.read<AuthViewModel>().logout();

    if (mounted) {
      _isNavigating = false;
    }
  }

  // =============================================================
  // Helpers para construir secciones
  // =============================================================

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      child: AppDrawerSection(title),
    );
  }

  AppDrawerSubTile _buildSubTile({
    required String title,
    required VoidCallback onTap,
    IconData? leadingIcon,
  }) {
    return AppDrawerSubTile(
      title: title,
      onTap: onTap,
      leadingIcon: leadingIcon,
    );
  }

  // =============================================================
  // Secciones del drawer
  // =============================================================

  Widget _buildOperacionesSection() {
    return Column(
      children: [
        _buildSection('Operaciones'),
        AppDrawerTile(
          icon: Icons.local_shipping_rounded,
          title: 'Operaciones',
          subtitle: 'Carga, reparto, entregas y guías',
          children: [
            _buildSubTile(title: 'Nueva carga', onTap: _showNotAvailable),
            _buildSubTile(
              title: 'Operaciones registradas',
              onTap: _showNotAvailable,
            ),
            _buildSubTile(
              title: 'Repartos y entregas',
              onTap: _showNotAvailable,
            ),
            _buildSubTile(title: 'Guías operativas', onTap: _showNotAvailable),
          ],
        ),
      ],
    );
  }

  Widget _buildRetornoSection() {
    return Column(
      children: [
        AppDrawerTile(
          icon: Icons.assignment_return_rounded,
          title: 'Retorno de jabas',
          subtitle: 'Control de retornos y saldos',
          children: [
            _buildSubTile(title: 'Estado de cuenta', onTap: _showNotAvailable),
            _buildSubTile(title: 'Recuperaciones', onTap: _showNotAvailable),
            _buildSubTile(title: 'Devoluciones', onTap: _showNotAvailable),
            _buildSubTile(title: 'Saldos pendientes', onTap: _showNotAvailable),
          ],
        ),
      ],
    );
  }

  Widget _buildClientesSection() {
    return Column(
      children: [
        _buildSection('Clientes'),
        AppDrawerTile(
          icon: Icons.groups_2_rounded,
          title: 'Clientes',
          subtitle: 'Clientes y relaciones comerciales',
          children: [
            _buildSubTile(
              title: 'Clientes',
              onTap: () => _navigateTo(AppRoutes.clientes),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCatalogosSection() {
    return Column(
      children: [
        _buildSection('Catálogos'),
        AppDrawerTile(
          icon: Icons.inventory_2_rounded,
          title: 'Productos',
          subtitle: 'Frutas, variedades, calidades y tipos de jaba',
          children: [
            _buildSubTile(
              title: 'Frutas',
              onTap: () => _navigateTo(AppRoutes.frutas),
            ),
            _buildSubTile(
              title: 'Variedades',
              onTap: () => _navigateTo(AppRoutes.variedades),
            ),
            _buildSubTile(
              title: 'Calidades',
              onTap: () => _navigateTo(AppRoutes.calidades),
            ),
            _buildSubTile(
              title: 'Tipos de jaba',
              onTap: () => _navigateTo(AppRoutes.tiposJaba),
            ),
          ],
        ),
        const SizedBox(height: 10),
        AppDrawerTile(
          icon: Icons.route_rounded,
          title: 'Logística',
          subtitle: 'Camiones, sedes y lugares operativos',
          children: [
            _buildSubTile(
              title: 'Camiones',
              onTap: () => _navigateTo(AppRoutes.camiones),
            ),
            _buildSubTile(
              title: 'Sedes',
              onTap: () => _navigateTo(AppRoutes.sedes),
            ),
            _buildSubTile(
              title: 'Lugares operativos',
              onTap: () => _navigateTo(AppRoutes.lugaresOperativos),
            ),
            _buildSubTile(
              title: 'Puestos',
              onTap: () => _navigateTo(AppRoutes.puestos),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdminSection() {
    return Column(
      children: [
        _buildSection('Administración'),
        AppDrawerTile(
          icon: Icons.admin_panel_settings_rounded,
          title: 'Usuarios y permisos',
          subtitle: 'Usuarios, roles y permisos',
          children: [
            _buildSubTile(
              title: 'Usuarios',
              onTap: () => _navigateTo(AppRoutes.usuarios),
            ),
            _buildSubTile(title: 'Permisos', onTap: _showNotAvailable),
          ],
        ),
      ],
    );
  }

  Widget _buildSeguimientoSection() {
    return Column(
      children: [
        _buildSection('Seguimiento'),
        AppDrawerTile(
          icon: Icons.photo_camera_rounded,
          title: 'Evidencias',
          onTap: _showNotAvailable,
        ),
        const SizedBox(height: 10),
        AppDrawerTile(
          icon: Icons.report_problem_rounded,
          title: 'Incidencias',
          onTap: _showNotAvailable,
        ),
        const SizedBox(height: 10),
        AppDrawerTile(
          icon: Icons.query_stats_rounded,
          title: 'Reportes',
          onTap: _showNotAvailable,
        ),
        const SizedBox(height: 10),
        AppDrawerTile(
          icon: Icons.settings_rounded,
          title: 'Ajustes',
          onTap: () => _navigateTo(AppRoutes.settings),
        ),
      ],
    );
  }

  // =============================================================
  // Build principal
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final settings = context.watch<SettingsViewModel>();
    final user = auth.user;
    final theme = Theme.of(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    return Drawer(
      width: MediaQuery.sizeOf(context).width * DrawerMetrics.widthFactor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(22)),
      ),
      child: ColoredBox(
        color: theme.colorScheme.surface,
        child: Column(
          children: [
            // Contenido
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: AppDrawerHeader(
                      topPadding: topPadding,
                      avatarUrl: user?.avatarUrl,
                      name: user?.shortName ?? 'Usuario',
                      role: user?.rolesSummary ?? '-',
                      site: user?.sede.nombre ?? '-',
                      onTap: _showNotAvailable,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DrawerMetrics.outerPadding,
                      vertical: 12,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          // Header

                          // Inicio
                          AppDrawerTile(
                            icon: Icons.dashboard_rounded,
                            title: 'Inicio',
                            onTap: () => _navigateTo(AppRoutes.home),
                          ),
                          const SizedBox(height: 8),
                          // Operaciones
                          _buildOperacionesSection(),
                          const SizedBox(height: 8),
                          // Retorno
                          _buildRetornoSection(),
                          const SizedBox(height: 8),
                          // Clientes
                          _buildClientesSection(),
                          const SizedBox(height: 8),
                          // Catálogos
                          _buildCatalogosSection(),
                          const SizedBox(height: 8),
                          // Administración
                          _buildAdminSection(),
                          const SizedBox(height: 8),
                          // Seguimiento
                          _buildSeguimientoSection(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Footer
            AppDrawerFooter(
              isDarkMode: settings.isEffectiveDarkMode(context),
              onToggleTheme: () =>
                  context.read<SettingsViewModel>().toggleDarkMode(context),
              onLogout: _logout,
              isSigningOut: auth.isSigningOut,
            ),
          ],
        ),
      ),
    );
  }
}
