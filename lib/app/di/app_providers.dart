import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/navigation/app_router.dart';
import '../../core/network/api_client.dart';
import '../../core/network/connectivity_viewmodel.dart';
import '../../core/network/network_checker.dart';
import '../../features/auth/presentation/viewmodels/auth_viewmodel.dart';

import 'modules/admin_module.dart';
import 'modules/auth_module.dart';
import 'modules/catalogos_module.dart';
import 'modules/settings_module.dart';

/// Registro principal de dependencias de toda la aplicación.
///
/// Su única responsabilidad es:
///
/// 1. Registrar servicios globales (Core).
/// 2. Registrar módulos funcionales.
/// 3. Construir el router principal.
///
/// Todo lo demás vive dentro de:
///
/// - AuthModule
/// - SettingsModule
/// - AdminModule
/// - CatalogosModule
///
class AppProviders {
  const AppProviders._();

  /// Retorna la lista completa de Providers
  /// que será usada por MultiProvider en app.dart.
  static providers(SharedPreferences preferences) => [

        // ==========================================================
        // CORE
        // Dependencias compartidas por toda la aplicación.
        // ==========================================================

        /// SharedPreferences inicializado en main.dart.
        ///
        /// Se reutiliza en Settings,
        /// persistencia local y futuras configuraciones.
        Provider<SharedPreferences>.value(
          value: preferences,
        ),

        /// Cliente HTTP central.
        ///
        /// Todos los DataSources remotos usan esta instancia.
        /// Maneja:
        /// - JWT de Supabase
        /// - Headers
        /// - Timeouts
        /// - Manejo de errores
        Provider<ApiClient>(
          create: (_) => ApiClient(),
        ),

        /// Servicio para validar acceso a internet.
        ///
        /// Es utilizado por:
        /// - Repositories
        /// - ConnectivityViewModel
        /// - Operaciones críticas
        Provider<NetworkChecker>(
          create: (_) => NetworkChecker(),
        ),

        /// ViewModel global que escucha cambios
        /// de conectividad de red.
        ///
        /// Permite mostrar mensajes como:
        /// "Sin conexión a internet"
        ///
        /// El operador "..start()"
        /// ejecuta el método start()
        /// inmediatamente después de crear el objeto.
        ChangeNotifierProvider<ConnectivityViewModel>(
          create: (context) => ConnectivityViewModel(
            networkChecker: context.read<NetworkChecker>(),
          )..start(),
        ),

        // ==========================================================
        // AUTH
        // Login, sesión y perfil.
        // ==========================================================

        /// Expande todos los providers registrados
        /// dentro de AuthModule.
        ///
        /// Incluye:
        /// - AuthRemoteDataSource
        /// - AuthRepository
        /// - UseCases
        /// - AuthViewModel
        /// - CurrentSession
        ...AuthModule.providers,

        // ==========================================================
        // ROUTER
        // Navegación principal de la aplicación.
        // ==========================================================

        /// Router central basado en GoRouter.
        ///
        /// Depende de AuthViewModel para decidir:
        ///
        /// - Splash
        /// - Login
        /// - Home
        /// - Redirecciones
        Provider<AppRouter>(
          create: (context) => AppRouter(
            context.read<AuthViewModel>(),
          ),
        ),

        // ==========================================================
        // SETTINGS
        // Tema y configuraciones.
        // ==========================================================

        ...SettingsModule.providers,

        // ==========================================================
        // ADMINISTRACIÓN
        //
        // Roles
        // Usuarios
        // Sedes
        // Lugares Operativos
        // Puestos
        // Clientes
        // ==========================================================

        ...AdminModule.providers,

        // ==========================================================
        // CATÁLOGOS
        //
        // Frutas
        // Variedades
        // Calidades
        // Tipos de Jaba
        // Camiones
        // ==========================================================

        ...CatalogosModule.providers,
      ];
}