import '../../../../core/state/base_state_viewmodel.dart';
import '../../domain/entities/sede.dart';
import '../../domain/usecases/change_sede_status.dart';
import '../../domain/usecases/create_sede.dart';
import '../../domain/usecases/get_sedes.dart';
import '../../domain/usecases/update_sede.dart';

class SedeViewModel extends BaseStateViewModel {
  final GetSedesUseCase getItemsUseCase;
  final CreateSedeUseCase createUseCase;
  final UpdateSedeUseCase updateUseCase;
  final ChangeSedeStatusUseCase changeStatusUseCase;

  SedeViewModel({
    required this.getItemsUseCase,
    required this.createUseCase,
    required this.updateUseCase,
    required this.changeStatusUseCase,
  });

  List<Sede> items = [];

  Future<void> load() async {
    final result = await run<List<Sede>>(
      state: ViewModelActionState.loading,
      action: getItemsUseCase.call,
    );

    if (result != null) {
      items = result;
      notifyListeners();
    }
  }

  Future<bool> create(Sede sede) async {
    final result = await run<Sede>(
      state: ViewModelActionState.saving,
      action: () => createUseCase(sede),
    );

    if (result == null) return false;

    items.add(result);
    notifyListeners();
    return true;
  }

  Future<bool> update(Sede sede) async {
    final result = await run<Sede>(
      state: ViewModelActionState.saving,
      action: () => updateUseCase(sede),
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
