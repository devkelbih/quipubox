import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../core/network/connectivity_viewmodel.dart';
import '../../../../../core/ui/feedback/app_toast.dart';
import '../../domain/entities/reparto.dart';
import '../viewmodels/reparto_detail_viewmodel.dart';

class RepartoLineaForm extends StatefulWidget {
  final Reparto item;
  final RepartoLinea? editing;
  final ScrollController controller;
  const RepartoLineaForm({
    super.key,
    required this.item,
    this.editing,
    required this.controller,
  });
  @override
  State<RepartoLineaForm> createState() => _RepartoLineaFormState();
}

class _RepartoLineaFormState extends State<RepartoLineaForm> {
  int? _calidad;
  final _cantidad = TextEditingController();
  final _precio = TextEditingController();
  @override
  void initState() {
    super.initState();
    _calidad = widget.editing?.idCalidadCarga;
    _cantidad.text = widget.editing?.cantidad.toString() ?? '';
    _precio.text = widget.editing?.precio?.toString() ?? '';
  }

  @override
  void dispose() {
    _cantidad.dispose();
    _precio.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final vm = context.read<RepartoDetailViewModel>();
    final ok = await vm.line(
      widget.item.id,
      RepartoLinea(
        id: widget.editing?.id,
        idCalidadCarga: _calidad ?? 0,
        cantidad: int.tryParse(_cantidad.text) ?? 0,
        precio: _precio.text.trim().isEmpty
            ? null
            : double.tryParse(_precio.text.replaceAll(',', '.')) ?? double.nan,
      ),
    );
    if (!mounted) return;
    AppToast.show(
      ok
          ? 'Desglose actualizado correctamente.'
          : vm.errorMessage ?? 'No se pudo guardar la calidad.',
      type: ok ? ToastType.success : ToastType.error,
    );
    if (ok) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RepartoDetailViewModel>();
    final c = vm.data!;
    final calidades = c.calidades
        .where(
          (q) =>
              q.id != null &&
              (q.id == widget.editing?.idCalidadCarga ||
                  !widget.item.lineas.any((l) => l.idCalidadCarga == q.id)),
        )
        .toList();
    final selected = calidades.any((q) => q.id == _calidad) ? _calidad : null;
    return PopScope(
      canPop: !vm.isBusy,
      child: ListView(
        controller: widget.controller,
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            '${widget.item.cantidadDesglosada} de ${widget.item.cantidad} jabas con desglose',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            key: ValueKey(selected),
            initialValue: selected,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Calidad de la carga'),
            items: calidades
                .map(
                  (q) => DropdownMenuItem(
                    value: q.id,
                    child: Text(q.nombreCalidad ?? 'Calidad #${q.idCalidad}'),
                  ),
                )
                .toList(),
            onChanged: vm.isBusy || widget.editing != null
                ? null
                : (id) => setState(() {
                    _calidad = id;
                    _precio.text =
                        calidades
                            .where((q) => q.id == id)
                            .firstOrNull
                            ?.precioUnitario
                            ?.toString() ??
                        '';
                  }),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _cantidad,
            enabled: !vm.isBusy,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Cantidad de jabas',
              helperText: selected == null
                  ? null
                  : '${c.saldoCalidad(selected, excluirLinea: widget.editing?.id)} disponibles en esta calidad',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _precio,
            enabled: !vm.isBusy,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Precio unitario (opcional)',
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed:
                vm.isBusy || !context.watch<ConnectivityViewModel>().isOnline
                ? null
                : _save,
            icon: const Icon(Icons.save_outlined),
            label: Text(vm.isBusy ? 'Guardando...' : 'Guardar calidad'),
          ),
        ],
      ),
    );
  }
}
