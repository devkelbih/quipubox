import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/app_user.dart';
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
    if (kDebugMode) {
      await Future.delayed(const Duration(seconds: 3));
    }
    await remoteDataSource.loginWithGoogle();
  }

  @override
  Future<void> logout() async {
    try {
      if (kDebugMode) {
        await Future.delayed(const Duration(seconds: 3));
      }
      await remoteDataSource.logout();
    } finally {
      await clearCachedUser();
    }
  }

  @override
  Future<AppUser> getProfile() async {
    if (kDebugMode) {
      await Future.delayed(const Duration(seconds: 3));
    }
    return remoteDataSource.getProfile();
  }

  @override
  Future<AppUser?> getCachedUser() {
    return localDataSource.getCachedUser();
  }

  @override
  Future<void> saveCachedUser(AppUser user) {
    return localDataSource.saveCachedUser(AppUserModel.fromEntity(user));
  }

  @override
  Future<void> clearCachedUser() {
    return localDataSource.clearCachedUser();
  }
}
