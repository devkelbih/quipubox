import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkChecker networkChecker;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkChecker,
  });

  @override
  Session? getCurrentSession() => remoteDataSource.currentSession;

  @override
  Stream<AuthState> get authStateChanges => remoteDataSource.authStateChanges;

  @override
  Future<void> loginWithGoogle() async {
    final hasInternet = await networkChecker.hasInternet();

    if (!hasInternet) {
      throw const AppException('No hay conexión a internet.');
    }

    await remoteDataSource.loginWithGoogle();
  }

  @override
  Future<void> logout() async {
    final hasInternet = await networkChecker.hasInternet();

    if (!hasInternet) {
      throw const AppException('No hay conexión a internet.');
    }

    await remoteDataSource.logout();
  }

  @override
  Future<AppUser> getProfile() async {
    final hasInternet = await networkChecker.hasInternet();

    if (!hasInternet) {
      throw const AppException('No hay conexión a internet.');
    }

    return remoteDataSource.getProfile();
  }
}
