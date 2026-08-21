import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quipubox/features/sedes/domain/entities/sede.dart';
import 'package:quipubox/features/sedes/presentation/viewmodels/sedes_viewmodel.dart';

class UsuarioSedeForm extends StatelessWidget {
  final Sede? selectedSede;
  final ValueChanged<Sede> onChanged;
  final bool hasError;

  const UsuarioSedeForm({
    super.key,
    required this.selectedSede,
    required this.onChanged,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _selectSede(context),
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Sede',
              errorText: hasError ? 'Selecciona una sede para continuar.' : null,
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

    if (sedeViewModel.items.isEmpty && !sedeViewModel.isLoading) {
      await sedeViewModel.load();
    }

    if (!context.mounted) {
      return;
    }

    final sedesActivas = sedeViewModel.items
        .where((sede) => sede.estado)
        .toList();

    if (sedesActivas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay sedes activas disponibles.'),
        ),
      );

      return;
    }

    final selected = await showModalBottomSheet<Sede>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const Padding(
              padding: EdgeInsets.only(
                left: 4,
                bottom: 12,
              ),
              child: Text(
                'Seleccionar sede',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            ...sedesActivas.map(
              (sede) {
                final isSelected = selectedSede?.id == sede.id;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  title: Text(sede.nombre),
                  trailing: isSelected
                      ? const Icon(Icons.check_rounded)
                      : null,
                  onTap: () {
                    Navigator.of(context).pop(sede);
                  },
                );
              },
            ),
          ],
        );
      },
    );

    if (selected == null || !context.mounted) {
      return;
    }

    onChanged(selected);
  }
}