import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/state/safe_change_notifier.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/usecases/get_current_session_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

class AuthViewModel extends DisposeSafeNotifier {
  final GetCurrentSessionUseCase getCurrentSessionUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final LogoutUseCase logoutUseCase;
  final GetProfileUseCase getProfileUseCase;

  StreamSubscription<AuthState>? _authSubscription;
  bool _handlingAuthChange = false;

  AuthViewModel({
    required this.getCurrentSessionUseCase,
    required this.loginWithGoogleUseCase,
    required this.logoutUseCase,
    required this.getProfileUseCase,
  }) {
    initialize();
  }

  AppUser? user;

  bool isLoading = true;
  bool isSaving = false;
  bool isDeleting = false;

  String? errorMessage;

  bool get hasSupabaseSession => getCurrentSessionUseCase() != null;

  bool get isAuthenticated => hasSupabaseSession && user != null;

  int? get currentUserId => user?.id;

  int? get currentCompanyId => user?.idEmpresa;

  List<int> get currentRoleIds => user?.roleIds ?? [];

  List<String> get currentRoleNames => user?.roleNames ?? [];

  int? get currentSedeId => user?.idSede;

  bool hasRoleId(int roleId) {
    return user?.hasRoleId(roleId) ?? false;
  }

  bool hasRoleName(String roleName) {
    return user?.hasRoleName(roleName) ?? false;
  }

  Future<void> initialize() async {
    debugPrint('AUTH INIT START');

    try {
      _listenAuthChanges();

      final session = getCurrentSessionUseCase();

      debugPrint('SESSION: ${session == null ? 'NO' : 'SI'}');

      if (session == null) {
        user = null;
        errorMessage = null;
        return;
      }

      final ok = await loadProfile();

      if (!ok) {
        await _safeSignOut();
      }
    } catch (error) {
      debugPrint('AUTH INIT ERROR: $error');
      user = null;
      errorMessage = _clean(error);
    } finally {
      debugPrint('AUTH INIT FINISH');
      _finishLoading();
    }
  }

  void _listenAuthChanges() {
    _authSubscription?.cancel();

    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) async {
        if (_handlingAuthChange) return;

        _handlingAuthChange = true;

        try {
          if (data.session == null) {
            user = null;
            errorMessage = null;
            _finishLoading();
            return;
          }

          final ok = await loadProfile();

          if (!ok && hasSupabaseSession) {
            await _safeSignOut();
          }
        } catch (error) {
          user = null;
          errorMessage = _clean(error);
          _finishLoading();
        } finally {
          _handlingAuthChange = false;
        }
      },
    );
  }

  Future<bool> loadProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      user = await getProfileUseCase().timeout(
        const Duration(seconds: 20),
      );

      return true;
    } on TimeoutException {
      user = null;
      errorMessage =
          'La validación de sesión tardó demasiado. Revisa internet e intenta nuevamente.';
      return false;
    } on Object catch (error) {
      user = null;
      errorMessage = _clean(error);
      return false;
    } finally {
      _finishLoading();
    }
  }

  Future<bool> loginWithGoogle() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await loginWithGoogleUseCase();
      return true;
    } on Object catch (error) {
      errorMessage = _clean(error);
      return false;
    } finally {
      _finishLoading();
    }
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    try {
      await logoutUseCase();
      user = null;
      errorMessage = null;
    } on Object catch (error) {
      errorMessage = _clean(error);
    } finally {
      _finishLoading();
    }
  }

  Future<void> _safeSignOut() async {
    try {
      await logoutUseCase();
    } on Object catch (error) {
      debugPrint('No se pudo cerrar sesión de forma segura: $error');
    } finally {
      user = null;
      _finishLoading();
    }
  }

  void _finishLoading() {
    isLoading = false;
    notifyListeners();
  }

  String _clean(Object error) {
    if (error is AppException) {
      return error.message;
    }

    return error.toString();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}