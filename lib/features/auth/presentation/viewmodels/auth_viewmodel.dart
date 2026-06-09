import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  StreamSubscription<AuthState>? _authSubscription;

  AuthViewModel({
    required this.authRepository,
    required this.loginWithGoogleUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) {
    _init();
  }

  AppUser? user;
  bool isLoading = true;
  String? errorMessage;

  bool get isAuthenticated => user != null;

  void _init() {
    user = getCurrentUserUseCase();
    _listenAuthChanges();
    isLoading = false;
    notifyListeners();
  }

  void _listenAuthChanges() {
    _authSubscription = authRepository.authStateChanges.listen((data) {
      final session = data.session;

      if (session != null) {
        print('==============================');
        print('ACCESS TOKEN');

        // Esto no tiene límite de caracteres y forzará a la consola a mostrarlo todo
        developer.log(session.accessToken, name: 'SUPABASE_AUTH');

        print('==============================');

        print('REFRESH TOKEN');
        print(session.refreshToken);
        print('==============================');

        print('USER ID');
        print(session.user.id);
        print('==============================');
      }

      user = session == null ? null : getCurrentUserUseCase();

      isLoading = false;
      errorMessage = null;

      notifyListeners();
    });
  }

  Future<void> loginWithGoogle() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await loginWithGoogleUseCase();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    try {
      await logoutUseCase();
      user = null;
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
