import '../../../../core/network/network_checker.dart';
import '../../../../core/state/safe_change_notifier.dart';
import '../../data/models/lugar_operativo_request_model.dart';
import '../../domain/entities/lugar_operativo.dart';
import '../../domain/usecases/create_lugar_operativo.dart';
import '../../domain/usecases/delete_lugar_operativo.dart';
import '../../domain/usecases/get_lugares_operativos.dart';
import '../../domain/usecases/update_lugar_operativo.dart';

class LugarOperativoViewModel extends DisposeSafeNotifier {
  final GetLugaresOperativosUseCase getItemsUseCase;
  final CreateLugarOperativoUseCase createUseCase;
  final UpdateLugarOperativoUseCase updateUseCase;
  final DeleteLugarOperativoUseCase deleteUseCase;
  final NetworkChecker networkChecker;

  LugarOperativoViewModel({
    required this.getItemsUseCase,
    required this.createUseCase,
    required this.updateUseCase,
    required this.deleteUseCase,
    required this.networkChecker,
  });

  List<LugarOperativo> items = [];

  bool isLoading = false;
  bool isSaving = false;
  bool isDeleting = false;
  String? errorMessage;

  int get total => items.length;

  int get activos => items.where((e) => e.estado).length;

  int get inactivos => items.where((e) => !e.estado).length;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      items = await getItemsUseCase();
    } on Object catch (e) {
      errorMessage = _clean(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> save({
    int? id,
    required LugarOperativoRequestModel request,
  }) async {
    if (!await networkChecker.hasInternet()) {
      errorMessage = 'No hay conexión a internet. No se puede guardar.';
      notifyListeners();
      return false;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (id == null) {
        await createUseCase(request);
      } else {
        await updateUseCase(id, request: request);
      }

      await load();
      return true;
    } on Object catch (e) {
      errorMessage = _clean(e);
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> remove(int id) async {
    if (!await networkChecker.hasInternet()) {
      errorMessage = 'No hay conexión a internet. No se puede desactivar.';
      notifyListeners();
      return false;
    }

    isDeleting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await deleteUseCase(id);
      await load();
      return true;
    } on Object catch (e) {
      errorMessage = _clean(e);
      return false;
    } finally {
      isDeleting = false;
      notifyListeners();
    }
  }

  String _clean(Object e) => e
      .toString()
      .replaceFirst('Exception: ', '')
      .replaceFirst('AppException: ', '');
}