import 'package:quipubox/core/state/base_state_viewmodel.dart';
import 'package:quipubox/features/puestos/domain/usecases/change_puesto_status.dart';

import '../../domain/entities/puesto.dart';
import '../../domain/usecases/create_puesto.dart';
import '../../domain/usecases/get_puestos.dart';
import '../../domain/usecases/update_puesto.dart';

class PuestoViewModel extends BaseStateViewModel {
  final GetPuestosUseCase getItemsUseCase;
  final CreatePuestoUseCase createUseCase;
  final UpdatePuestoUseCase updateUseCase;
  final ChangePuestoStatusUseCase changeStatusUseCase;

  PuestoViewModel({
    required this.getItemsUseCase,
    required this.createUseCase,
    required this.updateUseCase,
    required this.changeStatusUseCase,
  });

  List<Puesto> items = [];

  Future<void> load() async {
    final result = await run<List<Puesto>>(
      state: ViewModelActionState.loading,
      action: getItemsUseCase.call,
    );

    if (result != null) {
      items = result;
      notifyListeners();
    }
  }

  Future<bool> create(Puesto puesto) async {
    final result = await run<Puesto>(
      state: ViewModelActionState.saving,
      action: () => createUseCase(puesto),
    );

    if (result == null) return false;

    items.add(result);
    notifyListeners();
    return true;
  }

  Future<bool> update(Puesto puesto) async {
    final result = await run<Puesto>(
      state: ViewModelActionState.saving,
      action: () => updateUseCase(puesto),
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
}
