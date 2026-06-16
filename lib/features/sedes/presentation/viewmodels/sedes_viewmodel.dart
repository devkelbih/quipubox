import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/state/dispose_safe_notifier.dart';
import '../../domain/entities/sede.dart';
import '../../domain/usecases/change_sede_status.dart';
import '../../domain/usecases/create_sede.dart';
import '../../domain/usecases/get_sedes.dart';
import '../../domain/usecases/update_sede.dart';

class SedeViewModel extends DisposeSafeNotifier {
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

  bool isLoading = false;
  bool isSaving = false;
  bool isDeleting = false;

  String? errorMessage;

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

  Future<bool> create(Sede sede) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      final creado = await createUseCase(sede);
      items.add(creado);
      return true;
    } on Object catch (e) {
      errorMessage = _clean(e);
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> update(Sede sede) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      final actualizado = await updateUseCase(sede);
      final index = items.indexWhere((e) => e.id == actualizado.id);

      if (index != -1) {
        items[index] = actualizado;
      }

      return true;
    } on Object catch (e) {
      errorMessage = _clean(e);
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> changeStatus({
    required int id,
    required bool estado,
  }) async {
    isDeleting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final updated = await changeStatusUseCase(
        id: id,
        estado: estado,
      );

      final index = items.indexWhere((e) => e.id == updated.id);

      if (index != -1) {
        items[index] = updated;
      }

      return true;
    } on Object catch (e) {
      errorMessage = _clean(e);
      return false;
    } finally {
      isDeleting = false;
      notifyListeners();
    }
  }

  String _clean(Object e) {
    if (e is AppException) return e.message;
    return e.toString();
  }
}