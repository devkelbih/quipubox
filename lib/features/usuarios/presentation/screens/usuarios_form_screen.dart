import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quipubox/features/usuarios/domain/entities/usuario.dart';
import 'package:quipubox/features/roles/presentation/viewmodels/roles_viewmodel.dart';
import 'package:quipubox/features/sedes/domain/entities/sede.dart';
import 'package:quipubox/features/usuarios/presentation/widgets/usuario_datos_form.dart';
import 'package:quipubox/features/usuarios/presentation/widgets/usuario_form_actions.dart';
import 'package:quipubox/features/usuarios/presentation/widgets/usuario_form_stepper.dart';
import 'package:quipubox/features/usuarios/presentation/widgets/usuario_roles_form.dart';
import 'package:quipubox/features/usuarios/presentation/widgets/usuario_sede_form.dart';

class UsuariosFormScreen extends StatefulWidget {
  final Usuario? usuario;

  const UsuariosFormScreen({
    super.key,
    this.usuario,
  });

  @override
  State<UsuariosFormScreen> createState() => _UsuariosFormScreenState();
}

class _UsuariosFormScreenState extends State<UsuariosFormScreen> {
  static const int _totalSteps = 3;

  int _currentStep = 0;

  final _formKey = GlobalKey<FormState>();

  final Set<int> _completedSteps = {};
  final Set<int> _errorSteps = {};

  Sede? _selectedSede;

  Set<int> _selectedRoleIds = {};

  late final TextEditingController _nombresController;
  late final TextEditingController _apellidosController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    _nombresController = TextEditingController(
      text: widget.usuario?.nombres ?? '',
    );

    _apellidosController = TextEditingController(
      text: widget.usuario?.apellidos ?? '',
    );

    _telefonoController = TextEditingController(
      text: widget.usuario?.telefono ?? '',
    );

    _emailController = TextEditingController(
      text: widget.usuario?.email ?? '',
    );

    _selectedSede = widget.usuario?.sede;

    _selectedRoleIds =
        widget.usuario?.roles.map((role) => role.id).toSet() ?? {};

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RolesViewModel>().load();
    });
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.usuario == null
              ? 'Nuevo usuario'
              : 'Editar usuario',
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            UsuarioFormStepper(
              currentStep: _currentStep,
              completedSteps: _completedSteps,
              errorSteps: _errorSteps,
              onStepTapped: _handleStepTapped,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStep(),
              ),
            ),

            UsuarioFormActions(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              onBack: _handleStepCancel,
              onContinue: _handleStepContinue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildDatosPersonales();

      case 1:
        return _buildSede();

      case 2:
        return _buildRoles();

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDatosPersonales() {
    return UsuarioDatosForm(
      nombresController: _nombresController,
      apellidosController: _apellidosController,
      telefonoController: _telefonoController,
      emailController: _emailController,
    );
  }

  Widget _buildSede() {
    return UsuarioSedeForm(
      selectedSede: _selectedSede,
      hasError: _errorSteps.contains(1),
      onChanged: (sede) {
        setState(() {
          _selectedSede = sede;

          _errorSteps.remove(1);
          _completedSteps.add(1);
        });
      },
    );
  }

  Widget _buildRoles() {
    return Consumer<RolesViewModel>(
      builder: (context, viewModel, _) {
        return UsuarioRolesForm(
          roles: viewModel.roles,
          selectedRoleIds: _selectedRoleIds,
          hasError: _errorSteps.contains(2),
          onChanged: (roleIds) {
            setState(() {
              _selectedRoleIds = roleIds;

              if (roleIds.isNotEmpty) {
                _errorSteps.remove(2);
                _completedSteps.add(2);
              } else {
                _completedSteps.remove(2);
              }
            });
          },
        );
      },
    );
  }

  void _handleStepContinue() {
    switch (_currentStep) {
      case 0:
        if (!_validateDatos()) {
          return;
        }
        break;

      case 1:
        if (!_validateSede()) {
          return;
        }
        break;

      case 2:
        if (!_validateRoles()) {
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
    // Permite volver a cualquier paso ya alcanzado.
    if (step <= _currentStep) {
      setState(() {
        _currentStep = step;
      });

      return;
    }

    // Para avanzar, primero validamos el paso actual.
    switch (_currentStep) {
      case 0:
        if (!_validateDatos()) {
          return;
        }
        break;

      case 1:
        if (!_validateSede()) {
          return;
        }
        break;

      case 2:
        if (!_validateRoles()) {
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

  bool _validateSede() {
    final isValid = _selectedSede != null;

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

  bool _validateRoles() {
    final isValid = _selectedRoleIds.isNotEmpty;

    setState(() {
      if (isValid) {
        _completedSteps.add(2);
        _errorSteps.remove(2);
      } else {
        _completedSteps.remove(2);
        _errorSteps.add(2);
      }
    });

    return isValid;
  }

  void _guardar() {
    final datosValidos = _validateDatos();
    final sedeValida = _validateSede();
    final rolesValidos = _validateRoles();

    if (!datosValidos || !sedeValida || !rolesValidos) {
      return;
    }

    // Aquí irá posteriormente la lógica para guardar.
  }
}