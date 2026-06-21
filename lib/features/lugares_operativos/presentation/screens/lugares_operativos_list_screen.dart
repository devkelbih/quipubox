import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/ui/feedback/app_toast.dart';
import '../../../app_shell/presentation/widgets/app_scaffold.dart';
import '../../../../core/ui/states/empty_state.dart';
import '../../domain/constants/lugar_operativo_tipos.dart';
import '../../domain/entities/lugar_operativo.dart';
import '../viewmodels/lugares_operativos_viewmodel.dart';
import 'lugares_operativos_form_screen.dart';

class LugarOperativoListScreen extends StatefulWidget {
  const LugarOperativoListScreen({super.key});

  @override
  State<LugarOperativoListScreen> createState() =>
      _LugarOperativoListScreenState();
}

class _LugarOperativoListScreenState extends State<LugarOperativoListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<LugarOperativoViewModel>().load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LugarOperativoViewModel>();

    return AppScaffold(
      title: 'Lugares operativos',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add_location_alt_rounded),
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
                  return const EmptyState('No hay lugares operativos.');
                }

                return RefreshIndicator(
                  onRefresh: vm.load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                    children: [
                      _LugaresHeader(
                        total: vm.total,
                        activos: vm.activos,
                      ),
                      const SizedBox(height: 16),
                      ...vm.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _LugarCard(
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

  Future<void> _deactivate(BuildContext context, LugarOperativo item) async {
    final vm = context.read<LugarOperativoViewModel>();
    final ok = await vm.remove(item.id);

    if (!context.mounted) return;

    AppToast.show(
      ok
          ? 'Lugar operativo desactivado correctamente.'
          : vm.errorMessage ?? 'No se pudo desactivar.',
      type: ok ? ToastType.success : ToastType.error,
    );
  }

  Future<void> _openForm(
    BuildContext context, {
    LugarOperativo? item,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<LugarOperativoViewModel>(),
        child: LugarOperativoFormScreen(item: item),
      ),
    );
  }
}

class _LugaresHeader extends StatelessWidget {
  final int total;
  final int activos;

  const _LugaresHeader({
    required this.total,
    required this.activos,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.45),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.12),
        ),
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
            child: Icon(
              Icons.location_city_rounded,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$total lugares operativos',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$activos activos registrados por sede.',
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

class _LugarCard extends StatelessWidget {
  final LugarOperativo item;
  final VoidCallback onEdit;
  final VoidCallback onDeactivate;

  const _LugarCard({
    required this.item,
    required this.onEdit,
    required this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.7),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LugarIcon(tipoLugar: item.tipoLugar),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.nombre,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      _StatusChip(active: item.estado),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _InfoLine(
                    icon: Icons.category_outlined,
                    text: LugarOperativoTipos.label(item.tipoLugar),
                  ),
                  _InfoLine(
                    icon: Icons.store_mall_directory_outlined,
                    text: _sedeText(item),
                  ),
                  if (item.direccionReferencia != null)
                    _InfoLine(
                      icon: Icons.place_outlined,
                      text: item.direccionReferencia!,
                    ),
                  if (item.observaciones != null)
                    _InfoLine(
                      icon: Icons.notes_outlined,
                      text: item.observaciones!,
                    ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SoftChip(
                        icon: Icons.business_outlined,
                        label:
                            item.empresa?.nombreComercial ??
                            'Empresa #${item.idEmpresa}',
                      ),
                      _SoftChip(
                        icon: Icons.flag_outlined,
                        label: item.sede.tipoSede ?? 'Sede',
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
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Editar'),
                ),
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

  String _sedeText(LugarOperativo item) {
    final parts = <String>[
      item.sede.nombre,
      if (item.sede.ciudad != null) item.sede.ciudad!,
      if (item.sede.departamento != null) item.sede.departamento!,
    ];

    return parts.join(' · ');
  }
}

class _LugarIcon extends StatelessWidget {
  final String tipoLugar;

  const _LugarIcon({required this.tipoLugar});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    IconData icon;

    switch (tipoLugar) {
      case LugarOperativoTipos.mercado:
        icon = Icons.storefront_rounded;
        break;
      case LugarOperativoTipos.almacen:
        icon = Icons.warehouse_rounded;
        break;
      case LugarOperativoTipos.calle:
        icon = Icons.signpost_rounded;
        break;
      case LugarOperativoTipos.rampa:
        icon = Icons.local_shipping_rounded;
        break;
      case LugarOperativoTipos.pasaje:
        icon = Icons.alt_route_rounded;
        break;
      default:
        icon = Icons.place_rounded;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        icon,
        color: colorScheme.onPrimaryContainer,
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
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

  const _SoftChip({
    required this.icon,
    required this.label,
  });

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
          Icon(
            icon,
            size: 15,
            color: colorScheme.onSurfaceVariant,
          ),
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