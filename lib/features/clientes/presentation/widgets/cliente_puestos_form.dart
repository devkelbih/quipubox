import 'package:flutter/material.dart';
import 'package:quipubox/core/ui/sheets/app_bottom_sheet.dart';
import 'package:quipubox/features/clientes/domain/enums/secciones_cliente_puesto.dart';
import 'package:quipubox/features/puestos/domain/entities/puesto.dart';

class ClientePuestosForm extends StatelessWidget {
  final List<Puesto> puestos;
  final Set<int> selectedSedeIds;
  final Map<int, SeccionClientePuesto?> selectedPuestos;
  final ValueChanged<Map<int, SeccionClientePuesto?>> onChanged;

  const ClientePuestosForm({
    super.key,
    required this.puestos,
    required this.selectedSedeIds,
    required this.selectedPuestos,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final grupos = _groupPuestos();

    if (selectedSedeIds.isEmpty) {
      return const _EmptyMessage(
        message: 'Selecciona al menos una sede para ver sus puestos.',
      );
    }

    if (grupos.isEmpty) {
      return const _EmptyMessage(
        message: 'No hay puestos activos en las sedes seleccionadas.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Puestos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        const Text(
          'Puedes asignar puestos de las sedes seleccionadas. '
          'La asignación de puestos es opcional.',
        ),
        const SizedBox(height: 20),

        ...grupos.map((sedeGroup) => _buildSedeGroup(context, sedeGroup)),
      ],
    );
  }

  Widget _buildSedeGroup(BuildContext context, _SedePuestosGroup sedeGroup) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sedeGroup.nombreSede,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),

          ...sedeGroup.lugares.map(
            (lugarGroup) => _buildLugarGroup(context, lugarGroup),
          ),
        ],
      ),
    );
  }

  Widget _buildLugarGroup(BuildContext context, _LugarPuestosGroup lugarGroup) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                const Icon(Icons.store_outlined, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    lugarGroup.nombreLugar,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          ...lugarGroup.puestos.map(
            (puesto) => _buildPuestoTile(context, puesto),
          ),
        ],
      ),
    );
  }

  Widget _buildPuestoTile(BuildContext context, Puesto puesto) {
    final puestoId = puesto.id;

    if (puestoId == null) {
      return const SizedBox.shrink();
    }

    final isSelected = selectedPuestos.containsKey(puestoId);
    final seccion = selectedPuestos[puestoId];

    return InkWell(
      onTap: () => _selectSection(context, puesto),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Puesto ${puesto.numeroPuesto}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  if (isSelected) ...[
                    const SizedBox(height: 3),
                    Text(
                      seccion == null
                          ? 'Puesto completo'
                          : 'Sección ${_sectionLabel(seccion)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectSection(BuildContext context, Puesto puesto) async {
    final puestoId = puesto.id;

    if (puestoId == null) {
      return;
    }

    final isSelected = selectedPuestos.containsKey(puestoId);

    final action = await AppBottomSheet.show<_PuestoAction>(
      context: context,
      title: 'Puesto ${puesto.numeroPuesto}',
      builder: (context, controller) {
        return ListView(
          controller: controller,
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.store_outlined),
              title: const Text('Puesto completo'),
              subtitle: const Text(
                'Asignar el puesto sin especificar sección.',
              ),
              onTap: () {
                Navigator.of(context).pop(_PuestoAction.select(null));
              },
            ),
            ListTile(
              leading: const Icon(Icons.looks_one_outlined),
              title: const Text('Sección A'),
              onTap: () {
                Navigator.of(
                  context,
                ).pop(_PuestoAction.select(SeccionClientePuesto.a));
              },
            ),
            ListTile(
              leading: const Icon(Icons.looks_two_outlined),
              title: const Text('Sección B'),
              onTap: () {
                Navigator.of(
                  context,
                ).pop(_PuestoAction.select(SeccionClientePuesto.b));
              },
            ),
            ListTile(
              leading: const Icon(Icons.looks_3_outlined),
              title: const Text('Sección C'),
              onTap: () {
                Navigator.of(
                  context,
                ).pop(_PuestoAction.select(SeccionClientePuesto.c));
              },
            ),

            if (isSelected) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.remove_circle_outline),
                title: const Text('Quitar asignación'),
                onTap: () {
                  Navigator.of(context).pop(_PuestoAction.remove());
                },
              ),
            ],
          ],
        );
      },
    );

    if (action == null) {
      return;
    }

    final updated = Map<int, SeccionClientePuesto?>.from(selectedPuestos);

    if (action.isRemove) {
      updated.remove(puestoId);
    } else {
      updated[puestoId] = action.section;
    }

    onChanged(updated);
  }

  List<_SedePuestosGroup> _groupPuestos() {
    final filtered = puestos.where((puesto) {
      final idPuesto = puesto.id;
      final lugar = puesto.lugarOperativo;

      if (idPuesto == null || lugar == null) {
        return false;
      }

      if (!puesto.estado) {
        return false;
      }

      final idSede = lugar.idSede;

      return selectedSedeIds.contains(idSede);
    }).toList();

    final sedeGroups = <int, _SedePuestosGroup>{};

    for (final puesto in filtered) {
      final lugar = puesto.lugarOperativo!;

      final idSede = lugar.idSede;

      final sede = lugar.sede;

      final sedeGroup = sedeGroups.putIfAbsent(
        idSede,
        () => _SedePuestosGroup(
          idSede: idSede,
          nombreSede: sede?.nombre ?? 'Sede $idSede',
        ),
      );

      final idLugar = lugar.id;

      if (idLugar == null) {
        continue;
      }

      final lugarGroup = sedeGroup.lugaresMap.putIfAbsent(
        idLugar,
        () => _LugarPuestosGroup(idLugar: idLugar, nombreLugar: lugar.nombre),
      );

      lugarGroup.puestos.add(puesto);
    }

    return sedeGroups.values.map((sedeGroup) {
      return _SedePuestosGroup(
        idSede: sedeGroup.idSede,
        nombreSede: sedeGroup.nombreSede,
        lugares: sedeGroup.lugaresMap.values.toList(),
      );
    }).toList();
  }

  String _sectionLabel(SeccionClientePuesto section) {
    switch (section) {
      case SeccionClientePuesto.a:
        return 'A';
      case SeccionClientePuesto.b:
        return 'B';
      case SeccionClientePuesto.c:
        return 'C';
    }
  }
}

class _SedePuestosGroup {
  final int idSede;
  final String nombreSede;
  final List<_LugarPuestosGroup> lugares;

  _SedePuestosGroup({
    required this.idSede,
    required this.nombreSede,
    this.lugares = const [],
  });

  final Map<int, _LugarPuestosGroup> lugaresMap = {};
}

class _LugarPuestosGroup {
  final int idLugar;
  final String nombreLugar;
  final List<Puesto> puestos;

  _LugarPuestosGroup({
    required this.idLugar,
    required this.nombreLugar,
    List<Puesto>? puestos,
  }) : puestos = puestos ?? [];
}

class _PuestoAction {
  final SeccionClientePuesto? section;
  final bool isRemove;

  const _PuestoAction({required this.section, required this.isRemove});

  factory _PuestoAction.select(SeccionClientePuesto? section) {
    return _PuestoAction(section: section, isRemove: false);
  }

  factory _PuestoAction.remove() {
    return const _PuestoAction(section: null, isRemove: true);
  }
}

class _EmptyMessage extends StatelessWidget {
  final String message;

  const _EmptyMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(child: Text(message, textAlign: TextAlign.center)),
    );
  }
}
