import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../../features/settings/presentation/viewmodels/settings_viewmodel.dart';
import '../../navigation/app_routes.dart';
import '../app_toast.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _open(BuildContext context, String route) {
    Navigator.of(context).pop();

    final currentRoute = GoRouterState.of(context).matchedLocation;
    if (currentRoute == route) return;

    if (route == AppRoutes.home) {
      context.go(AppRoutes.home);
      return;
    }

    context.push(route);
  }

  void _notAvailable(BuildContext context) {
    Navigator.of(context).pop();
    AppToast.show('Módulo aún no disponible', type: ToastType.warning);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final user = auth.user;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF123C69), Color(0xFF1E5AA8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white,
                        backgroundImage: user?.avatarUrl?.isNotEmpty == true
                            ? NetworkImage(user!.avatarUrl!)
                            : null,
                        child: user?.avatarUrl?.isNotEmpty == true
                            ? null
                            : const Icon(
                                Icons.person_rounded,
                                size: 36,
                                color: Color(0xFF1E5AA8),
                              ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.fullName ?? 'Usuario',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: .82),
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        _ProfileInfo(
                          icon: Icons.badge_outlined,
                          label: 'Cargo',
                          value: user?.rolNombre ?? '-',
                        ),
                        const SizedBox(height: 10),
                        _ProfileInfo(
                          icon: Icons.business_outlined,
                          label: 'Empresa',
                          value: user?.empresaNombre ?? '-',
                        ),
                        const SizedBox(height: 10),
                        _ProfileInfo(
                          icon: Icons.location_on_outlined,
                          label: 'Sede',
                          value: user?.sedeNombre ?? '-',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
                children: [
                  /*const _SectionTitle('Principal'),
                  _Item(
                    icon: Icons.dashboard_rounded,
                    title: 'Dashboard',
                    onTap: () => _open(context, AppRoutes.home),
                  ),*/
                  const SizedBox(height: 12),
                  const _SectionTitle('Administración'),
                  _Module(
                    icon: Icons.business_rounded,
                    title: 'Empresas y sedes',
                    children: [
                      _SubItem(
                        title: 'Empresa actual',
                        onTap: () => _open(context, AppRoutes.company),
                      ),
                      _SubItem(
                        title: 'Sedes',
                        onTap: () => _open(context, AppRoutes.sedes),
                      ),
                      _SubItem(
                        title: 'Lugares operativos',
                        onTap: () =>
                            _open(context, AppRoutes.lugaresOperativos),
                      ),
                      _SubItem(
                        title: 'Puestos',
                        onTap: () => _open(context, AppRoutes.puestos),
                      ),
                    ],
                  ),
                  _Module(
                    icon: Icons.people_alt_rounded,
                    title: 'Usuarios y roles',
                    children: [
                      _SubItem(
                        title: 'Usuarios',
                        onTap: () => _open(context, AppRoutes.usuarios),
                      ),
                      _SubItem(
                        title: 'Roles',
                        onTap: () => _open(context, AppRoutes.roles),
                      ),
                      _SubItem(
                        title: 'Permisos',
                        onTap: () => _notAvailable(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _SectionTitle('Catálogos'),
                  _Module(
                    icon: Icons.category_rounded,
                    title: 'Productos',
                    children: [
                      _SubItem(
                        title: 'Frutas',
                        onTap: () => _open(context, AppRoutes.frutas),
                      ),
                      _SubItem(
                        title: 'Variedades',
                        onTap: () => _open(context, AppRoutes.variedades),
                      ),
                      _SubItem(
                        title: 'Calidades',
                        onTap: () => _open(context, AppRoutes.calidades),
                      ),
                      _SubItem(
                        title: 'Tipos de jaba',
                        onTap: () => _open(context, AppRoutes.tiposJaba),
                      ),
                      _SubItem(
                        title: 'Camiones',
                        onTap: () => _open(context, AppRoutes.camiones),
                      ),
                    ],
                  ),
                  _Module(
                    icon: Icons.groups_rounded,
                    title: 'Clientes',
                    children: [
                      _SubItem(
                        title: 'Clientes',
                        onTap: () => _open(context, AppRoutes.clientes),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _SectionTitle('Operaciones'),
                  _Module(
                    icon: Icons.local_shipping_rounded,
                    title: 'Carga y reparto',
                    children: [
                      _SubItem(
                        title: 'Nueva carga',
                        onTap: () => _notAvailable(context),
                      ),
                      _SubItem(
                        title: 'Cargas registradas',
                        onTap: () => _notAvailable(context),
                      ),
                      _SubItem(
                        title: 'Reparto y entregas',
                        onTap: () => _notAvailable(context),
                      ),
                    ],
                  ),
                  _Module(
                    icon: Icons.inventory_2_rounded,
                    title: 'Control de jabas',
                    children: [
                      _SubItem(
                        title: 'Movimientos',
                        onTap: () => _notAvailable(context),
                      ),
                      _SubItem(
                        title: 'Retornos pendientes',
                        onTap: () => _notAvailable(context),
                      ),
                      _SubItem(
                        title: 'Saldos por cliente',
                        onTap: () => _notAvailable(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _SectionTitle('Seguimiento'),
                  _Item(
                    icon: Icons.photo_camera_rounded,
                    title: 'Evidencias',
                    onTap: () => _notAvailable(context),
                  ),
                  const SizedBox(height: 8),
                  _Item(
                    icon: Icons.warning_amber_rounded,
                    title: 'Incidencias',
                    onTap: () => _notAvailable(context),
                  ),
                  const SizedBox(height: 8),
                  _Item(
                    icon: Icons.bar_chart_rounded,
                    title: 'Reportes',
                    onTap: () => _notAvailable(context),
                  ),
                  const SizedBox(height: 8),
                  _Item(
                    icon: Icons.settings_rounded,
                    title: 'Ajustes',
                    onTap: () => _open(context, AppRoutes.settings),
                  ),
                ],
              ),
            ),
            SwitchListTile(
              value: context.watch<SettingsViewModel>().isDarkMode,
              onChanged: (_) =>
                  context.read<SettingsViewModel>().toggleDarkMode(),
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text(
                'Modo oscuro',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 14),
              child: Material(
                color: const Color(0xFFFFEDEE),
                borderRadius: BorderRadius.circular(16),
                child: ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFD32F2F),
                  ),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      color: Color(0xFFD32F2F),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final authViewModel = context.read<AuthViewModel>();
                    await authViewModel.logout();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: TextStyle(
            color: Colors.white.withValues(alpha: .72),
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: .8,
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _Item({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}

class _Module extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _Module({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        children: children,
      ),
    );
  }
}

class _SubItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SubItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: .55),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
