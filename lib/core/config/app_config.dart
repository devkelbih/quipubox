import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../common/string_extensions.dart';

class AppConfig {
  const AppConfig._();
  static const baseUrl = 'https://api-quipubox.vercel.app';
  //gestiona las cuentas/tokens
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'].orEmpty;
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'].orEmpty;
  //redirecciona a la app despues de iniciar sesion con google
  static String get supabaseRedirectUrl =>
      dotenv.env['SUPABASE_REDIRECT_URL'].value ??
      'io.supabase.flutter://login-callback';
}
