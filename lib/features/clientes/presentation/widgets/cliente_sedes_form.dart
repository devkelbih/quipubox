import 'package:flutter/material.dart';

import 'package:quipubox/core/ui/sheets/app_bottom_sheet.dart';
import 'package:quipubox/features/clientes/domain/enums/tipos_relacion_cliente_sedes.dart';
import 'package:quipubox/features/sedes/domain/entities/sede.dart';

class ClienteSedesForm extends StatelessWidget {
  final List<Sede> sedes;
  final Map<int, TipoRelacionClienteSede> selectedSedes;
  final ValueChanged<Map<int, TipoRelacionClienteSede>> onChanged;
  final bool hasError;

  const ClienteSedesForm({
    super.key,
    required this.sedes,
    required this.selectedSedes,
    required this.onChanged,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final sedesActivas = sedes
        .where((sede) => sede.estado && sede.id != null)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sedes del cliente',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 8),

        Text(
          'Selecciona las sedes donde opera el cliente e indica '
          'el tipo de relación que mantiene con cada una.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 24),

        if (sedesActivas.isEmpty)
          Text(
            'No hay sedes activas disponibles.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          )
        else ...[
          for (final sede in sedesActivas) _buildSedeTile(context, sede),

          if (hasError) ...[
            const SizedBox(height: 8),
            Text(
              'Selecciona al menos una sede.',
              style: TextStyle(color: colorScheme.error, fontSize: 12),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildSedeTile(BuildContext context, Sede sede) {
    final colorScheme = Theme.of(context).colorScheme;
    final sedeId = sede.id!;

    final isSelected = selectedSedes.containsKey(sedeId);
    final relation = selectedSedes[sedeId];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primaryContainer.withValues(alpha: 0.35)
            : colorScheme.surface,
        border: Border.all(
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectRelation(context, sede),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
            child: Row(
              children: [
                _buildSelectionIndicator(context, isSelected),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sede.nombre,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),

                      if (relation != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          _relationLabel(relation),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),

                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(BuildContext context, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? colorScheme.primary : colorScheme.outline,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: isSelected
          ? Icon(Icons.check_rounded, size: 16, color: colorScheme.onPrimary)
          : null,
    );
  }

  Future<void> _selectRelation(BuildContext context, Sede sede) async {
    final sedeId = sede.id!;
    final isSelected = selectedSedes.containsKey(sedeId);

    final result = await AppBottomSheet.show<_SedeAction>(
      context: context,
      title: sede.nombre,
      initialChildSize: isSelected ? 0.48 : 0.38,
      minChildSize: isSelected ? 0.40 : 0.30,
      maxChildSize: isSelected ? 0.58 : 0.48,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(
              'Tipo de relación',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            Text(
              'Indica cómo se relaciona el cliente con esta sede.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 16),

            for (final relation in TipoRelacionClienteSede.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_relationLabel(relation)),
                trailing: selectedSedes[sedeId] == relation
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () {
                  Navigator.of(context).pop(_SedeAction.relation(relation));
                },
              ),

            if (isSelected) ...[
              const Divider(height: 24),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.remove_circle_outline_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Quitar esta sede',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop(const _SedeAction.remove());
                },
              ),
            ],
          ],
        );
      },
    );

    if (result == null || !context.mounted) {
      return;
    }

    final updated = Map<int, TipoRelacionClienteSede>.from(selectedSedes);

    if (result.isRemove) {
      updated.remove(sedeId);
    } else {
      updated[sedeId] = result.relation!;
    }

    onChanged(updated);
  }

  String _relationLabel(TipoRelacionClienteSede relation) {
    switch (relation) {
      case TipoRelacionClienteSede.emisor:
        return 'Emisor';

      case TipoRelacionClienteSede.receptor:
        return 'Receptor';

      case TipoRelacionClienteSede.ambos:
        return 'Emisor y receptor';
    }
  }
}

class _SedeAction {
  final TipoRelacionClienteSede? relation;
  final bool isRemove;

  const _SedeAction._({this.relation, required this.isRemove});

  const _SedeAction.relation(TipoRelacionClienteSede relation)
    : this._(relation: relation, isRemove: false);

  const _SedeAction.remove() : this._(relation: null, isRemove: true);
}
