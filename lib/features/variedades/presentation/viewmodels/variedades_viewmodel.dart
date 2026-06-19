import 'package:quipubox/core/state/base_state_viewmodel.dart';
import 'package:quipubox/features/frutas/domain/entities/fruta.dart';
import 'package:quipubox/features/frutas/domain/usecases/get_frutas.dart';
import 'package:quipubox/features/variedades/domain/usecases/change_variedad_status.dart';

import '../../domain/entities/variedad.dart';
import '../../domain/usecases/create_variedad.dart';
import '../../domain/usecases/get_variedades.dart';
import '../../domain/usecases/get_variedades_by_fruta.dart';
import '../../domain/usecases/update_variedad.dart';

class VariedadViewModel extends BaseStateViewModel {
  final GetVariedadesUseCase getItemsUseCase;
  final GetVariedadesByFrutaUseCase getByFrutaUseCase;
  final GetFrutasUseCase getFrutasUseCase;
  final CreateVariedadUseCase createUseCase;
  final UpdateVariedadUseCase updateUseCase;
  final ChangeVariedadStatusUseCase changeStatusUseCase;

  VariedadViewModel({
    required this.getItemsUseCase,
    required this.getByFrutaUseCase,
    required this.getFrutasUseCase,
    required this.createUseCase,
    required this.updateUseCase,
    required this.changeStatusUseCase,
  });

  List<Variedad> items = [];
  List<Fruta> frutas = [];

  Future<void> load() async {
    final result = await run<List<Variedad>>(
      state: ViewModelActionState.loading,
      action: getItemsUseCase.call,
    );

    if (result != null) {
      items = result;
      notifyListeners();
    }
  }

  Future<void> loadFormData() async {
    final result = await run<List<Fruta>>(
      state: ViewModelActionState.loading,
      action: getFrutasUseCase.call,
    );

    if (result != null) {
      frutas = result;
      notifyListeners();
    }
  }

  Future<void> loadByFruta(int frutaId) async {
    final result = await run<List<Variedad>>(
      state: ViewModelActionState.loading,
      action: () => getByFrutaUseCase(frutaId),
    );

    if (result != null) {
      items = result;
      notifyListeners();
    }
  }

  Future<bool> create(Variedad variedad) async {
    final result = await run<Variedad>(
      state: ViewModelActionState.saving,
      action: () => createUseCase(variedad),
    );

    if (result == null) return false;

    items.add(result);
    notifyListeners();
    return true;
  }

  Future<bool> update(Variedad variedad) async {
    final result = await run<Variedad>(
      state: ViewModelActionState.saving,
      action: () => updateUseCase(variedad),
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
    final result = await run<Variedad>(
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
