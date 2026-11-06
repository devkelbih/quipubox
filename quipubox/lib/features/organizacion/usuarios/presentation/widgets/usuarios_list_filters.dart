import 'package:flutter/material.dart';
import '../../../sedes/domain/entities/sede.dart';

class UsuarioListFilters extends StatefulWidget {
  final ScrollController controller;
  final int? initialSedeId;
  final List<Sede> sedes;
  const UsuarioListFilters({
    super.key,
    required this.controller,
    this.initialSedeId,
    required this.sedes,
  });
  @override
  State<UsuarioListFilters> createState() => _UsuarioListFiltersState();
}

class _UsuarioListFiltersState extends State<UsuarioListFilters> {
  int? sedeId;

  @override
  void initState() {
    super.initState();
    sedeId = widget.initialSedeId;
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    controller: widget.controller,
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Sede', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          initialValue: sedeId ?? 0,
          isExpanded: true,
          decoration: InputDecoration(border: const OutlineInputBorder()),
          items: [
            const DropdownMenuItem(value: 0, child: Text('Todas las sedes')),
            ...widget.sedes
                .where((s) => s.id != null)
                .map(
                  (s) => DropdownMenuItem(
                    value: s.id!,
                    child: Text(s.nombre, overflow: TextOverflow.ellipsis),
                  ),
                ),
          ],
          onChanged: (value) =>
              setState(() => sedeId = value == 0 ? null : value),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context, 0),
                icon: const Icon(Icons.clear_rounded),
                label: const Text('Limpiar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context, sedeId ?? 0),
                icon: const Icon(Icons.check_rounded),
                label: const Text('Aplicar'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
