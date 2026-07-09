import 'package:quipubox/core/state/base_state_viewmodel.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/usecases/create_usuario.dart';
import '../../domain/usecases/change_usuario_status.dart';
import '../../domain/usecases/get_usuarios.dart';
import '../../domain/usecases/update_usuario.dart';

class UsuarioViewModel extends BaseStateViewModel {
  final GetUsuariosUseCase getItemsUseCase;
  final CreateUsuarioUseCase createUseCase;
  final UpdateUsuarioUseCase updateUseCase;
  final ChangeUsuarioStatusUseCase changeStatusUseCase;
  UsuarioViewModel({
    required this.getItemsUseCase,
    required this.createUseCase,
    required this.updateUseCase,
    required this.changeStatusUseCase,
  });
  List<Usuario> items = [];
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
    if (result != null) {
      await load();
      return true;
    }
    return false;
  }

  Future<bool> update(Usuario usuario) async {
    final result = await run<Usuario>(
      state: ViewModelActionState.saving,
      action: () => updateUseCase(usuario),
    );
    if (result != null) {
      await load();
      return true;
    }
    return false;
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
}
