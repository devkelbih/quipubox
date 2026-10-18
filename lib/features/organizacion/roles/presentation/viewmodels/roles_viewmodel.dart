import 'package:quipubox/core/state/base_state_viewmodel.dart';

import '../../domain/entities/role.dart';
import '../../domain/usecases/get_roles.dart';

class RolesViewModel extends BaseStateViewModel {
  final GetRolesUseCase getRolesUseCase;

  RolesViewModel({required this.getRolesUseCase});

  List<Role> roles = [];

  Future<void> load() async {
    final result = await run<List<Role>>(
      state: ViewModelActionState.loading,
      action: getRolesUseCase.call,
    );

    if (result != null) {
      roles = result;
      notifyListeners();
    }
  }
}
