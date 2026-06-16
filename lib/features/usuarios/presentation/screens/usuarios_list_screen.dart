import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/ui/app_toast.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';
import '../../../../core/ui/widgets/empty_state.dart';
import '../../domain/entities/usuario.dart';
import '../viewmodels/usuarios_viewmodel.dart';
import 'usuarios_form_screen.dart';

class UsuarioListScreen extends StatefulWidget {
  const UsuarioListScreen({super.key});

  @override
  State<UsuarioListScreen> createState() => _UsuarioListScreenState();
}

class _UsuarioListScreenState extends State<UsuarioListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<UsuarioViewModel>().load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UsuarioViewModel>();

    return AppScaffold(
      title: 'Usuarios',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Nuevo'),
      ),
      body: Column(
        children: [
          if (vm.isSaving || vm.isDeleting) const LinearProgressIndicator(),
          Expanded(
            child: Builder(
              builder: (_) {
                if (vm.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (vm.errorMessage != null && vm.items.isEmpty) {
                  return EmptyState(vm.errorMessage!);
                }

                if (vm.items.isEmpty) {
                  return const EmptyState('No hay usuarios registrados.');
                }

                return RefreshIndicator(
                  onRefresh: vm.load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                    children: [
                      _UsuariosHeader(total: vm.items.length),
                      const SizedBox(height: 16),
                      ...vm.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _UsuarioCard(
                            item: item,
                            onEdit: () => _openForm(context, item: item),
                            onDeactivate: () => _deactivate(context, item),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deactivate(BuildContext context, Usuario item) async {
    final viewModel = context.read<UsuarioViewModel>();
    final ok = await viewModel.remove(item.id);

    if (!context.mounted) return;

    AppToast.show(
      ok
          ? 'Usuario desactivado correctamente.'
          : viewModel.errorMessage ?? 'No se pudo desactivar.',
      type: ok ? ToastType.success : ToastType.error,
    );
  }

  Future<void> _openForm(BuildContext context, {Usuario? item}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<UsuarioViewModel>(),
        child: UsuarioFormScreen(item: item),
      ),
    );
  }
}

class _UsuariosHeader extends StatelessWidget {
  final int total;

  const _UsuariosHeader({required this.total});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.45),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colorScheme.primary.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.groups_rounded, color: colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$total usuarios registrados',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Administra accesos, sedes y roles del sistema.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UsuarioCard extends StatelessWidget {
  final Usuario item;
  final VoidCallback onEdit;
  final VoidCallback onDeactivate;

  const _UsuarioCard({
    required this.item,
    required this.onEdit,
    required this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final nombre = item.nombreCompleto.isNotEmpty
        ? item.nombreCompleto
        : 'Usuario #${item.id}';

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.7)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _UserAvatar(item: item),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          nombre,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      _StatusChip(active: item.estado),
                    ],
                  ),
                  const SizedBox(height: 8),

                  _InfoLine(icon: Icons.email_outlined, text: item.email),

                  if (item.telefono != null && item.telefono!.trim().isNotEmpty)
                    _InfoLine(icon: Icons.phone_outlined, text: item.telefono!),

                  _InfoLine(
                    icon: Icons.business_outlined,
                    text: item.empresa.nombreComercial.trim().isNotEmpty
                        ? item.empresa.nombreComercial
                        : item.empresa.razonSocial,
                  ),

                  _InfoLine(
                    icon: Icons.store_mall_directory_outlined,
                    text: _sedeText(item),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...item.roles.map(
                        (rol) => _SoftChip(
                          icon: Icons.admin_panel_settings_outlined,
                          label: _formatRoleName(rol.nombre),
                        ),
                      ),
                      if (item.roles.isEmpty)
                        const _SoftChip(
                          icon: Icons.warning_amber_rounded,
                          label: 'Sin rol',
                        ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              tooltip: 'Opciones',
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'deactivate') onDeactivate();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'edit', child: Text('Editar')),
                PopupMenuItem(
                  value: 'deactivate',
                  enabled: item.estado,
                  child: const Text('Desactivar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _sedeText(Usuario item) {
    final parts = <String>[
      item.sede.nombre,
      if (item.sede.ciudad != null && item.sede.ciudad!.trim().isNotEmpty)
        item.sede.ciudad!,
    ];

    return parts.join(' · ');
  }

  String _formatRoleName(String value) {
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .where((e) => e.trim().isNotEmpty)
        .map((e) => e[0].toUpperCase() + e.substring(1).toLowerCase())
        .join(' ');
  }
}

class _UserAvatar extends StatelessWidget {
  final Usuario item;

  const _UserAvatar({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final avatarUrl = item.avatarUrl;

    if (avatarUrl != null && avatarUrl.trim().isNotEmpty) {
      return CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(avatarUrl),
        backgroundColor: colorScheme.surfaceContainerHighest,
      );
    }

    return CircleAvatar(
      radius: 25,
      backgroundColor: item.estado
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest,
      child: Text(
        _initials(item),
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: item.estado
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  String _initials(Usuario item) {
    final n = item.nombres.trim().isNotEmpty ? item.nombres.trim()[0] : '';
    final a = item.apellidos.trim().isNotEmpty ? item.apellidos.trim()[0] : '';
    final result = '$n$a'.toUpperCase();

    return result.isEmpty ? 'U' : result;
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool active;

  const _StatusChip({required this.active});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: active
            ? colorScheme.primaryContainer
            : colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        active ? 'Activo' : 'Inactivo',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: active
              ? colorScheme.onPrimaryContainer
              : colorScheme.onErrorContainer,
        ),
      ),
    );
  }
}

class _SoftChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SoftChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
