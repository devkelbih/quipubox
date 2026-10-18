import 'package:supabase_flutter/supabase_flutter.dart';

import '../entities/authenticated_user.dart';

abstract class AuthRepository {
  Session? getCurrentSession();

  Stream<AuthState> get authStateChanges;

  Future<void> loginWithGoogle();

  Future<void> logout();

  Future<AuthenticatedUser> getProfile();

  Future<AuthenticatedUser?> getCachedUser();

  Future<void> saveCachedUser(AuthenticatedUser user);

  Future<void> clearCachedUser();
}
