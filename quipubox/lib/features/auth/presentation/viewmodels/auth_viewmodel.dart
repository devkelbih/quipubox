import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:quipubox/core/state/base_state_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../../domain/usecases/get_auth_state_changes_usecase.dart';
import '../../domain/entities/authenticated_user.dart';
import '../../domain/usecases/clear_cached_user_usecase.dart';
import '../../domain/usecases/get_cached_user_usecase.dart';
import '../../domain/usecases/get_current_session_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/save_cached_user_usecase.dart';

class AuthViewModel extends BaseStateViewModel with WidgetsBindingObserver {
  final GetCurrentSessionUseCase getCurrentSessionUseCase;
  final GetAuthStateChangesUseCase getAuthStateChangesUseCase;
  final Duration minimumSplashDuration;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final LogoutUseCase logoutUseCase;
  final GetProfileUseCase getProfileUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;
  final SaveCachedUserUseCase saveCachedUserUseCase;
  final ClearCachedUserUseCase clearCachedUserUseCase;

  StreamSubscription<AuthState>? _authSubscription;

  bool _isInitializing = false;
  bool _handlingAuthChange = false;
  bool _isResuming = false;
  bool _disposed = false;
  Completer<bool>? _signInCompletion;
  Timer? _oauthReturnTimer;
  bool _oauthLeftApp = false;
  AuthState? _pendingAuthState;
  int _authGeneration = 0;

  AuthViewModel({
    required this.getCurrentSessionUseCase,
    required this.getAuthStateChangesUseCase,
    this.minimumSplashDuration = const Duration(seconds: 2),
    required this.loginWithGoogleUseCase,
    required this.logoutUseCase,
    required this.getProfileUseCase,
    required this.getCachedUserUseCase,
    required this.saveCachedUserUseCase,
    required this.clearCachedUserUseCase,
  }) {
    WidgetsBinding.instance.addObserver(this);
    unawaited(initialize());
  }
  // Usuario actualmente autenticado.
  AuthenticatedUser? user;

  // Información rápida de autenticación.
  bool get hasSupabaseSession => getCurrentSessionUseCase() != null;
  bool get hasProfile => user != null;

  /// Una sesión sin el perfil completo nunca permite abrir el Home.
  /// El perfil cacheado válido permite recuperar el acceso sin red.
  bool get canOpenApp =>
      hasSupabaseSession &&
      hasProfile &&
      !isCheckingSession &&
      !isSigningIn &&
      !isPreparingProfile;

  // Datos frecuentes del usuario para evitar null-checks repetidos.
  int? get currentUserId => user?.id;
  int? get currentCompanyId => user?.idEmpresa;
  int? get currentSedeId => user?.idSede;

