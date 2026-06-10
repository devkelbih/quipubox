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
            _DrawerHeader(
              topPadding: topPadding,
              avatarUrl: user?.avatarUrl,
              name: user?.fullName ?? 'Usuario',
              email: user?.email ?? '',
              role: user?.rolNombre ?? '-',
              company: user?.razonSocial ?? '-',
              site: user?.sedeNombre ?? '-',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                children: [
                  const SizedBox(height: 18),
                  const _SectionTitle('Administración'),
                  _Module(
                    icon: Icons.business_center_rounded,
                    title: 'Sedes y operaciones',
                    subtitle: 'Sedes, lugares operativos y puestos',
                    children: [
                      
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
                    icon: Icons.admin_panel_settings_rounded,
                    title: 'Usuarios y roles',
                    subtitle: 'Accesos, roles y permisos',
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
                  const SizedBox(height: 10),
                  const _SectionTitle('Catálogos'),
                  _Module(
                    icon: Icons.inventory_2_rounded,
                    title: 'Productos',
                    subtitle: 'Frutas, variedades, calidades y jabas',
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
                    icon: Icons.groups_2_rounded,
                    title: 'Clientes',
                    subtitle: 'Clientes, puestos y relación comercial',
                    children: [
                      _SubItem(
                        title: 'Clientes',
                        onTap: () => _open(context, AppRoutes.clientes),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _SectionTitle('Operaciones'),
                  _Module(
                    icon: Icons.local_shipping_rounded,
                    title: 'Carga y reparto',
                    subtitle: 'Carga, reparto, entregas y guías',
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
                    icon: Icons.assignment_return_rounded,
                    title: 'Control de jabas',
                    subtitle: 'Movimientos, retornos y saldos',
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
                  const SizedBox(height: 10),
                  const _SectionTitle('Seguimiento'),
                  _SimpleItem(
                    icon: Icons.photo_camera_rounded,
                    title: 'Evidencias',
                    onTap: () => _notAvailable(context),
                  ),
                  _SimpleItem(
                    icon: Icons.report_problem_rounded,
                    title: 'Incidencias',
                    onTap: () => _notAvailable(context),
                  ),
                  _SimpleItem(
                    icon: Icons.query_stats_rounded,
                    title: 'Reportes',
                    onTap: () => _notAvailable(context),
                  ),
                  _SimpleItem(
                    icon: Icons.settings_rounded,
                    title: 'Ajustes',
                    onTap: () => _open(context, AppRoutes.settings),
                  ),
                ],
              ),
            ),
            _DrawerFooter(
              isDarkMode: settings.isDarkMode,
              onToggleTheme: () =>
                  context.read<SettingsViewModel>().toggleDarkMode(),
              onLogout: () async {
                Navigator.of(context).pop();
                await context.read<AuthViewModel>().logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final double topPadding;
  final String? avatarUrl;
  final String name;
  final String email;
  final String role;
  final String company;
  final String site;

  const _DrawerHeader({
    required this.topPadding,
    required this.avatarUrl,
    required this.name,
    required this.email,
    required this.role,
    required this.company,
    required this.site,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18, topPadding + 18, 18, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2F4A), Color(0xFF155E95)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(34)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -28,
            top: -18,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: .08),
              ),
            ),
          ),
          Positioned(
            right: 28,
            bottom: -42,
            child: Container(
              width: 115,
              height: 115,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: .06),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .65),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white,
                      backgroundImage: avatarUrl?.isNotEmpty == true
                          ? NetworkImage(avatarUrl!)
                          : null,
                      child: avatarUrl?.isNotEmpty == true
                          ? null
                          : const Icon(
                              Icons.person_rounded,
                              size: 34,
                              color: Color(0xFF155E95),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: .82),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .14),
                  ),
                ),
                child: Column(
                  children: [
                    _HeaderInfo(
                      icon: Icons.business_rounded,
                      label: 'Empresa',
                      value: company,
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: _HeaderInfoCompact(
                            icon: Icons.badge_rounded,
                            label: 'Cargo',
                            value: role,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _HeaderInfoCompact(
                            icon: Icons.location_on_rounded,
                            label: 'Sede',
                            value: site,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderInfoCompact extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HeaderInfoCompact({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .65),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HeaderInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 9),
        Text(
          '$label:',
          style: TextStyle(
            color: Colors.white.withValues(alpha: .68),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
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
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 9),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 3,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: .9,
            ),
          ),
        ],
      ),
    );
  }
}

class _Module extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> children;

  const _Module({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: .85),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? .18 : .045,
            ),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(13, 8, 10, 8),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          leading: Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.8,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          children: children,
        ),
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
    final color = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Material(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: .45),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SimpleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SimpleItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(19),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(19),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .11),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 21),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerFooter extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;

  const _DrawerFooter({
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: Column(
          children: [
            Material(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: .55,
              ),
              borderRadius: BorderRadius.circular(18),
              child: SwitchListTile(
                value: isDarkMode,
                onChanged: (_) => onToggleTheme(),
                secondary: Icon(
                  isDarkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                ),
                title: const Text(
                  'Modo oscuro',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                dense: true,
              ),
            ),
            const SizedBox(height: 10),
            Material(
              color: const Color(0xFFFFEDEE),
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                onTap: onLogout,
                borderRadius: BorderRadius.circular(18),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded, color: Color(0xFFD32F2F)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Cerrar sesión',
                          style: TextStyle(
                            color: Color(0xFFD32F2F),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
