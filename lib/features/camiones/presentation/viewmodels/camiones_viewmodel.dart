import 'package:quipubox/core/state/base_state_viewmodel.dart';
import 'package:quipubox/features/camiones/domain/usecases/change_camion_status.dart';
import '../../domain/entities/camion.dart';
import '../../domain/usecases/create_camion.dart';
import '../../domain/usecases/get_camiones.dart';
import '../../domain/usecases/update_camion.dart';

class CamionViewModel extends BaseStateViewModel {
  final GetCamionesUseCase getItemsUseCase;
  final CreateCamionUseCase createUseCase;
  final UpdateCamionUseCase updateUseCase;
  final ChangeCamionStatusUseCase changeStatusUseCase;
  CamionViewModel({
    required this.getItemsUseCase,
    required this.createUseCase,
    required this.updateUseCase,
    required this.changeStatusUseCase,
  });
  final List<Camion> items = [];

  Future<void> load() async {
    final result = await run<List<Camion>>(
      state: ViewModelActionState.loading,
      action: getItemsUseCase.call,
    );

    if (result != null) {
      items
        ..clear()
        ..addAll(result);
      notifyListeners();
    }
  }

  Future<bool> create(Camion camion) async {
    final result = await run<Camion>(
      state: ViewModelActionState.saving,
      action: () => createUseCase(camion),
    );

    if (result == null) return false;

    items.add(result);
    notifyListeners();
    return true;
  }

  Future<bool> update(Camion camion) async {
    final result = await run<Camion>(
      state: ViewModelActionState.saving,
      action: () => updateUseCase(camion),
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
