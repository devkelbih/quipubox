import 'package:supabase_flutter/supabase_flutter.dart';

import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<void> loginWithGoogle();
  Future<void> logout();
  AppUser? getCurrentUser();
  Stream<AuthState> get authStateChanges;
}
