import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/app_user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Session? get currentSession => Supabase.instance.client.auth.currentSession;

  Stream<AuthState> get authStateChanges =>
      Supabase.instance.client.auth.onAuthStateChange;

  Future<void> loginWithGoogle() {
    return Supabase.instance.client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: AppConfig.supabaseRedirectUrl,
    );
  }

  Future<void> logout() {
    return Supabase.instance.client.auth.signOut();
  }

  Future<AppUserModel> getProfile() async {
    final response = await apiClient.get('/auth/profile');

    return AppUserModel.fromJson(
      response as Map<String, dynamic>,
      source: 'remote',
    );
  }
}
