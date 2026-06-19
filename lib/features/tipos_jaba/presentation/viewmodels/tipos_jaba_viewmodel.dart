import 'package:quipubox/core/state/base_state_viewmodel.dart';
import 'package:quipubox/features/tipos_jaba/domain/usecases/change_tipo_jaba_status.dart';

import '../../domain/entities/tipos_jaba.dart';
import '../../domain/usecases/create_tipos_jaba.dart';
import '../../domain/usecases/get_tipos_jaba.dart';
import '../../domain/usecases/update_tipos_jaba.dart';

class TipoJabaViewModel extends BaseStateViewModel {
  final GetTiposJabaUseCase getItemsUseCase;
  final CreateTipoJabaUseCase createUseCase;
  final UpdateTipoJabaUseCase updateUseCase;
  final ChangeTipoJabaStatusUseCase changeStatusUseCase;
  TipoJabaViewModel({
    required this.getItemsUseCase,
    required this.createUseCase,
    required this.updateUseCase,
    required this.changeStatusUseCase,
  });
  List<TipoJaba> items = [];

  Future<void> load() async {
    final result = await run<List<TipoJaba>>(
      state: ViewModelActionState.loading,
      action: getItemsUseCase.call,
    );

    if (result != null) {
      items = result;
      notifyListeners();
    }
  }

  Future<bool> create(TipoJaba tipoJaba ) async {
    final result = await run<TipoJaba>(
      state: ViewModelActionState.saving,
      action: () => createUseCase(tipoJaba),
    );

    if (result == null) return false;

    items.add(result);
    notifyListeners();
    return true;
  }

  Future<bool> update(TipoJaba tipoJaba) async {
    final result = await run<TipoJaba>(
      state: ViewModelActionState.saving,
      action: () => updateUseCase(tipoJaba),
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
    final result = await run<TipoJaba>(
      state: ViewModelActionState.changingStatus,
      action: () => changeStatusUseCase(id: id, estado: estado),
    );

    if (result == null) return false;

    final index = items.indexWhere((e) => e.id == result.id);

    if (index != -1) {
      items[index] = result;
    }

    notifyListeners();
    return true;
  }
}
