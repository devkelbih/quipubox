import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  const AppConfig._();
  static const baseUrl = 'https://quipubox-api.vercel.app';
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static String get supabaseRedirectUrl =>
      dotenv.env['SUPABASE_REDIRECT_URL'] ??
      'io.supabase.flutter://login-callback';
}
