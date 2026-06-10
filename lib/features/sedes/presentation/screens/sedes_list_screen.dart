import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/ui/app_toast.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';
import '../../../../core/ui/widgets/empty_state.dart';
import '../../domain/entities/sede.dart';
import '../../domain/enums/tipo_sede.dart';
import '../viewmodels/sedes_viewmodel.dart';
import 'sedes_form_screen.dart';

class SedeListScreen extends StatefulWidget {
  const SedeListScreen({super.key});

  @override
  State<SedeListScreen> createState() => _SedeListScreenState();
}

class _SedeListScreenState extends State<SedeListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<SedeViewModel>().load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SedeViewModel>();

    return AppScaffold(
      title: 'Sedes',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva sede'),
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
                  return const EmptyState('Aún no tienes sedes registradas.');
                }

                return RefreshIndicator(
                  onRefresh: vm.load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    children: [
                      _SedeSummary(items: vm.items),
                      const SizedBox(height: 14),
                      ...vm.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _SedeCard(
                            item: item,
                            onEdit: () => _openForm(context, item: item),
                            onDeactivate: () =>
                                _confirmDeactivate(context, item),
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

  Future<void> _openForm(BuildContext context, {Sede? item}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ChangeNotifierProvider.value(
          value: context.read<SedeViewModel>(),
          child: _FormSheet(
            title: item == null ? 'Nueva sede' : 'Editar sede',
            child: SedeFormScreen(item: item),
          ),
        );
      },
    );
  }

  Future<void> _confirmDeactivate(BuildContext context, Sede item) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (_) => _DeactivateSheet(item: item),
    );

    if (confirmed != true || !context.mounted) return;

    final viewModel = context.read<SedeViewModel>();
    final ok = await viewModel.remove(item.id);

    if (!context.mounted) return;

    AppToast.show(
      ok
          ? 'Sede desactivada correctamente.'
          : viewModel.errorMessage ?? 'No se pudo desactivar.',
      type: ok ? ToastType.success : ToastType.error,
    );
  }
}

class _SedeSummary extends StatelessWidget {
  final List<Sede> items;

  const _SedeSummary({required this.items});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final active = items.where((e) => e.estado).length;
    final inactive = items.length - active;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.50),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          _SummaryItem(
            value: items.length.toString(),
            label: 'Total',
            icon: Icons.apartment_rounded,
          ),
          const _SummaryDivider(),
          _SummaryItem(
            value: active.toString(),
            label: 'Activas',
            icon: Icons.check_circle_rounded,
          ),
          const _SummaryDivider(),
          _SummaryItem(
            value: inactive.toString(),
            label: 'Inactivas',
            icon: Icons.block_rounded,
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _SummaryItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(label),
        ],
      ),
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 48,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

class _SedeCard extends StatelessWidget {
  final Sede item;
  final VoidCallback onEdit;
  final VoidCallback onDeactivate;

  const _SedeCard({
    required this.item,
    required this.onEdit,
    required this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final location = _locationText(item);

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: item.estado
                        ? colorScheme.primaryContainer
                        : colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    _iconByType(item.tipoSede),
                    color: item.estado
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onErrorContainer,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.nombre.isEmpty
                                  ? 'Sede #${item.id}'
                                  : item.nombre,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          _StatusBadge(active: item.estado),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.tipoSede.label,
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (location != null)
              _InfoRow(
                icon: Icons.map_rounded,
                label: 'Ubicación',
                value: location,
              ),
            if (_hasText(item.direccion)) ...[
              const SizedBox(height: 10),
              _InfoRow(
                icon: Icons.place_rounded,
                label: 'Dirección',
                value: item.direccion!,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('Editar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: item.estado ? onDeactivate : null,
                    icon: const Icon(Icons.block_rounded),
                    label: const Text('Desactivar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String? _locationText(Sede item) {
    final ciudad = item.ciudad?.trim();
    final departamento = item.departamento?.trim();

    if (_hasText(ciudad) && _hasText(departamento)) {
      if (ciudad!.toLowerCase() == departamento!.toLowerCase()) {
        return ciudad;
      }
      return '$ciudad, $departamento';
    }

    if (_hasText(ciudad)) return ciudad;
    if (_hasText(departamento)) return departamento;

    return null;
  }

  static IconData _iconByType(TipoSede value) {
    switch (value) {
      case TipoSede.origen:
        return Icons.upload_rounded;
      case TipoSede.destino:
        return Icons.download_rounded;
      case TipoSede.ambos:
        return Icons.sync_alt_rounded;
    }
  }

  static bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}

class _StatusBadge extends StatelessWidget {
  final bool active;

  const _StatusBadge({required this.active});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: active
            ? colorScheme.primaryContainer
            : colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        active ? 'Activo' : 'Inactivo',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: active
              ? colorScheme.onPrimaryContainer
              : colorScheme.onErrorContainer,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FormSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const _FormSheet({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottom),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.94,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeactivateSheet extends StatelessWidget {
  final Sede item;

  const _DeactivateSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: colorScheme.errorContainer,
              child: Icon(
                Icons.block_rounded,
                color: colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Desactivar sede',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'La sede "${item.nombre}" dejará de estar disponible para nuevas operaciones.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Desactivar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}