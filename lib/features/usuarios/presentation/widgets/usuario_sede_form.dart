import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quipubox/core/ui/sheets/app_bottom_sheet.dart';
import 'package:quipubox/features/sedes/domain/entities/sede.dart';
import 'package:quipubox/features/sedes/presentation/viewmodels/sedes_viewmodel.dart';

class UsuarioSedeForm extends StatelessWidget {
  final int? selectedSedeId;
  final ValueChanged<int> onChanged;
  final bool hasError;

  const UsuarioSedeForm({
    super.key,
    required this.selectedSedeId,
    required this.onChanged,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sedeViewModel = context.watch<SedeViewModel>();

    final selectedSede = selectedSedeId == null
        ? null
        : sedeViewModel.items.cast<Sede?>().firstWhere(
            (sede) => sede?.id == selectedSedeId,
            orElse: () => null,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sede del usuario',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 8),

        Text(
          'La sede define el contexto operativo del usuario. '
          'Permite determinar la información, módulos y operaciones '
          'que corresponden a su ubicación y actividad dentro de la empresa.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 24),

        InkWell(
          onTap: () => _selectSede(context),
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Sede',
              errorText: hasError
                  ? 'Selecciona una sede para continuar.'
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedSede?.nombre ?? 'Selecciona una sede',
                    style: TextStyle(
                      color: selectedSede != null
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
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
      ],
    );
  }

  Future<void> _selectSede(BuildContext context) async {
    final sedeViewModel = context.read<SedeViewModel>();

    final sedesActivas = sedeViewModel.items
        .where((sede) => sede.estado)
        .toList();

    if (sedesActivas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay sedes activas disponibles.')),
      );

      return;
    }

    final selected = await AppBottomSheet.show<Sede>(
      context: context,
      title: 'Seleccionar sede',
      initialChildSize: 0.40,
      minChildSize: 0.30,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            ...sedesActivas.map((sede) {
              final isSelected = selectedSedeId == sede.id;

              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(sede.nombre),
                trailing: isSelected ? const Icon(Icons.check_rounded) : null,
                onTap: () {
                  Navigator.of(context).pop(sede);
                },
              );
            }),
          ],
        );
      },
    );

    if (selected == null || !context.mounted) {
      return;
    }

    onChanged(selected.id!);
  }
}
