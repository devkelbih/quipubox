import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../core/network/connectivity_viewmodel.dart';
import '../../../../../core/ui/feedback/app_toast.dart';
import '../../../../../core/ui/cards/app_card.dart';
import '../../../../organizacion/clientes/domain/entities/cliente.dart';
import '../../../../organizacion/clientes/domain/entities/cliente_puesto.dart';
import '../../domain/entities/reparto.dart';
import '../viewmodels/reparto_detail_viewmodel.dart';

class AsignacionRepartoForm extends StatefulWidget {
  final ScrollController controller;
  final Reparto? editing;
  const AsignacionRepartoForm({
    super.key,
    required this.controller,
    this.editing,
  });
  @override
  State<AsignacionRepartoForm> createState() => _AsignacionRepartoFormState();
}

class _AsignacionRepartoFormState extends State<AsignacionRepartoForm> {
  int? _receptor;
  ClientePuesto? _puesto;
  bool _porCalidades = true;
  final _cantidad = TextEditingController();
  final _orden = TextEditingController();
  final _observaciones = TextEditingController();
  final _cantidades = <int, TextEditingController>{};
  final _precios = <int, TextEditingController>{};
  final _borradores = <AsignacionReparto>[];
  @override
  void initState() {
    super.initState();
    final c = context.read<RepartoDetailViewModel>().data!;
    final item = widget.editing;
    _receptor = item?.receptorId;
    _puesto = item == null
        ? null
        : c
              .puestos(item.receptorId ?? 0)
              .where(
                (p) =>
                    p.idPuesto == item.puestoId &&
                    p.seccion?.value == item.seccion,
              )
              .firstOrNull;
    _cantidad.text = item?.cantidad.toString() ?? '';
    _orden.text = item?.orden?.toString() ?? '';
    _observaciones.text = item?.observaciones ?? '';
    _porCalidades =
        item == null && c.detalle.esReparto && c.calidades.isNotEmpty;
    for (final calidad in c.calidades.where((q) => q.id != null)) {
      _cantidades[calidad.id!] = TextEditingController();
      _precios[calidad.id!] = TextEditingController(
        text: calidad.precioUnitario?.toString() ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _cantidad,
      _orden,
      _observaciones,
      ..._cantidades.values,
      ..._precios.values,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  int _saldo(int id) {
    final c = context.read<RepartoDetailViewModel>().data!;
    return c.saldoCalidad(id) -
        _borradores
            .expand((a) => a.lineas)
            .where((l) => l.idCalidadCarga == id)
            .fold<int>(0, (n, l) => n + l.cantidad);
  }

  AsignacionReparto _read() {
    final lineas = _porCalidades
        ? _cantidades.entries
              .where(
                (e) => e.value.text.trim().isNotEmpty && e.value.text != '0',
              )
              .map(
                (e) => RepartoLinea(
                  idCalidadCarga: e.key,
                  cantidad: int.tryParse(e.value.text) ?? 0,
                  precio: _precios[e.key]!.text.trim().isEmpty
                      ? null
                      : double.tryParse(
                              _precios[e.key]!.text.replaceAll(',', '.'),
                            ) ??
                            double.nan,
                ),
              )
              .toList()
        : <RepartoLinea>[];
    return AsignacionReparto(
      receptorId: _receptor ?? 0,
      puestoId:
          _puesto?.idPuesto ??
          (widget.editing?.receptorId == _receptor
              ? widget.editing?.puestoId ?? 0
              : 0),
      seccion:
          _puesto?.seccion?.value ??
          (widget.editing?.receptorId == _receptor
              ? widget.editing?.seccion
              : null),
      cantidad: _porCalidades
          ? lineas.fold<int>(0, (n, l) => n + l.cantidad)
          : int.tryParse(_cantidad.text) ?? 0,
      lineas: lineas,
      orden: _orden.text.trim().isEmpty ? null : int.tryParse(_orden.text) ?? 0,
      observaciones: _observaciones.text.trim().isEmpty
          ? null
          : _observaciones.text.trim(),
    );
  }

  void _stage() {
    final a = _read();
    if (a.receptorId <= 0 ||
        a.puestoId <= 0 ||
        a.cantidad < 1 ||
        a.lineas.isEmpty ||
        a.lineas.any(
          (l) => l.cantidad < 1 || l.cantidad > _saldo(l.idCalidadCarga),
        )) {
      AppToast.show(
        'Selecciona receptor, puesto y cantidades dentro del saldo disponible.',
        type: ToastType.error,
      );
      return;
    }
    setState(() {
      _borradores.add(a);
      _receptor = null;
      _puesto = null;
      for (final ctrl in _cantidades.values) {
        ctrl.clear();
      }
      _orden.clear();
      _observaciones.clear();
    });
  }

  Future<void> _save() async {
    final vm = context.read<RepartoDetailViewModel>();
    final pendingInput =
        _receptor != null ||
        _puesto != null ||
        _cantidades.values.any((c) => c.text.isNotEmpty && c.text != '0');
    final items = [
      ..._borradores,
      if (_borradores.isEmpty || pendingInput) _read(),
    ];
    final ok = widget.editing == null
        ? await vm.assign(items)
        : await vm.update(widget.editing!.id, _read());
    if (!mounted) return;
    AppToast.show(
      ok
          ? 'Asignación guardada correctamente.'
          : vm.errorMessage ?? 'No se pudo guardar la asignación.',
      type: ok ? ToastType.success : ToastType.error,
    );
    if (ok) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RepartoDetailViewModel>();
    final c = vm.data!;
    final busy = vm.isBusy;
    final clientes = [...c.receptores];
    final original = widget.editing;
    if (original?.receptorId != null &&
        !clientes.any((r) => r.id == original!.receptorId)) {
      clientes.add(
        original!.receptor ??
            Cliente(
              id: original.receptorId,
              nombres: 'Receptor #${original.receptorId}',
            ),
      );
    }
    final puestos = c.puestos(_receptor ?? 0);
    final puestoIndex = _puesto == null
        ? -1
        : puestos.indexWhere(
            (p) =>
                p.idPuesto == _puesto!.idPuesto &&
                p.seccion == _puesto!.seccion,
          );
    return PopScope(
      canPop: !busy,
      child: ListView(
        controller: widget.controller,
        padding: const EdgeInsets.all(20),
        children: [
          AppCard(
            header: Text(
              '${c.detalle.cantidadJabas} jabas · ${c.detalle.fruta?.nombre ?? 'Carga #${c.detalle.id}'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            body: Text(
              'Asignadas: ${c.asignadas}/${c.detalle.cantidadJabas}\nClasificadas: ${c.clasificadas}/${c.detalle.cantidadJabas}',
            ),
          ),
          const SizedBox(height: 20),
          if (_borradores.isNotEmpty) ...[
            Text(
              'Asignaciones preparadas (${_borradores.length})',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            for (final (i, a) in _borradores.indexed)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '${c.clientes.where((cl) => cl.id == a.receptorId).firstOrNull?.nombreCompleto ?? 'Receptor ${a.receptorId}'} · ${a.cantidad} jabas',
                ),
                trailing: IconButton(
                  tooltip: 'Quitar borrador',
                  onPressed: busy
                      ? null
                      : () => setState(() => _borradores.removeAt(i)),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
            const Divider(),
          ],
          DropdownButtonFormField<int>(
            key: ValueKey(_receptor),
            initialValue: _receptor,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Receptor'),
            items: clientes
                .map(
                  (r) => DropdownMenuItem(
                    value: r.id,
                    child: Text(
                      r.nombreCompleto,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: busy
                ? null
                : (id) => setState(() {
                    _receptor = id;
                    _puesto = null;
                  }),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            key: ValueKey('$_receptor:$puestoIndex'),
            initialValue: puestoIndex < 0 ? null : puestoIndex,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Puesto y sección',
              helperText:
                  original != null &&
                      _receptor == original.receptorId &&
                      _puesto == null
                  ? 'Se conserva el puesto ${original.puesto?.numeroPuesto ?? original.puestoId.toString()} si no eliges otro.'
                  : puestos.isEmpty
                  ? 'Este receptor no tiene puestos activos en la sede de destino.'
                  : null,
            ),
            items: puestos.indexed
                .map(
                  (entry) => DropdownMenuItem(
                    value: entry.$1,
                    child: Text(
                      '${entry.$2.puesto?.numeroPuesto ?? entry.$2.idPuesto.toString()}${entry.$2.seccion == null ? '' : ' · ${entry.$2.seccion!.label}'}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: busy
                ? null
                : (index) => setState(
                    () => _puesto = index == null ? null : puestos[index],
                  ),
          ),
          const SizedBox(height: 16),
          if (original == null && c.detalle.esReparto)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Asignar por calidades'),
              subtitle: const Text(
                'Sin desglose se reserva la cantidad para completar sus calidades después.',
              ),
              value: _porCalidades,
              onChanged: busy || _borradores.isNotEmpty
                  ? null
                  : (value) => setState(() => _porCalidades = value),
            ),
          if (_porCalidades) ...[
            if (c.calidades.isEmpty)
              const Text('Registra primero las calidades de esta carga.'),
            for (final calidad in c.calidades.where((q) => q.id != null)) ...[
              Text(
                '${calidad.nombreCalidad ?? 'Calidad #${calidad.idCalidad}'} · ${_saldo(calidad.id!)} disponibles',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              TextField(
                key: ValueKey('reparto-cantidad-${calidad.id}'),
                controller: _cantidades[calidad.id],
                enabled: !busy,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Cantidad de jabas',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                key: ValueKey('reparto-precio-${calidad.id}'),
                controller: _precios[calidad.id],
                enabled: !busy,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Precio unitario (opcional)',
                ),
              ),
              const SizedBox(height: 16),
            ],
          ] else
            TextField(
              controller: _cantidad,
              enabled: !busy,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Cantidad asignada'),
            ),
          const SizedBox(height: 16),
          TextField(
            controller: _orden,
            enabled: !busy,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Orden de entrega (opcional)',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _observaciones,
            enabled: !busy,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Observaciones (opcional)',
            ),
          ),
          const SizedBox(height: 20),
          if (original == null && _porCalidades && c.detalle.esReparto)
            OutlinedButton.icon(
              onPressed: busy ? null : _stage,
              icon: const Icon(Icons.person_add_alt_rounded),
              label: const Text('Preparar otro receptor'),
            ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: busy || !context.watch<ConnectivityViewModel>().isOnline
                ? null
                : _save,
            icon: busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_rounded),
            label: Text(
              busy
                  ? 'Guardando...'
                  : _borradores.isEmpty
                  ? 'Guardar asignación'
                  : 'Guardar asignaciones',
            ),
          ),
        ],
      ),
    );
  }
}
