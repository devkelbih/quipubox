import '../../../../core/network/network_checker.dart';
import '../../../../core/state/dispose_safe_notifier.dart';
import '../../data/models/sede_request_model.dart';
import '../../domain/entities/sede.dart';
import '../../domain/usecases/create_sede.dart';
import '../../domain/usecases/delete_sede.dart';
import '../../domain/usecases/get_sedes.dart';
import '../../domain/usecases/update_sede.dart';
class SedeViewModel extends DisposeSafeNotifier {
  final GetSedesUseCase getItemsUseCase; final CreateSedeUseCase createUseCase; final UpdateSedeUseCase updateUseCase; final DeleteSedeUseCase deleteUseCase; final NetworkChecker networkChecker;
  SedeViewModel({required this.getItemsUseCase, required this.createUseCase, required this.updateUseCase, required this.deleteUseCase, required this.networkChecker});
  List<Sede> items = []; bool isLoading = false; bool isSaving = false; bool isDeleting = false; String? errorMessage;
  Future<void> load() async { isLoading = true; errorMessage = null; notifyListeners(); try { items = await getItemsUseCase(); } on Object catch (e) { errorMessage = _clean(e); } finally { isLoading = false; notifyListeners(); } }
  Future<bool> save({int? id, required SedeRequestModel request}) async { if (!await networkChecker.hasInternet()) { errorMessage = 'No hay conexión a internet. No se puede guardar.'; notifyListeners(); return false; } isSaving = true; errorMessage = null; notifyListeners(); try { if (id == null) { await createUseCase(request); } else { await updateUseCase(id, request: request); } await load(); return true; } on Object catch (e) { errorMessage = _clean(e); return false; } finally { isSaving = false; notifyListeners(); } }
  Future<bool> remove(int id) async { if (!await networkChecker.hasInternet()) { errorMessage = 'No hay conexión a internet. No se puede desactivar.'; notifyListeners(); return false; } isDeleting = true; errorMessage = null; notifyListeners(); try { await deleteUseCase(id); await load(); return true; } on Object catch (e) { errorMessage = _clean(e); return false; } finally { isDeleting = false; notifyListeners(); } }
  String _clean(Object e) => e.toString().replaceFirst('Exception: ', '').replaceFirst('AppException: ', '');
}
