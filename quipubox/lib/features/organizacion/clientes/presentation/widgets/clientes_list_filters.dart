import 'package:flutter/material.dart';
import '../../../sedes/domain/entities/sede.dart';

class ClienteListFilters extends StatefulWidget {
  final ScrollController controller;
  final int? initialSedeId;
  final List<Sede> sedes;
  final bool sedeEnabled;
  final String? initialRelacion;
  const ClienteListFilters({
    super.key,
    required this.controller,
    this.initialSedeId,
    this.sedes = const [],
    this.sedeEnabled = false,
    this.initialRelacion,
  });
  @override
  State<ClienteListFilters> createState() => _ClienteListFiltersState();
}

class _ClienteListFiltersState extends State<ClienteListFilters> {
  int? sedeId;
  String? relacion;
  @override
  void initState() {
    super.initState();
    sedeId = widget.initialSedeId;
    relacion = widget.initialRelacion;
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
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            helperText: widget.sedeEnabled
                ? null
                : 'Pendiente de soporte en la API',
          ),
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
          onChanged: !widget.sedeEnabled
              ? null
              : (value) => setState(() => sedeId = value == 0 ? null : value),
        ),
        ...[
          const SizedBox(height: 20),
          const Text(
            'Tipo de relación',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: relacion ?? 'todos',
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(
                value: 'todos',
                child: Text('Todas las relaciones'),
              ),
              DropdownMenuItem(value: 'emisor', child: Text('Emisor')),
              DropdownMenuItem(value: 'receptor', child: Text('Receptor')),
              DropdownMenuItem(value: 'ambos', child: Text('Ambos')),
            ],
            onChanged: (value) =>
                setState(() => relacion = value == 'todos' ? null : value),
          ),
        ],
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () =>
                    Navigator.pop(context, (sedeId: null, relacion: null)),
                icon: const Icon(Icons.clear_rounded),
                label: const Text('Limpiar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context, (
                  sedeId: sedeId,
                  relacion: relacion,
                )),
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
