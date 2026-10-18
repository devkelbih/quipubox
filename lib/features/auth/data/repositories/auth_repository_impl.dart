import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/authenticated_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/app_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Session? getCurrentSession() => remoteDataSource.currentSession;

  @override
  Stream<AuthState> get authStateChanges => remoteDataSource.authStateChanges;

  @override
  Future<void> loginWithGoogle() async {
    await remoteDataSource.loginWithGoogle();
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } finally {
      await clearCachedUser();
    }
  }

  @override
  Future<AuthenticatedUser> getProfile() async {
    final model = await remoteDataSource.getProfile();
    return model.toEntity();
  }

  @override
  Future<AuthenticatedUser?> getCachedUser() async {
    final model = await localDataSource.getCachedUser();
    return model?.toEntity();
  }

  @override
  Future<void> saveCachedUser(AuthenticatedUser user) {
    return localDataSource.saveCachedUser(AppUserModel.fromEntity(user));
  }

  @override
  Future<void> clearCachedUser() {
    return localDataSource.clearCachedUser();
  }
}
