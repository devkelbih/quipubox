import '../../../../core/state/safe_change_notifier.dart';
import '../../domain/entities/role.dart';
import '../../domain/usecases/get_roles.dart';

class RolesViewModel extends DisposeSafeNotifier {
  final GetRolesUseCase getRolesUseCase;
  RolesViewModel(this.getRolesUseCase);
  List<Role> items = [];
  bool isLoading = false;
  String? errorMessage;
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      items = await getRolesUseCase();
    } on Object catch (e) {
      errorMessage = e.toString().replaceFirst('AppException: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
