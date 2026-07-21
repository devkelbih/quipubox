import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  const AppConfig._();
  static const baseUrl = 'https://api-quipubox.vercel.app';
  //gestiona las cuentas/tokens
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  //redirecciona a la app despues de iniciar sesion con google
  static String get supabaseRedirectUrl =>
      dotenv.env['SUPABASE_REDIRECT_URL'] ??
      'io.supabase.flutter://login-callback';
}
