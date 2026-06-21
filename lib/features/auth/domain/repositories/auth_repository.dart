import 'package:supabase_flutter/supabase_flutter.dart';

import '../entities/app_user.dart';

abstract class AuthRepository {
  Session? getCurrentSession();

  Stream<AuthState> get authStateChanges;

  Future<void> loginWithGoogle();

  Future<void> logout();

  Future<AppUser> getProfile();

  Future<AppUser?> getCachedUser();

  Future<void> saveCachedUser(AppUser user);

  Future<void> clearCachedUser();
}