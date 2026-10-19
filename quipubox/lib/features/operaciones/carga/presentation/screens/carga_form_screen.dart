import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/ui/feedback/app_toast.dart';

import '../../../../../core/network/connectivity_viewmodel.dart';
import '../../../../catalogos/camiones/domain/entities/camion.dart';
import '../../../../catalogos/camiones/presentation/viewmodels/camiones_viewmodel.dart';
import '../../../../organizacion/sedes/domain/entities/sede.dart';
import '../../../../organizacion/sedes/presentation/viewmodels/sedes_viewmodel.dart';
import '../../../../organizacion/usuarios/domain/entities/usuario.dart';
import '../../../../organizacion/usuarios/presentation/viewmodels/usuarios_viewmodel.dart';
import '../../domain/entities/operacion_carga.dart';
import '../viewmodels/carga_viewmodel.dart';

class CargaFormScreen extends StatefulWidget {
  final OperacionCarga? item;
  final int? operationId;

  const CargaFormScreen({super.key, this.item, this.operationId});

  @override
  State<CargaFormScreen> createState() => _CargaFormScreenState();
}

class _CargaFormScreenState extends State<CargaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fechaController;
  late final TextEditingController _horaController;
  late final TextEditingController _observacionesController;

  DateTime? _fechaCarga;
  TimeOfDay? _horaCarga;
  int? _idSedeOrigen;
  int? _idSedeDestino;
  int? _idCamion;
  int? _idEncargadoCarga;
  int? _idRepartidor;
  bool _loadingOperation = false;

  bool get _isEditing => widget.item != null || widget.operationId != null;

  @override
  void initState() {
    super.initState();
    _fechaController = TextEditingController();
    _horaController = TextEditingController();
    _observacionesController = TextEditingController();
    _applyItem(widget.item);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_loadFormData());
    });
  }

  @override
  void dispose() {
    _fechaController.dispose();
    _horaController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CargaViewModel>();
    final sedesVm = context.watch<SedeViewModel>();
    final camionesVm = context.watch<CamionViewModel>();
    final usuariosVm = context.watch<UsuarioViewModel>();
    final isOnline = context.watch<ConnectivityViewModel>().isOnline;
    final isBusy = vm.isSaving || _loadingOperation;

    final sedes = _availableSedes(sedesVm.items);
    final camiones = _availableCamiones(camionesVm.items);
    final usuarios = _availableUsers(usuariosVm.items);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_loadingOperation ||
              sedesVm.isLoading ||
              camionesVm.isLoading ||
              usuariosVm.isLoading)
            const LinearProgressIndicator(),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: _matchingId(_idSedeOrigen, sedes),
            decoration: const InputDecoration(
              labelText: 'Sede de origen',
              prefixIcon: Icon(Icons.trip_origin_rounded),
            ),
            items: sedes
                .where((sede) => sede.id != null)
                .map(
                  (sede) => DropdownMenuItem<int>(
                    value: sede.id!,
                    child: Text(sede.nombre, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: isBusy || sedesVm.isLoading
                ? null
                : (value) => setState(() => _idSedeOrigen = value),
            validator: (value) => value == null ? 'Selecciona una sede.' : null,
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<int?>(
            initialValue: _matchingId(_idSedeDestino, sedes),
            decoration: const InputDecoration(
              labelText: 'Sede de destino (opcional)',
              prefixIcon: Icon(Icons.place_outlined),
            ),
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text('Sin destino'),
              ),
              ...sedes
                  .where((sede) => sede.id != null)
                  .map(
                    (sede) => DropdownMenuItem<int?>(
                      value: sede.id,
                      child: Text(sede.nombre, overflow: TextOverflow.ellipsis),
                    ),
                  ),
            ],
            onChanged: isBusy || sedesVm.isLoading
                ? null
                : (value) => setState(() => _idSedeDestino = value),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<int>(
            initialValue: _matchingId(_idCamion, camiones),
            decoration: const InputDecoration(
              labelText: 'Camión',
              prefixIcon: Icon(Icons.local_shipping_outlined),
            ),
            items: camiones
                .where((camion) => camion.id != null)
                .map(
                  (camion) => DropdownMenuItem<int>(
                    value: camion.id!,
                    child: Text(camion.placa),
                  ),
                )
                .toList(),
            onChanged: isBusy || camionesVm.isLoading
                ? null
                : (value) => setState(() => _idCamion = value),
            validator: (value) =>
                value == null ? 'Selecciona un camión.' : null,
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<int?>(
            initialValue: _matchingId(_idEncargadoCarga, usuarios),
            decoration: const InputDecoration(
              labelText: 'Encargado de carga (opcional)',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text('Sin asignar'),
              ),
              ...usuarios
                  .where((usuario) => usuario.id != null)
                  .map(
                    (usuario) => DropdownMenuItem<int?>(
                      value: usuario.id,
                      child: Text(
                        usuario.nombreCompleto,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
            ],
            onChanged: isBusy || usuariosVm.isLoading
                ? null
                : (value) => setState(() => _idEncargadoCarga = value),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<int?>(
            initialValue: _matchingId(_idRepartidor, usuarios),
            decoration: const InputDecoration(
              labelText: 'Repartidor asignado (opcional)',
              prefixIcon: Icon(Icons.delivery_dining_rounded),
            ),
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text('Sin asignar'),
              ),
              ...usuarios
                  .where((usuario) => usuario.id != null)
                  .map(
                    (usuario) => DropdownMenuItem<int?>(
                      value: usuario.id,
                      child: Text(
                        usuario.nombreCompleto,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
            ],
            onChanged: isBusy || usuariosVm.isLoading
                ? null
                : (value) => setState(() => _idRepartidor = value),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _fechaController,
            readOnly: true,
            enabled: !isBusy,
            decoration: const InputDecoration(
              labelText: 'Fecha de carga',
              prefixIcon: Icon(Icons.calendar_month_rounded),
            ),
            onTap: isBusy ? null : _pickDate,
            validator: (_) =>
                _fechaCarga == null ? 'Selecciona la fecha de carga.' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _horaController,
            readOnly: true,
            enabled: !isBusy,
            decoration: const InputDecoration(
              labelText: 'Hora de carga (opcional)',
              prefixIcon: Icon(Icons.schedule_rounded),
            ),
            onTap: isBusy ? null : _pickTime,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _observacionesController,
            enabled: !isBusy,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Observaciones',
              prefixIcon: Icon(Icons.notes_rounded),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: isBusy || !isOnline ? null : _submit,
            icon: isBusy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(_isEditing ? Icons.save_rounded : Icons.add_rounded),
            label: Text(_isEditing ? 'Guardar cambios' : 'Crear operación'),
          ),
          if (!isOnline) ...[
            const SizedBox(height: 12),
            Text(
              'Se requiere conexión a internet para guardar.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _loadFormData() async {
    final sedesVm = context.read<SedeViewModel>();
    final camionesVm = context.read<CamionViewModel>();
    final usuariosVm = context.read<UsuarioViewModel>();
    final loads = <Future<void>>[];

    if (sedesVm.items.isEmpty && !sedesVm.isLoading) loads.add(sedesVm.load());
    if (camionesVm.items.isEmpty && !camionesVm.isLoading) {
      loads.add(camionesVm.load());
    }
    if (usuariosVm.items.isEmpty && !usuariosVm.isLoading) {
      loads.add(usuariosVm.load());
    }
    await Future.wait(loads);

    final id = widget.operationId;
    if (widget.item == null && id != null && mounted) {
      setState(() => _loadingOperation = true);
      final loaded = await context.read<CargaViewModel>().loadById(id);
      if (mounted) {
        if (loaded) _applyItem(context.read<CargaViewModel>().selected);
        setState(() => _loadingOperation = false);
      }
    }
  }

  void _applyItem(OperacionCarga? item) {
    if (item == null) return;
    _idSedeOrigen = item.idSedeOrigen;
    _idSedeDestino = item.idSedeDestino;
    _idCamion = item.idCamion;
    _idEncargadoCarga = item.idEncargadoCarga;
    _idRepartidor = item.idRepartidorAsignado;
    _fechaCarga = item.fechaCarga;
    _horaCarga = _parseTime(item.horaCarga);
    _fechaController.text = _dateText(item.fechaCarga);
    _horaController.text = item.horaCarga ?? '';
    _observacionesController.text = item.observaciones ?? '';
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _fechaCarga ?? today,
      firstDate: DateTime(today.year - 5),
      lastDate: DateTime(today.year + 5),
    );
    if (selected == null || !mounted) return;
    setState(() {
      _fechaCarga = selected;
      _fechaController.text = _dateText(selected);
    });
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _horaCarga ?? TimeOfDay.now(),
    );
    if (selected == null || !mounted) return;
    setState(() {
      _horaCarga = selected;
      _horaController.text = _timeText(selected);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final item =
        widget.item ??
        (widget.operationId == null
            ? null
            : context.read<CargaViewModel>().selected);
    final operation = OperacionCarga(
      id: item?.id,
      idEmpresa: item?.idEmpresa,
      idSedeOrigen: _idSedeOrigen!,
      idSedeDestino: _idSedeDestino,
      idCamion: _idCamion!,
      idEncargadoCarga: _idEncargadoCarga,
      idRepartidorAsignado: _idRepartidor,
      fechaCarga: _fechaCarga!,
      horaCarga: _horaCarga == null ? null : _timeText(_horaCarga!),
      estado: item?.estado ?? 'pendiente',
      observaciones: _observacionesController.text.trim().isEmpty
          ? null
          : _observacionesController.text.trim(),
      detalles: item?.detalles,
    );

    final vm = context.read<CargaViewModel>();
    final succeeded = _isEditing
        ? await vm.update(operation)
        : await vm.create(operation);

    if (!mounted) return;
    AppToast.show(
      succeeded
          ? _isEditing
                ? 'Operación actualizada correctamente.'
                : 'Operación creada correctamente.'
          : vm.errorMessage ?? 'No se pudo guardar la operación.',
      type: succeeded ? ToastType.success : ToastType.error,
    );
    if (succeeded) Navigator.of(context).pop();
  }

  List<Sede> _availableSedes(List<Sede> items) => items
      .where(
        (item) =>
            item.estado ||
            item.id == _idSedeOrigen ||
            item.id == _idSedeDestino,
      )
      .toList();

  List<Camion> _availableCamiones(List<Camion> items) =>
      items.where((item) => item.estado || item.id == _idCamion).toList();

  List<Usuario> _availableUsers(List<Usuario> items) => items
      .where(
        (item) =>
            item.estado ||
            item.id == _idEncargadoCarga ||
            item.id == _idRepartidor,
      )
      .toList();

  int? _matchingId(int? value, List<dynamic> items) {
    if (value == null || !items.any((item) => item.id == value)) return null;
    return value;
  }

  static TimeOfDay? _parseTime(String? value) {
    if (value == null || value.isEmpty) return null;
    final parts = value.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static String _dateText(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  static String _timeText(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
