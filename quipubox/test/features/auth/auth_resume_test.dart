import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quipubox/features/auth/domain/entities/authenticated_user.dart';
import 'package:quipubox/features/auth/domain/repositories/auth_repository.dart';
import 'package:quipubox/features/auth/domain/usecases/clear_cached_user_usecase.dart';
import 'package:quipubox/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:quipubox/features/auth/domain/usecases/get_current_session_usecase.dart';
import 'package:quipubox/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:quipubox/features/auth/domain/usecases/get_auth_state_changes_usecase.dart';
import 'package:quipubox/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:quipubox/features/auth/domain/usecases/logout_usecase.dart';
import 'package:quipubox/features/auth/domain/usecases/save_cached_user_usecase.dart';
import 'package:quipubox/features/auth/presentation/viewmodels/auth_viewmodel.dart';

class _User implements AuthenticatedUser {
  @override
  int get id => 1;
  @override
  int get idEmpresa => 1;
  @override
  int get idSede => 1;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Repository implements AuthRepository {
  final cachedUser = _User();
  final events = StreamController<AuthState>.broadcast();
  @override
  Stream<AuthState> get authStateChanges => events.stream;
  bool noCache = false;
  bool profileFails = false;
  int loginRequests = 0;
  @override
  Future<void> loginWithGoogle() async {
    loginRequests++;
  }

  Completer<AuthenticatedUser>? pendingProfile;
  bool cacheHangs = false;
  int profileRequests = 0;
  Session? session = Session(
    accessToken: 'test-token',
    tokenType: 'bearer',
    user: User.fromJson({
      'id': 'test-user',
      'app_metadata': <String, dynamic>{},
      'user_metadata': <String, dynamic>{},
      'aud': 'authenticated',
      'created_at': '2026-01-01T00:00:00Z',
    })!,
  );

  @override
  Session? getCurrentSession() => session;

  @override
  Future<AuthenticatedUser?> getCachedUser() => cacheHangs
      ? Completer<AuthenticatedUser?>().future
      : Future.value(noCache ? null : cachedUser);

  @override
  Future<AuthenticatedUser> getProfile() {
    profileRequests++;
    if (profileFails) return Future.error(StateError('Perfil no disponible'));
    return pendingProfile?.future ?? Future.value(cachedUser);
  }

  @override
  Future<void> saveCachedUser(AuthenticatedUser user) async {}

  @override
  Future<void> clearCachedUser() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _IncompleteUser extends _User {
  @override
  int get idSede => 0;
}

AuthViewModel _viewModel(
  _Repository repository, {
  Duration minimumSplashDuration = Duration.zero,
}) => AuthViewModel(
  minimumSplashDuration: minimumSplashDuration,
  getCurrentSessionUseCase: GetCurrentSessionUseCase(repository),
  getAuthStateChangesUseCase: GetAuthStateChangesUseCase(repository),
  loginWithGoogleUseCase: LoginWithGoogleUseCase(repository),
  logoutUseCase: LogoutUseCase(repository),
  getProfileUseCase: GetProfileUseCase(repository),
  getCachedUserUseCase: GetCachedUserUseCase(repository),
  saveCachedUserUseCase: SaveCachedUserUseCase(repository),
  clearCachedUserUseCase: ClearCachedUserUseCase(repository),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'test-key',
      debug: false,
      authOptions: const FlutterAuthClientOptions(
        localStorage: EmptyLocalStorage(),
        autoRefreshToken: false,
        detectSessionInUri: false,
      ),
    );
  });

  tearDownAll(() => Supabase.instance.dispose());

  testWidgets(
    'El splash dura al menos un segundo aunque el perfil llegue antes',
    (tester) async {
      final repository = _Repository();
      final vm = _viewModel(
        repository,
        minimumSplashDuration: const Duration(seconds: 1),
      );
      await tester.pump();
      expect(vm.user, isNotNull);
      expect(vm.isCheckingSession, isTrue);
      expect(vm.canOpenApp, isFalse);
      await tester.pump(const Duration(milliseconds: 500));
      expect(vm.isCheckingSession, isTrue);
      await tester.pump(const Duration(milliseconds: 500));
      expect(vm.isCheckingSession, isFalse);
      expect(vm.canOpenApp, isTrue);
      vm.dispose();
      await repository.events.close();
    },
  );

  testWidgets('Google sigue cargando hasta recibir el perfil completo', (
    tester,
  ) async {
    final repository = _Repository()..noCache = true;
    final session = repository.session;
    repository.session = null;
    final vm = _viewModel(repository);
    await tester.pump();
    final login = vm.loginWithGoogle();
    await tester.pump();
    expect(vm.isSigningIn, isTrue);
    expect(vm.canOpenApp, isFalse);
    expect(repository.loginRequests, 1);
    expect(await vm.loginWithGoogle(), isFalse);
    expect(repository.loginRequests, 1);

    repository.pendingProfile = Completer();
    repository.session = session;
    repository.events.add(AuthState(AuthChangeEvent.signedIn, session));
    await tester.pump();
    expect(vm.isPreparingProfile, isTrue);
    expect(vm.isSigningIn, isTrue);
    expect(vm.canOpenApp, isFalse);
    vm.didChangeAppLifecycleState(AppLifecycleState.paused);
    vm.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await tester.pump();
    expect(repository.profileRequests, 1);

    repository.pendingProfile!.complete(repository.cachedUser);
    await tester.pump();
    expect(await login, isTrue);
    expect(vm.canOpenApp, isTrue);
    expect(vm.isSigningIn, isFalse);
    expect(vm.isPreparingProfile, isFalse);
    vm.dispose();
    await repository.events.close();
  });

  testWidgets(
    'Un perfil fallido impide abrir Home y permite reintentar sin Google',
    (tester) async {
      final repository = _Repository()..noCache = true;
      final session = repository.session;
      repository.session = null;
      final vm = _viewModel(repository);
      await tester.pump();
      final login = vm.loginWithGoogle();
      await tester.pump();
      repository.profileFails = true;
      repository.session = session;
      repository.events.add(AuthState(AuthChangeEvent.signedIn, session));
      await tester.pump();
      expect(await login, isFalse);
      expect(vm.canOpenApp, isFalse);
      expect(vm.isSigningIn, isFalse);
      expect(vm.errorMessage, contains('Perfil no disponible'));
      repository.profileFails = false;
      expect(await vm.loginWithGoogle(), isTrue);
      expect(repository.loginRequests, 1);
      expect(vm.canOpenApp, isTrue);
      vm.dispose();
      await repository.events.close();
    },
  );

  testWidgets('Cancelar el navegador libera la carga y permite otro intento', (
    tester,
  ) async {
    final repository = _Repository()..session = null;
    final vm = _viewModel(repository);
    await tester.pump();
    final login = vm.loginWithGoogle();
    await tester.pump();
    vm.didChangeAppLifecycleState(AppLifecycleState.paused);
    vm.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await tester.pump(const Duration(seconds: 11));
    expect(await login, isFalse);
    expect(vm.isSigningIn, isFalse);
    expect(vm.canOpenApp, isFalse);
    expect(vm.errorMessage, isNotNull);
    vm.dispose();
    await repository.events.close();
  });

  testWidgets(
    'Arranque sin cache espera al perfil y rechaza datos incompletos',
    (tester) async {
      final repository = _Repository()
        ..noCache = true
        ..pendingProfile = Completer();
      final vm = _viewModel(repository);
      await tester.pump();
      expect(vm.canOpenApp, isFalse);
      expect(vm.isCheckingSession, isTrue);
      repository.pendingProfile!.complete(_IncompleteUser());
      await tester.pump();
      expect(vm.canOpenApp, isFalse);
      expect(vm.isCheckingSession, isFalse);
      expect(vm.errorMessage, contains('perfil completo'));
      vm.dispose();
      await repository.events.close();
    },
  );

  testWidgets('Un cierre de sesión descarta el perfil que llegue tarde', (
    tester,
  ) async {
    final repository = _Repository()..noCache = true;
    final vm = _viewModel(repository);
    await tester.pump();
    repository.pendingProfile = Completer();
    final pending = vm.loadProfile();
    repository.session = null;
    repository.events.add(AuthState(AuthChangeEvent.signedOut, null));
    await tester.pump();
    repository.pendingProfile!.complete(repository.cachedUser);
    await tester.pump();
    expect(await pending, isFalse);
    expect(vm.user, isNull);
    expect(vm.canOpenApp, isFalse);
    vm.dispose();
    await repository.events.close();
  });

  testWidgets('El cache bloqueado no deja el arranque cargando para siempre', (
    tester,
  ) async {
    final repository = _Repository()..cacheHangs = true;
    final vm = _viewModel(repository);
    await tester.pump();
    expect(vm.isCheckingSession, isTrue);
    await tester.pump(const Duration(seconds: 6));
    expect(vm.isCheckingSession, isFalse);
    expect(vm.user, same(repository.cachedUser));
    vm.dispose();
  });

  testWidgets('Reanuda sin bloquear la pantalla ni duplicar solicitudes', (
    tester,
  ) async {
    final repository = _Repository();
    final vm = _viewModel(repository);
    await tester.pump();
    expect(vm.isCheckingSession, isFalse);
    repository.pendingProfile = Completer();
    final initialRequests = repository.profileRequests;
    vm.didChangeAppLifecycleState(AppLifecycleState.resumed);
    vm.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await tester.pump();
    expect(repository.profileRequests, initialRequests + 1);
    expect(vm.isCheckingSession, isFalse);
    await tester.pump(const Duration(seconds: 6));
    expect(vm.canOpenApp, isTrue);
    vm.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await tester.pump();
    expect(repository.profileRequests, initialRequests + 2);
    repository.pendingProfile!.complete(repository.cachedUser);
    await tester.pump();
    vm.dispose();
  });

  testWidgets('Una sesión perdida al volver permite redirigir al login', (
    tester,
  ) async {
    final repository = _Repository();
    final vm = _viewModel(repository);
    await tester.pump();
    expect(vm.canOpenApp, isTrue);
    repository.session = null;
    vm.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await tester.pump();
    expect(vm.canOpenApp, isFalse);
    expect(vm.isCheckingSession, isFalse);
    vm.dispose();
  });
}
