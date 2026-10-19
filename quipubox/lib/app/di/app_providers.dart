import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/navigation/app_router.dart';
import '../../core/network/api_client.dart';
import '../../core/network/connectivity_viewmodel.dart';
import '../../core/network/network_checker.dart';
import '../../features/auth/presentation/viewmodels/auth_viewmodel.dart';

import 'modules/auth_module.dart';
import 'modules/settings_module.dart';
import 'modules/organizacion/roles_module.dart';
import 'modules/organizacion/sedes_module.dart';
import 'modules/organizacion/usuarios_module.dart';
import 'modules/organizacion/lugares_operativos_module.dart';
import 'modules/organizacion/puestos_module.dart';
import 'modules/catalogos/camiones_module.dart';
import 'modules/organizacion/clientes_module.dart';
import 'modules/catalogos/frutas_module.dart';
import 'modules/catalogos/variedades_module.dart';
import 'modules/catalogos/calidades_module.dart';
import 'modules/catalogos/tipos_jaba_module.dart';
import 'modules/operaciones/carga_module.dart';

class AppProviders {
  const AppProviders._();

  static List<SingleChildWidget> providers(SharedPreferences preferences) => [
    // Core
    Provider<SharedPreferences>.value(value: preferences),

    Provider<NetworkChecker>(create: (_) => NetworkChecker()),

    Provider<ApiClient>(
      create: (context) =>
          ApiClient(networkChecker: context.read<NetworkChecker>()),
    ),

    ChangeNotifierProvider<ConnectivityViewModel>(
      create: (context) =>
          ConnectivityViewModel(networkChecker: context.read<NetworkChecker>())
            ..start(),
    ),

    // Auth y sesión
    ...AuthModule.providers,

    // Navegación
    Provider<AppRouter>(
      create: (context) => AppRouter(context.read<AuthViewModel>()),
    ),

    // Configuración
    ...SettingsModule.providers,

    // Administración
    ...RolesModule.providers,
    ...UsuariosModule.providers,

    // Logística
    ...SedesModule.providers,
    ...LugaresOperativosModule.providers,
    ...PuestosModule.providers,
    ...CamionesModule.providers,

    // Clientes
    ...ClientesModule.providers,

    // Catálogos
    ...FrutasModule.providers,
    ...VariedadesModule.providers,
    ...CalidadesModule.providers,
    ...TiposJabaModule.providers,

    // Operaciones
    ...CargaModule.providers,
  ];
}
