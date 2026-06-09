import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/app_config.dart';

class AuthRemoteDataSource {
  final SupabaseClient client;

  AuthRemoteDataSource(this.client);

  Future<void> loginWithGoogle() async {
    await client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: AppConfig.supabaseRedirectUrl,
    );
  }

  Future<void> logout() => client.auth.signOut();

  User? getCurrentUser() => client.auth.currentUser;

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}
