import '../../../../core/session/current_session.dart';
import '../viewmodels/auth_viewmodel.dart';

class AuthCurrentSession implements CurrentSession {
  final AuthViewModel authViewModel;

  AuthCurrentSession(this.authViewModel);

  @override
  int? get currentUserId => authViewModel.currentUserId;

  @override
  int? get currentCompanyId => authViewModel.currentCompanyId;

  @override
  int? get currentSedeId => authViewModel.currentSedeId;
}