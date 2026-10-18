import 'package:quipubox/core/state/base_state_viewmodel.dart';

import '../../domain/entities/lugar_operativo.dart';
import '../../domain/usecases/change_lugar_operativo_status.dart';
import '../../domain/usecases/create_lugar_operativo.dart';
import '../../domain/usecases/get_lugares_operativos.dart';
import '../../domain/usecases/update_lugar_operativo.dart';

class LugarOperativoViewModel extends BaseStateViewModel {
  final GetLugaresOperativosUseCase getItemsUseCase;
  final CreateLugarOperativoUseCase createUseCase;
  final UpdateLugarOperativoUseCase updateUseCase;
  final ChangeLugarOperativoStatusUseCase changeStatusUseCase;

  LugarOperativoViewModel({
    required this.getItemsUseCase,
    required this.createUseCase,
    required this.updateUseCase,
    required this.changeStatusUseCase,
  });

  List<LugarOperativo> items = [];

  Future<void> load() async {
    final result = await run<List<LugarOperativo>>(
      state: ViewModelActionState.loading,
      action: getItemsUseCase.call,
    );

    if (result != null) {
      items = result;
      notifyListeners();
    }
  }

  Future<bool> create(LugarOperativo lugarOperativo) async {
    final result = await run<LugarOperativo>(
      state: ViewModelActionState.saving,
      action: () => createUseCase(lugarOperativo),
    );

    if (result == null) return false;

    items.add(result);
    notifyListeners();
    return true;
  }

  Future<bool> update(LugarOperativo lugarOperativo) async {
    final result = await run<LugarOperativo>(
      state: ViewModelActionState.saving,
      action: () => updateUseCase(lugarOperativo),
    );

    if (result == null) return false;

    final index = items.indexWhere((e) => e.id == result.id);

    if (index != -1) {
      items[index] = result;
    }

    notifyListeners();
    return true;
  }

  Future<bool> changeStatus({
    required int id,
    required bool estado,
  }) async {
    final confirmedStatus = await run<bool>(
      state: ViewModelActionState.changingStatus,
      action: () => changeStatusUseCase(
        id: id,
        estado: estado,
      ),
    );

    if (confirmedStatus == null) return false;

    final index = items.indexWhere((e) => e.id == id);

    if (index != -1) {
      items[index] = items[index].copyWith(
        estado: confirmedStatus,
      );
    }

    notifyListeners();
    return true;
  }
}