import '../../../../core/network/network_checker.dart';
import '../../../../core/state/dispose_safe_notifier.dart';
import '../../data/models/usuario_request_model.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/usecases/create_usuario.dart';
import '../../domain/usecases/delete_usuario.dart';
import '../../domain/usecases/get_usuarios.dart';
import '../../domain/usecases/update_usuario.dart';
class UsuarioViewModel extends DisposeSafeNotifier {
  final GetUsuariosUseCase getItemsUseCase; final CreateUsuarioUseCase createUseCase; final UpdateUsuarioUseCase updateUseCase; final DeleteUsuarioUseCase deleteUseCase; final NetworkChecker networkChecker;
  UsuarioViewModel({required this.getItemsUseCase, required this.createUseCase, required this.updateUseCase, required this.deleteUseCase, required this.networkChecker});
  List<Usuario> items = []; bool isLoading = false; bool isSaving = false; bool isDeleting = false; String? errorMessage;
  Future<void> load() async { isLoading = true; errorMessage = null; notifyListeners(); try { items = await getItemsUseCase(); } on Object catch (e) { errorMessage = _clean(e); } finally { isLoading = false; notifyListeners(); } }
  Future<bool> save({int? id, required UsuarioRequestModel request}) async { if (!await networkChecker.hasInternet()) { errorMessage = 'No hay conexión a internet. No se puede guardar.'; notifyListeners(); return false; } isSaving = true; errorMessage = null; notifyListeners(); try { if (id == null) { await createUseCase(request); } else { await updateUseCase(id, request: request); } await load(); return true; } on Object catch (e) { errorMessage = _clean(e); return false; } finally { isSaving = false; notifyListeners(); } }
  Future<bool> remove(int id) async { if (!await networkChecker.hasInternet()) { errorMessage = 'No hay conexión a internet. No se puede desactivar.'; notifyListeners(); return false; } isDeleting = true; errorMessage = null; notifyListeners(); try { await deleteUseCase(id); await load(); return true; } on Object catch (e) { errorMessage = _clean(e); return false; } finally { isDeleting = false; notifyListeners(); } }
  String _clean(Object e) => e.toString().replaceFirst('Exception: ', '').replaceFirst('AppException: ', '');
}
