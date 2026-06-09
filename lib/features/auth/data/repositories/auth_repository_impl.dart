import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> loginWithGoogle() => remoteDataSource.loginWithGoogle();

  @override
  Future<void> logout() => remoteDataSource.logout();

  @override
  AppUser? getCurrentUser() {
    final user = remoteDataSource.getCurrentUser();
    if (user == null) return null;

    final metadata = user.userMetadata ?? {};
    return AppUser(
      id: user.id,
      email: user.email ?? '',
      fullName: metadata['full_name']?.toString() ??
          metadata['name']?.toString() ??
          'Usuario Google',
      avatarUrl: metadata['avatar_url']?.toString() ?? metadata['picture']?.toString(),
    );
  }

  @override
  Stream<AuthState> get authStateChanges => remoteDataSource.authStateChanges;
}
