import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:quipubox/core/state/base_state_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/usecases/clear_cached_user_usecase.dart';
import '../../domain/usecases/get_cached_user_usecase.dart';
import '../../domain/usecases/get_current_session_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/save_cached_user_usecase.dart';

class AuthViewModel extends BaseStateViewModel {
  final GetCurrentSessionUseCase getCurrentSessionUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final LogoutUseCase logoutUseCase;
  final GetProfileUseCase getProfileUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;
  final SaveCachedUserUseCase saveCachedUserUseCase;
  final ClearCachedUserUseCase clearCachedUserUseCase;

  StreamSubscription<AuthState>? _authSubscription;

  bool _isInitializing = false;
  bool _handlingAuthChange = false;

  AuthViewModel({
    required this.getCurrentSessionUseCase,
    required this.loginWithGoogleUseCase,
    required this.logoutUseCase,
    required this.getProfileUseCase,
    required this.getCachedUserUseCase,
    required this.saveCachedUserUseCase,
    required this.clearCachedUserUseCase,
  }) {
    initialize();
  }
  // Usuario actualmente autenticado.
  AppUser? user;

  // Información rápida de autenticación.
  bool get hasSupabaseSession => getCurrentSessionUseCase() != null;
  bool get isAuthenticated => hasSupabaseSession;
  bool get hasProfile => user != null;

  // Datos frecuentes del usuario para evitar null-checks repetidos.
  int? get currentUserId => user?.id;
  int? get currentCompanyId => user?.idEmpresa;
  int? get currentSedeId => user?.idSede;

  // Estados específicos de UI.
  bool get isCheckingSession => isLoading;
  bool get isSigningIn => isSaving;
  bool get isSigningOut => isDeleting;
  bool get isAuthBusy => isLoading || isSaving || isDeleting;

  // Roles del usuario.
  List<int> get currentRoleIds => user?.roleIds ?? [];
  List<String> get currentRoleNames => user?.roleNames ?? [];

  bool hasRoleId(int roleId) {
    return user?.hasRoleId(roleId) ?? false;
  }

  bool hasRoleName(String roleName) {
    return user?.hasRoleName(roleName) ?? false;
  }

  Future<void> initialize() async {
    if (_isInitializing) return;

    _isInitializing = true;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    debugPrint('AUTH INIT START');

    try {
      _listenAuthChanges();

      final session = getCurrentSessionUseCase();

      debugPrint('SESSION: ${session == null ? 'NO' : 'SI'}');

      if (session == null) {
        await _clearLocalAuthState(notify: false);
        return;
      }

      await _loadCachedUser();

      await _refreshProfileSilently();
    } on Object catch (error) {
      debugPrint('AUTH INIT ERROR: $error');
      errorMessage = error.toString();
    } finally {
      _isInitializing = false;
      isLoading = false;
      debugPrint('AUTH INIT FINISH');
      notifyListeners();
    }
  }

  void _listenAuthChanges() {
    _authSubscription?.cancel();

    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      data,
    ) async {
      if (_isInitializing || _handlingAuthChange) return;

      _handlingAuthChange = true;

      try {
        if (data.session == null) {
          await _clearLocalAuthState();
          return;
        }

        await _loadCachedUser();
        await loadProfile();
      } on Object catch (error) {
        errorMessage = error.toString();
        notifyListeners();
      } finally {
        _handlingAuthChange = false;
      }
    });
  }

  Future<void> _loadCachedUser() async {
    try {
      final cachedUser = await getCachedUserUseCase();

      if (cachedUser == null) return;

      user = cachedUser;
      notifyListeners();
    } on Object catch (error) {
      debugPrint('No se pudo cargar usuario cacheado: $error');
    }
  }

  Future<void> _refreshProfileSilently() async {
    try {
      final freshUser = await getProfileUseCase().timeout(
        const Duration(seconds: 20),
      );

      user = freshUser;

      try {
        await saveCachedUserUseCase(freshUser);
      } on Object catch (cacheError) {
        debugPrint('No se pudo guardar usuario cacheado: $cacheError');
      }
    } on Object catch (error) {
      debugPrint('No se pudo refrescar perfil remoto: $error');
      errorMessage = error.toString();
    }
  }

  Future<bool> loadProfile() async {
    final result = await run<AppUser>(
      state: ViewModelActionState.saving,
      action: () {
        return getProfileUseCase().timeout(const Duration(seconds: 20));
      },
    );

    if (result == null) return false;

    user = result;
    notifyListeners();

    try {
      await saveCachedUserUseCase(result);
    } on Object catch (cacheError) {
      debugPrint('No se pudo guardar usuario cacheado: $cacheError');
    }

    return true;
  }

  Future<bool> loginWithGoogle() {
    return runBool(
      state: ViewModelActionState.saving,
      action: loginWithGoogleUseCase.call,
    );
  }

  Future<bool> logout() {
    return runBool(
      state: ViewModelActionState.deleting,
      preventDuplicates: true,
      action: () async {
        try {
          await logoutUseCase();
        } on Object catch (error) {
          debugPrint('Logout remoto/local de Supabase falló: $error');
        } finally {
          await _clearLocalAuthState(notify: false);
        }
      },
    );
  }

  Future<void> _clearLocalAuthState({bool notify = true}) async {
    user = null;
    errorMessage = null;

    try {
      await clearCachedUserUseCase();
    } on Object catch (error) {
      debugPrint('No se pudo limpiar usuario cacheado: $error');
    }

    if (notify) notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
