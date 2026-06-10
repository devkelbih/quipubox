import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/state/dispose_safe_notifier.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/usecases/get_current_session_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

class AuthViewModel extends DisposeSafeNotifier {
  /// Obtiene la sesión actual guardada por Supabase.
  ///
  /// Sirve para saber si existe un token activo al abrir la app.
  final GetCurrentSessionUseCase getCurrentSessionUseCase;

  /// Ejecuta el login con Google usando Supabase.
  final LoginWithGoogleUseCase loginWithGoogleUseCase;

  /// Cierra la sesión actual de Supabase.
  final LogoutUseCase logoutUseCase;

  /// Consulta el perfil real del usuario en el backend.
  ///
  /// Normalmente consume /auth/profile o /auth/me.
  final GetProfileUseCase getProfileUseCase;

  /// Escucha cambios de sesión emitidos por Supabase.
  StreamSubscription<AuthState>? _authSubscription;

  /// Evita procesar dos cambios de auth al mismo tiempo.
  bool _handlingAuthChange = false;

  AuthViewModel({
    required this.getCurrentSessionUseCase,
    required this.loginWithGoogleUseCase,
    required this.logoutUseCase,
    required this.getProfileUseCase,
  }) {
    initialize();
  }

  /// Usuario autenticado dentro del sistema Quipubox.
  ///
  /// Este usuario no viene directamente de Google.
  /// Viene del backend después de validar el token de Supabase.
  ///
  /// Aquí deben estar los datos de negocio:
  /// - id del usuario en tu base de datos
  /// - id_empresa
  /// - id_sede
  /// - id_rol
  /// - estado_acceso
  /// - nombres
  /// - apellidos
  /// - datos de empresa, sede y rol
  AppUser? user;

  /// Indica si se está iniciando, validando sesión o cargando perfil.
  bool isLoading = true;

  /// Reservado para futuras operaciones de guardado relacionadas a auth.
  bool isSaving = false;

  /// Reservado para futuras operaciones de eliminación relacionadas a auth.
  bool isDeleting = false;

  /// Mensaje de error que puede mostrar la interfaz.
  String? errorMessage;

  /// Indica si Supabase tiene una sesión activa.
  ///
  /// Esto solo confirma que hay sesión/token en Supabase.
  /// No confirma que el usuario exista o esté autorizado en Quipubox.
  bool get hasSupabaseSession => getCurrentSessionUseCase() != null;

  /// Indica si el usuario está autenticado correctamente en Quipubox.
  ///
  /// Para ser true necesita:
  /// - sesión activa en Supabase
  /// - perfil cargado desde el backend
  bool get isAuthenticated => hasSupabaseSession && user != null;

  /// ID del usuario en la base de datos de Quipubox.
  ///
  /// Es nullable porque antes de cargar sesión user puede ser null.
  int? get currentUserId => user?.id;

  /// ID de la empresa del usuario autenticado.
  ///
  /// Este valor se usa para crear registros relacionados a empresa,
  /// por ejemplo sedes, clientes, frutas, lugares operativos, etc.
  int? get currentCompanyId => user?.idEmpresa;

  /// ID del rol asignado al usuario.
  ///
  /// Sirve para permisos, visibilidad de módulos y validaciones de UI.
  int? get currentRoleId => user?.idRol;

  /// ID de la sede asignada al usuario.
  ///
  /// Sirve para operaciones que dependen de una sede de trabajo.
  int? get currentSedeId => user?.idSede;

  /// Inicializa el estado de autenticación al abrir la app.
  ///
  /// Flujo:
  /// 1. Empieza a escuchar cambios de sesión de Supabase.
  /// 2. Revisa si Supabase ya tiene sesión activa.
  /// 3. Si no hay sesión, deja user en null.
  /// 4. Si hay sesión, consulta el perfil en el backend.
  /// 5. Si el perfil no es válido, cierra sesión de forma segura.
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

  /// Escucha los cambios de sesión que emite Supabase.
  ///
  /// Se ejecuta cuando:
  /// - el usuario inicia sesión
  /// - el usuario cierra sesión
  /// - Supabase refresca el token
  /// - la sesión cambia
  /// - la sesión expira
  void _listenAuthChanges() {
    _authSubscription?.cancel();

    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      data,
    ) async {
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
      } finally {
        _handlingAuthChange = false;
      }
    });
  }

  /// Carga el perfil del usuario desde el backend.
  ///
  /// Este método no consulta directamente Google.
  /// El backend recibe el token Supabase, lo valida y devuelve
  /// el usuario registrado en tu base de datos.
  Future<bool> loadProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      user = await getProfileUseCase().timeout(
        const Duration(seconds: 20),
      );

      if (user?.estadoAcceso != 'activo') {
        errorMessage = 'Tu usuario no está autorizado para ingresar.';
        user = null;
        return false;
      }

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

  /// Inicia sesión con Google mediante Supabase.
  ///
  /// Después del login, Supabase dispara un cambio de sesión.
  /// Ese cambio es capturado por _listenAuthChanges().
  /// Luego se ejecuta loadProfile() para obtener el usuario real del sistema.
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

  /// Cierra sesión y limpia el usuario en memoria.
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

  /// Cierra sesión sin interrumpir la app si ocurre un error.
  ///
  /// Se usa cuando Supabase tiene sesión, pero el backend rechaza
  /// al usuario porque no existe, está bloqueado o no está autorizado.
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

  /// Finaliza estados de carga y notifica a la interfaz.
  void _finishLoading() {
    isLoading = false;
    notifyListeners();
  }

  /// Limpia errores técnicos para mostrarlos mejor en pantalla.
  String _clean(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '')
        .replaceFirst('AppException: ', '');
  }

  /// Cancela el listener de Supabase cuando el ViewModel deja de usarse.
  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}