import 'package:quipubox/core/state/base_state_viewmodel.dart';
import 'package:quipubox/features/clientes/domain/entities/cliente.dart';

import '../../domain/usecases/create_cliente.dart';
import '../../domain/usecases/change_cliente_estado.dart';
import '../../domain/usecases/get_clientes.dart';
import '../../domain/usecases/update_cliente.dart';

class ClienteViewModel extends BaseStateViewModel {
  final GetClientesUseCase getItemsUseCase;
  final CreateClienteUseCase createUseCase;
  final UpdateClienteUseCase updateUseCase;
  final ChangeClienteEstadoUseCase changeStatusUseCase;
  ClienteViewModel({
    required this.getItemsUseCase,
    required this.createUseCase,
    required this.updateUseCase,
    required this.changeStatusUseCase,
  });
  List<Cliente> items = [];

  Future<void> load() async {
    final result = await run<List<Cliente>>(
      action: getItemsUseCase.call,
      state: ViewModelActionState.loading,
    );
    if (result != null) {
      items = result;
      notifyListeners();
    }
  }

  Future<bool> create(Cliente cliente) async {
    final result = await run<Cliente>(
      action: () => createUseCase(cliente),
      state: ViewModelActionState.saving,
    );
    if (result == null) return false;
    items.add(result);
    notifyListeners();
    return true;
  }

  Future<bool> update(Cliente cliente) async {
    final result = await run<Cliente>(
      action: () => updateUseCase(cliente),
      state: ViewModelActionState.saving,
    );
    if (result == null) return false;
    final index = items.indexWhere((element) => element.id == result.id);
    if (index != -1) {
      items[index] = result;
      notifyListeners();
    }
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
}
