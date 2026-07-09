import 'package:quipubox/core/state/base_state_viewmodel.dart';
import 'package:quipubox/features/frutas/domain/usecases/change_fruta_status.dart';

import '../../domain/entities/fruta.dart';
import '../../domain/usecases/create_fruta.dart';
import '../../domain/usecases/get_frutas.dart';
import '../../domain/usecases/update_fruta.dart';

class FrutaViewModel extends BaseStateViewModel {
  final GetFrutasUseCase getItemsUseCase;
  final CreateFrutaUseCase createUseCase;
  final UpdateFrutaUseCase updateUseCase;
  final ChangeFrutaStatusUseCase changeStatusUseCase;

  FrutaViewModel({
    required this.getItemsUseCase,
    required this.createUseCase,
    required this.updateUseCase,
    required this.changeStatusUseCase,
  });

  List<Fruta> items = [];

  Future<void> load() async {
    final result = await run<List<Fruta>>(
      state: ViewModelActionState.loading,
      action: getItemsUseCase.call,
    );

    if (result != null) {
      items = result;
      notifyListeners();
    }
  }

  Future<bool> create(Fruta fruta) async {
    final result = await run<Fruta>(
      state: ViewModelActionState.saving,
      action: () => createUseCase(fruta),
    );

    if (result == null) return false;

    items.add(result);
    notifyListeners();
    return true;
  }

  Future<bool> update(Fruta fruta) async {
    final result = await run<Fruta>(
      state: ViewModelActionState.saving,
      action: () => updateUseCase(fruta),
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
