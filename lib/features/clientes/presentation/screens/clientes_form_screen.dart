import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quipubox/core/ui/feedback/app_toast.dart';
import 'package:quipubox/features/clientes/domain/entities/cliente.dart';
import 'package:quipubox/features/clientes/domain/entities/cliente_puesto.dart';
import 'package:quipubox/features/clientes/domain/entities/cliente_sede.dart';
import 'package:quipubox/features/clientes/domain/enums/secciones_cliente_puesto.dart';
import 'package:quipubox/features/clientes/domain/enums/tipos_relacion_cliente_sedes.dart';
import 'package:quipubox/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:quipubox/features/clientes/presentation/widgets/cliente_datos_form.dart';
import 'package:quipubox/features/clientes/presentation/widgets/cliente_form_actions.dart';
import 'package:quipubox/features/clientes/presentation/widgets/cliente_form_stepper.dart';
import 'package:quipubox/features/clientes/presentation/widgets/cliente_puestos_form.dart';
import 'package:quipubox/features/clientes/presentation/widgets/cliente_sedes_form.dart';
import 'package:quipubox/features/puestos/presentation/viewmodels/puestos_viewmodel.dart';
import 'package:quipubox/features/sedes/presentation/viewmodels/sedes_viewmodel.dart';

class ClienteFormScreen extends StatefulWidget {
  final Cliente? item;

  const ClienteFormScreen({super.key, this.item});

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  static const int _totalSteps = 3;

  int _currentStep = 0;

  final _formKey = GlobalKey<FormState>();

  final Set<int> _completedSteps = {};
  final Set<int> _errorSteps = {};

  late final TextEditingController _nombresController;
  late final TextEditingController _apellidosController;
  late final TextEditingController _apodoController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _observacionesController;

  /// Sede -> tipo de relación.
  late Map<int, TipoRelacionClienteSede> _selectedSedes;

  /// Puesto -> sección.
  ///
  /// containsKey(id) = puesto seleccionado.
  /// value == null = puesto completo.
  late Map<int, SeccionClientePuesto?> _selectedPuestos;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();

    _nombresController = TextEditingController(
      text: widget.item?.nombres ?? '',
    );

    _apellidosController = TextEditingController(
      text: widget.item?.apellidos ?? '',
    );

    _apodoController = TextEditingController(text: widget.item?.apodo ?? '');

    _telefonoController = TextEditingController(
      text: widget.item?.telefono ?? '',
    );

    _observacionesController = TextEditingController(
      text: widget.item?.observaciones ?? '',
    );

    _selectedSedes = {
      for (final clienteSede in widget.item?.sedes ?? const <ClienteSede>[])
        clienteSede.idSede: clienteSede.tipoRelacion,
    };

