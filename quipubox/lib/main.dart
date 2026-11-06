import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'app/di/app_providers.dart';
import 'core/config/app_config.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppBootstrap());
}

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  Future<SharedPreferences>? _initialization;
  late Future<SharedPreferences> _attempt;
  bool _startupTimedOut = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    // Un timeout no cancela la inicialización: reutilizarla evita iniciar
    // Supabase dos veces mientras los servicios nativos siguen respondiendo.
    _initialization ??= _initialize();
    _startupTimedOut = false;
    _attempt = _initialization!.timeout(
      const Duration(seconds: 20),
      onTimeout: () {
        _startupTimedOut = true;
        throw TimeoutException('La inicialización tardó demasiado.');
      },
    );
  }

  Future<SharedPreferences> _initialize() async {
    try {
      await dotenv.load(fileName: '.env');
      final preferences = await SharedPreferences.getInstance();
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
      );
      // Si los servicios terminan después del timeout, continuar automáticamente.
      if (_startupTimedOut && mounted) {
        setState(() => _attempt = Future.value(preferences));
      }
      return preferences;
    } on Object {
      _initialization = null;
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: _attempt,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return MultiProvider(
            providers: AppProviders.providers(snapshot.requireData),
            child: const QuipuboxApp(),
          );
        }
        final failed =
            snapshot.connectionState == ConnectionState.done &&
            snapshot.hasError;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          home: Scaffold(
            backgroundColor: AppColors.navy,
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/logo.png', width: 160),
                      const SizedBox(height: 32),
                      if (failed) ...[
                        const Text(
                          'No se pudo iniciar la aplicación. Intenta nuevamente.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => setState(_start),
                          child: const Text('Reintentar'),
                        ),
                      ] else
                        const CircularProgressIndicator(color: AppColors.teal),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
