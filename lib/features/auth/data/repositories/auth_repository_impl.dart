import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);
  @override Session? getCurrentSession() => remoteDataSource.currentSession;
  @override Stream<AuthState> get authStateChanges => remoteDataSource.authStateChanges;
  @override Future<void> loginWithGoogle() => remoteDataSource.loginWithGoogle();
  @override Future<void> logout() => remoteDataSource.logout();
  @override Future<AppUser> getProfile() => remoteDataSource.getProfile();
}