    _selectedPuestos = {
      for (final clientePuesto
          in widget.item?.puestos ?? const <ClientePuesto>[])
        clientePuesto.idPuesto: clientePuesto.seccion,
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context.read<SedeViewModel>().load();
      context.read<PuestoViewModel>().load();
    });
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _apodoController.dispose();
    _telefonoController.dispose();
    _observacionesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClienteViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar cliente' : 'Nuevo cliente'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            ClienteFormStepper(
              currentStep: _currentStep,
              completedSteps: _completedSteps,
              errorSteps: _errorSteps,
              onStepTapped: vm.isSaving ? null : _handleStepTapped,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStep(),
              ),
            ),

            ClienteFormActions(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              isSaving: vm.isSaving,
              onBack: vm.isSaving ? null : _handleStepCancel,
              onContinue: vm.isSaving ? null : _handleStepContinue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildDatos();

      case 1:
        return _buildSedes();

      case 2:
        return _buildPuestos();

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDatos() {
    return ClienteDatosForm(
      nombresController: _nombresController,
      apellidosController: _apellidosController,
      apodoController: _apodoController,
      telefonoController: _telefonoController,
      observacionesController: _observacionesController,
    );
  }

  Widget _buildSedes() {
    return Consumer<SedeViewModel>(
      builder: (context, viewModel, _) {
        return ClienteSedesForm(
          sedes: viewModel.items,
          selectedSedes: _selectedSedes,
          hasError: _errorSteps.contains(1),
          onChanged: _handleSedesChanged,
        );
      },
    );
  }

  Widget _buildPuestos() {
    return Consumer<PuestoViewModel>(
      builder: (context, viewModel, _) {
        return ClientePuestosForm(
          puestos: viewModel.items,
          selectedSedeIds: _selectedSedes.keys.toSet(),
          selectedPuestos: _selectedPuestos,
          onChanged: (selectedPuestos) {
            setState(() {
              _selectedPuestos = selectedPuestos;

              _errorSteps.remove(2);
              _completedSteps.add(2);
            });
          },
        );
      },
    );
  }

  void _handleSedesChanged(Map<int, TipoRelacionClienteSede> selectedSedes) {
    final puestosViewModel = context.read<PuestoViewModel>();

    final selectedSedeIds = selectedSedes.keys.toSet();

    final updatedPuestos = <int, SeccionClientePuesto?>{};

    for (final entry in _selectedPuestos.entries) {
      final puesto = puestosViewModel.items
          .where((item) => item.id == entry.key)
          .firstOrNull;

      if (puesto == null) {
        continue;
      }

      final lugar = puesto.lugarOperativo;

      if (lugar == null) {
        continue;
      }

      final idSede = lugar.idSede;

      if (selectedSedeIds.contains(idSede)) {
        updatedPuestos[entry.key] = entry.value;
      }
    }

    setState(() {
      _selectedSedes = selectedSedes;
      _selectedPuestos = updatedPuestos;

      if (selectedSedes.isNotEmpty) {
        _errorSteps.remove(1);
        _completedSteps.add(1);
      } else {
        _completedSteps.remove(1);
      }
    });
  }

  void _handleStepContinue() {
    switch (_currentStep) {
      case 0:
        if (!_validateDatos()) {
          return;
        }
        break;

      case 1:
        if (!_validateSedes()) {
          return;
        }
        break;

      case 2:
        if (!_validatePuestos()) {
          return;
        }

        _guardar();
        return;
    }

    setState(() {
      _currentStep++;
    });
  }

  void _handleStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });

      return;
    }

    Navigator.of(context).pop();
  }

  void _handleStepTapped(int step) {
    if (step <= _currentStep) {
      setState(() {
        _currentStep = step;
      });

      return;
    }

    switch (_currentStep) {
      case 0:
        if (!_validateDatos()) {
          return;
        }
        break;

      case 1:
        if (!_validateSedes()) {
          return;
        }
        break;

      case 2:
        if (!_validatePuestos()) {
          return;
        }
        break;
    }

    setState(() {
      _currentStep = step;
    });
  }

  bool _validateDatos() {
    final isValid = _formKey.currentState!.validate();

    setState(() {
      if (isValid) {
        _completedSteps.add(0);
        _errorSteps.remove(0);
      } else {
        _completedSteps.remove(0);
        _errorSteps.add(0);
      }
    });

    return isValid;
  }

  bool _validateSedes() {
    final isValid = _selectedSedes.isNotEmpty;

    setState(() {
      if (isValid) {
        _completedSteps.add(1);
        _errorSteps.remove(1);
      } else {
        _completedSteps.remove(1);
        _errorSteps.add(1);
      }
    });

    return isValid;
  }

  bool _validatePuestos() {
    // Los puestos son opcionales.
    _completedSteps.add(2);
    _errorSteps.remove(2);

    return true;
  }

  Future<void> _guardar() async {
    final datosValidos = _validateDatos();
    final sedesValidas = _validateSedes();
    final puestosValidos = _validatePuestos();

    if (!datosValidos || !sedesValidas || !puestosValidos) {
      return;
    }

    final clienteViewModel = context.read<ClienteViewModel>();

    final sedesViewModel = context.read<SedeViewModel>();

    final puestosViewModel = context.read<PuestoViewModel>();

    final clienteSedes = _selectedSedes.entries.map((entry) {
      final sede = sedesViewModel.items.firstWhere(
        (item) => item.id == entry.key,
      );

      return ClienteSede(
        id: widget.item?.sedes
            .where((item) => item.idSede == entry.key)
            .firstOrNull
            ?.id,
        idCliente: widget.item?.id,
        idSede: entry.key,
        sede: sede,
        tipoRelacion: entry.value,
        estado: true,
      );
    }).toList();

    final clientePuestos = _selectedPuestos.entries.map((entry) {
      final puesto = puestosViewModel.items.firstWhere(
        (item) => item.id == entry.key,
      );

      final anterior = widget.item?.puestos
          .where((item) => item.idPuesto == entry.key)
          .firstOrNull;

      return ClientePuesto(
        id: anterior?.id,
        idCliente: widget.item?.id,
        idPuesto: entry.key,
        puesto: puesto,
        fechaInicio: anterior?.fechaInicio,
        fechaFin: anterior?.fechaFin,
        estado: anterior?.estado ?? true,
        seccion: entry.value,
        observaciones: anterior?.observaciones,
      );
    }).toList();

    final cliente = Cliente(
      id: widget.item?.id,
      nombres: _nombresController.text.trim(),
      apellidos: _optionalValue(_apellidosController),
      apodo: _optionalValue(_apodoController),
      telefono: _optionalValue(_telefonoController),
      observaciones: _optionalValue(_observacionesController),
      estado: widget.item?.estado ?? true,
      sedes: clienteSedes,
      puestos: clientePuestos,
    );

    final ok = _isEditing
        ? await clienteViewModel.update(cliente)
        : await clienteViewModel.create(cliente);

    if (!mounted) {
      return;
    }

    AppToast.show(
      ok
          ? _isEditing
                ? 'Cliente actualizado correctamente.'
                : 'Cliente registrado correctamente.'
          : clienteViewModel.errorMessage ?? 'No se pudo guardar el cliente.',
      type: ok ? ToastType.success : ToastType.error,
    );

    if (ok) {
      Navigator.of(context).pop(true);
    }
  }

  String? _optionalValue(TextEditingController controller) {
    final value = controller.text.trim();

    return value.isEmpty ? null : value;
  }
}
