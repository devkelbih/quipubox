import 'package:quipubox/core/state/base_state_viewmodel.dart';

import '../../../roles/domain/entities/role.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/usecases/add_usuario_role.dart';
import '../../domain/usecases/change_usuario_status.dart';
import '../../domain/usecases/create_usuario.dart';
import '../../domain/usecases/get_usuarios.dart';
import '../../domain/usecases/remove_usuario_role.dart';
import '../../domain/usecases/update_usuario.dart';

class UsuarioViewModel extends BaseStateViewModel {
  final GetUsuariosUseCase getItemsUseCase;
  final CreateUsuarioUseCase createUseCase;
  final UpdateUsuarioUseCase updateUseCase;
  final ChangeUsuarioStatusUseCase changeStatusUseCase;
  final AddUsuarioRoleUseCase addRoleUseCase;
  final RemoveUsuarioRoleUseCase removeRoleUseCase;

  UsuarioViewModel({
    required this.getItemsUseCase,
    required this.createUseCase,
    required this.updateUseCase,
    required this.changeStatusUseCase,
    required this.addRoleUseCase,
    required this.removeRoleUseCase,
  });

  List<Usuario> items = [];

  /// ID del rol que actualmente está siendo agregado o eliminado.
  ///
  /// La UI utiliza este valor para mostrar el indicador de progreso
  /// únicamente sobre la acción correspondiente.
  int? processingRoleId;

  Future<void> load() async {
    final result = await run<List<Usuario>>(
      state: ViewModelActionState.loading,
      action: getItemsUseCase.call,
    );

    if (result != null) {
      items = result;
      notifyListeners();
    }
  }

  Future<bool> create(Usuario usuario) async {
    final result = await run<Usuario>(
      state: ViewModelActionState.saving,
      action: () => createUseCase(usuario),
    );

    if (result == null) return false;

    items.add(result);
    notifyListeners();

    return true;
  }

  Future<bool> update(Usuario usuario) async {
    final result = await run<Usuario>(
      state: ViewModelActionState.saving,
      action: () => updateUseCase(usuario),
    );

    if (result == null) return false;

    final index = items.indexWhere((e) => e.id == result.id);

    if (index != -1) {
      items[index] = result;
    }

    notifyListeners();

    return true;
  }

  Future<bool> changeStatus({required int id, required bool estado}) async {
    final confirmedStatus = await run<bool>(
      state: ViewModelActionState.changingStatus,
      action: () => changeStatusUseCase(id: id, estado: estado),
    );

    if (confirmedStatus == null) return false;

    final index = items.indexWhere((e) => e.id == id);

    if (index != -1) {
      items[index] = items[index].copyWith(estado: confirmedStatus);
    }

    notifyListeners();

    return true;
  }

  Future<bool> addRole({required int usuarioId, required Role role}) async {
    processingRoleId = role.id;
    notifyListeners();

    final success = await runBool(
      state: ViewModelActionState.saving,
      action: () => addRoleUseCase(usuarioId: usuarioId, roleId: role.id),
    );

    if (!success) {
      processingRoleId = null;
      notifyListeners();
      return false;
    }

    final index = items.indexWhere((e) => e.id == usuarioId);

    if (index != -1) {
      final usuario = items[index];

      final alreadyAssigned = usuario.roles.any((item) => item.id == role.id);

      if (!alreadyAssigned) {
        items[index] = usuario.copyWith(roles: [...usuario.roles, role]);
      }
    }

    processingRoleId = null;
    notifyListeners();

    return true;
  }

  Future<bool> removeRole({required int usuarioId, required int roleId}) async {
    processingRoleId = roleId;
    notifyListeners();

    final success = await runBool(
      state: ViewModelActionState.saving,
      action: () => removeRoleUseCase(usuarioId: usuarioId, roleId: roleId),
    );

    if (!success) {
      processingRoleId = null;
      notifyListeners();
      return false;
    }

    final index = items.indexWhere((e) => e.id == usuarioId);

    if (index != -1) {
      final usuario = items[index];

      items[index] = usuario.copyWith(
        roles: usuario.roles.where((role) => role.id != roleId).toList(),
      );
    }

    processingRoleId = null;
    notifyListeners();

    return true;
  }
}