  // Estados específicos de UI.
  bool get isCheckingSession => _isInitializing;
  bool get isPreparingProfile =>
      !_isInitializing &&
      ((isLoading && !hasProfile) || (isSigningIn && hasSupabaseSession));
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
    if (_isInitializing || _disposed) return;
    _isInitializing = true;
    try {
      await runBool(
        state: ViewModelActionState.loading,
        action: () async {
          // El mínimo visual transcurre junto a la carga, sin sumarse a ella.
          final minimumVisible = minimumSplashDuration == Duration.zero
              ? Future<void>.value()
              : Future<void>.delayed(minimumSplashDuration);
          try {
            _listenAuthChanges();
            if (!hasSupabaseSession) {
              await _clearLocalAuthState(notify: false);
              return;
            }
            await _loadCachedUser();
            if (hasProfile) {
              await _refreshProfileSilently();
            } else {
              await _fetchProfile();
            }
          } finally {
            await minimumVisible;
          }
        },
      );
    } finally {
      _isInitializing = false;
      notifyListeners();
      final pending = _pendingAuthState;
      _pendingAuthState = null;
      if (pending != null) unawaited(_handleAuthChange(pending));
    }
  }

  void _listenAuthChanges() {
    _authSubscription?.cancel();
    _authSubscription = getAuthStateChangesUseCase().listen(
      (data) => unawaited(_handleAuthChange(data)),
      onError: (Object error, StackTrace stackTrace) {
        _finishSignIn(false);
      },
    );
  }

  Future<void> _handleAuthChange(AuthState data) async {
    if (_disposed) return;
    if (_isInitializing) {
      _pendingAuthState = data;
      return;
    }
    if (data.session == null) {
      _authGeneration++;
      _finishSignIn(false);
      await _clearLocalAuthState();
      return;
    }
    if (_handlingAuthChange || isSigningOut) return;
    if (hasProfile &&
        (data.event == AuthChangeEvent.tokenRefreshed ||
            data.event == AuthChangeEvent.initialSession)) {
      return;
    }
    _handlingAuthChange = true;
    try {
      // El callback de Google aún no equivale a tener un perfil disponible.
      final succeeded = await loadProfile();
      _finishSignIn(succeeded);
    } finally {
      _handlingAuthChange = false;
      notifyListeners();
    }
  }

  void _finishSignIn(bool succeeded) {
    final pending = _signInCompletion;
    if (pending != null && !pending.isCompleted) pending.complete(succeeded);
  }

  Future<void> _fetchProfile() async {
    final generation = _authGeneration;
    final account = getCurrentSessionUseCase()?.user.id;
    final profile = await getProfileUseCase().timeout(
      const Duration(seconds: 20),
    );
    if (_disposed ||
        generation != _authGeneration ||
        account == null ||
        getCurrentSessionUseCase()?.user.id != account) {
      throw const AppException(
        'La sesión cambió. Intenta ingresar nuevamente.',
      );
    }
    // Empresa, sede y roles llegan juntos en la respuesta del perfil.
    user = profile;
    try {
      await saveCachedUserUseCase(profile).timeout(const Duration(seconds: 5));
    } on Object catch (error) {
      debugPrint('No se pudo guardar usuario cacheado: $error');
    }
  }

  Future<void> _loadCachedUser() async {
    try {
      final cachedUser = await getCachedUserUseCase().timeout(
        const Duration(seconds: 5),
      );

      if (cachedUser == null || _disposed) return;

      user = cachedUser;
      notifyListeners();
    } on Object catch (error) {
      debugPrint('No se pudo cargar usuario cacheado: $error');
    }
  }

  Future<void> _refreshProfileSilently() async {
    try {
      final freshUser = await getProfileUseCase().timeout(
        const Duration(seconds: 5),
      );

      if (_disposed || !hasSupabaseSession) return;
      user = freshUser;

      try {
        await saveCachedUserUseCase(
          freshUser,
        ).timeout(const Duration(seconds: 5));
      } on Object catch (cacheError) {
        debugPrint('No se pudo guardar usuario cacheado: $cacheError');
      }
    } on Object catch (error) {
      debugPrint('Perfil remoto no disponible, usando cache local: $error');

      // NO modificar errorMessage.
      // NO limpiar sesión.
      // NO expulsar usuario.
    }
  }

  Future<bool> loadProfile() =>
      runBool(state: ViewModelActionState.loading, action: _fetchProfile);

  Future<bool> loginWithGoogle() => runBool(
    state: ViewModelActionState.saving,
    action: () async {
      if (hasSupabaseSession && !hasProfile) {
        // Reintentar el perfil sin volver a abrir Google tras un fallo de red.
        await _fetchProfile();
        return;
      }
      final completion = Completer<bool>();
      _signInCompletion = completion;
      _oauthLeftApp = false;
      user = null;
      // Escuchar el resultado antes de abrir el navegador evita perder callbacks.
      final finished = completion.future.timeout(
        const Duration(minutes: 2),
        onTimeout: () => false,
      );
      try {
        await loginWithGoogleUseCase().timeout(const Duration(seconds: 20));
        if (!await finished) {
          throw AppException(
            errorMessage ??
                'No se completó el inicio de sesión. Puedes intentarlo nuevamente.',
          );
        }
      } finally {
        _oauthReturnTimer?.cancel();
        if (!completion.isCompleted) completion.complete(false);
        if (identical(_signInCompletion, completion)) _signInCompletion = null;
      }
    },
  );

  Future<bool> logout() {
    return runBool(
      state: ViewModelActionState.deleting,
      preventDuplicates: true,
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
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
    _authGeneration++;
    user = null;
    errorMessage = null;

    try {
      await clearCachedUserUseCase().timeout(const Duration(seconds: 5));
    } on Object catch (error) {
      debugPrint('No se pudo limpiar usuario cacheado: $error');
    }

    if (notify) notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_signInCompletion != null &&
        (state == AppLifecycleState.paused ||
            state == AppLifecycleState.inactive)) {
      _oauthLeftApp = true;
    }
    if (state == AppLifecycleState.resumed) {
      if (_signInCompletion != null && _oauthLeftApp) {
        _oauthReturnTimer?.cancel();
        final session = getCurrentSessionUseCase();
        if (session != null) {
          unawaited(
            _handleAuthChange(AuthState(AuthChangeEvent.signedIn, session)),
          );
        } else {
          // Dar margen al deep link antes de considerar cancelado el navegador.
          _oauthReturnTimer = Timer(const Duration(seconds: 10), () {
            if (!hasSupabaseSession) _finishSignIn(false);
          });
        }
      }
      unawaited(_recoverOnResume());
    }
  }

  Future<void> _recoverOnResume() async {
    if (_disposed ||
        _isResuming ||
        _isInitializing ||
        isAuthBusy ||
        _handlingAuthChange) {
      return;
    }
    _isResuming = true;
    try {
      if (!hasSupabaseSession) {
        await _clearLocalAuthState();
        return;
      }
      if (user == null) await _loadCachedUser();
      await _refreshProfileSilently();
      if (!_disposed) notifyListeners();
    } finally {
      _isResuming = false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _oauthReturnTimer?.cancel();
    _finishSignIn(false);
    WidgetsBinding.instance.removeObserver(this);
    _authSubscription?.cancel();
    super.dispose();
  }
}
