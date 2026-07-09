import 'package:quipubox/core/state/base_state_viewmodel.dart';
import 'package:quipubox/features/calidades/domain/usecases/change_calidad_status.dart';

import '../../domain/entities/calidad.dart';
import '../../domain/usecases/create_calidad.dart';
import '../../domain/usecases/get_calidades.dart';
import '../../domain/usecases/update_calidad.dart';

class CalidadViewModel extends BaseStateViewModel {
  final GetCalidadesUseCase getItemsUseCase;
  final CreateCalidadUseCase createUseCase;
  final UpdateCalidadUseCase updateUseCase;
  final ChangeCalidadStatusUseCase changeStatusUseCase;

  CalidadViewModel({
    required this.getItemsUseCase,
    required this.createUseCase,
    required this.updateUseCase,
    required this.changeStatusUseCase,
  });

  List<Calidad> items = [];

  Future<void> load() async {
    final result = await run<List<Calidad>>(
      state: ViewModelActionState.loading,
      action: getItemsUseCase.call,
    );

    if (result != null) {
      items = result;
      notifyListeners();
    }
  }

  Future<bool> create(Calidad calidad) async {
    final result = await run<Calidad>(
      state: ViewModelActionState.saving,
      action: () => createUseCase(calidad),
    );

    if (result == null) return false;

    items.add(result);
    notifyListeners();
    return true;
  }

  Future<bool> update(Calidad calidad) async {
    final result = await run<Calidad>(
      state: ViewModelActionState.saving,
      action: () => updateUseCase(calidad),
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
