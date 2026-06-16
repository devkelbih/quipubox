import 'package:quipubox/core/network/connectivity_viewmodel.dart';
import 'package:quipubox/core/session/current_session.dart';
import 'package:quipubox/features/auth/presentation/session/auth_current_session.dart';
import 'package:quipubox/features/sedes/domain/usecases/change_sede_status.dart';

import '../../core/navigation/app_router.dart';
import '../../core/network/api_client.dart';
import '../../core/network/network_checker.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_session_usecase.dart';
import '../../features/auth/domain/usecases/get_profile_usecase.dart';
import '../../features/auth/domain/usecases/login_with_google_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../features/calidades/data/datasources/calidades_remote_data_source.dart';
import '../../features/calidades/data/repositories/calidades_repository_impl.dart';
import '../../features/calidades/domain/repositories/calidades_repository.dart';
import '../../features/calidades/domain/usecases/create_calidad.dart';
import '../../features/calidades/domain/usecases/delete_calidad.dart';
import '../../features/calidades/domain/usecases/get_calidades.dart';
import '../../features/calidades/domain/usecases/update_calidad.dart';
import '../../features/calidades/presentation/viewmodels/calidades_viewmodel.dart';
import '../../features/camiones/data/datasources/camiones_remote_data_source.dart';
import '../../features/camiones/data/repositories/camiones_repository_impl.dart';
import '../../features/camiones/domain/repositories/camiones_repository.dart';
import '../../features/camiones/domain/usecases/create_camion.dart';
import '../../features/camiones/domain/usecases/delete_camion.dart';
import '../../features/camiones/domain/usecases/get_camiones.dart';
import '../../features/camiones/domain/usecases/update_camion.dart';
import '../../features/camiones/presentation/viewmodels/camiones_viewmodel.dart';
import '../../features/clientes/data/datasources/clientes_remote_data_source.dart';
import '../../features/clientes/data/repositories/clientes_repository_impl.dart';
import '../../features/clientes/domain/repositories/clientes_repository.dart';
import '../../features/clientes/domain/usecases/create_cliente.dart';
import '../../features/clientes/domain/usecases/delete_cliente.dart';
import '../../features/clientes/domain/usecases/get_clientes.dart';
import '../../features/clientes/domain/usecases/update_cliente.dart';
import '../../features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import '../../features/frutas/data/datasources/frutas_remote_data_source.dart';
import '../../features/frutas/data/repositories/frutas_repository_impl.dart';
import '../../features/frutas/domain/repositories/frutas_repository.dart';
import '../../features/frutas/domain/usecases/create_fruta.dart';
import '../../features/frutas/domain/usecases/delete_fruta.dart';
import '../../features/frutas/domain/usecases/get_frutas.dart';
import '../../features/frutas/domain/usecases/update_fruta.dart';
import '../../features/frutas/presentation/viewmodels/frutas_viewmodel.dart';
import '../../features/lugares_operativos/data/datasources/lugares_operativos_remote_data_source.dart';
import '../../features/lugares_operativos/data/repositories/lugares_operativos_repository_impl.dart';
import '../../features/lugares_operativos/domain/repositories/lugares_operativos_repository.dart';
import '../../features/lugares_operativos/domain/usecases/create_lugar_operativo.dart';
import '../../features/lugares_operativos/domain/usecases/delete_lugar_operativo.dart';
import '../../features/lugares_operativos/domain/usecases/get_lugares_operativos.dart';
import '../../features/lugares_operativos/domain/usecases/update_lugar_operativo.dart';
import '../../features/lugares_operativos/presentation/viewmodels/lugares_operativos_viewmodel.dart';
import '../../features/puestos/data/datasources/puestos_remote_data_source.dart';
import '../../features/puestos/data/repositories/puestos_repository_impl.dart';
import '../../features/puestos/domain/repositories/puestos_repository.dart';
import '../../features/puestos/domain/usecases/create_puesto.dart';
import '../../features/puestos/domain/usecases/delete_puesto.dart';
import '../../features/puestos/domain/usecases/get_puestos.dart';
import '../../features/puestos/domain/usecases/update_puesto.dart';
import '../../features/puestos/presentation/viewmodels/puestos_viewmodel.dart';
import '../../features/roles/data/datasources/roles_remote_data_source.dart';
import '../../features/roles/data/repositories/roles_repository_impl.dart';
import '../../features/roles/domain/repositories/roles_repository.dart';
import '../../features/roles/domain/usecases/get_roles.dart';
import '../../features/roles/presentation/viewmodels/roles_viewmodel.dart';
import '../../features/sedes/data/datasources/sedes_remote_data_source.dart';
import '../../features/sedes/data/repositories/sedes_repository_impl.dart';
import '../../features/sedes/domain/repositories/sedes_repository.dart';
import '../../features/sedes/domain/usecases/create_sede.dart';
import '../../features/sedes/domain/usecases/get_sedes.dart';
import '../../features/sedes/domain/usecases/update_sede.dart';
import '../../features/sedes/presentation/viewmodels/sedes_viewmodel.dart';
import '../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_theme_mode_usecase.dart';
import '../../features/settings/domain/usecases/save_theme_mode_usecase.dart';
import '../../features/settings/presentation/viewmodels/settings_viewmodel.dart';
import '../../features/tipos_jaba/data/datasources/tipos_jaba_remote_data_source.dart';
import '../../features/tipos_jaba/data/repositories/tipos_jaba_repository_impl.dart';
import '../../features/tipos_jaba/domain/repositories/tipos_jaba_repository.dart';
import '../../features/tipos_jaba/domain/usecases/create_tipos_jaba.dart';
import '../../features/tipos_jaba/domain/usecases/delete_tipos_jaba.dart';
import '../../features/tipos_jaba/domain/usecases/get_tipos_jaba.dart';
import '../../features/tipos_jaba/domain/usecases/update_tipos_jaba.dart';
import '../../features/tipos_jaba/presentation/viewmodels/tipos_jaba_viewmodel.dart';
import '../../features/usuarios/data/datasources/usuarios_remote_data_source.dart';
import '../../features/usuarios/data/repositories/usuarios_repository_impl.dart';
import '../../features/usuarios/domain/repositories/usuarios_repository.dart';
import '../../features/usuarios/domain/usecases/create_usuario.dart';
import '../../features/usuarios/domain/usecases/delete_usuario.dart';
import '../../features/usuarios/domain/usecases/get_usuarios.dart';
import '../../features/usuarios/domain/usecases/update_usuario.dart';
import '../../features/usuarios/presentation/viewmodels/usuarios_viewmodel.dart';
import '../../features/variedades/data/datasources/variedades_remote_data_source.dart';
import '../../features/variedades/data/repositories/variedades_repository_impl.dart';
import '../../features/variedades/domain/repositories/variedades_repository.dart';
import '../../features/variedades/domain/usecases/create_variedad.dart';
import '../../features/variedades/domain/usecases/delete_variedad.dart';
import '../../features/variedades/domain/usecases/get_variedades.dart';
import '../../features/variedades/domain/usecases/update_variedad.dart';
import '../../features/variedades/presentation/viewmodels/variedades_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProviders {
  const AppProviders._();

  static providers(SharedPreferences preferences) => [
    Provider<SharedPreferences>.value(value: preferences),
    Provider<ApiClient>(create: (_) => ApiClient()),
    Provider<NetworkChecker>(create: (_) => NetworkChecker()),
    ChangeNotifierProvider<ConnectivityViewModel>(
      create: (context) =>
          ConnectivityViewModel(networkChecker: context.read<NetworkChecker>())
            ..start(),
    ),
    Provider<AuthRemoteDataSource>(
      create: (context) => AuthRemoteDataSource(context.read<ApiClient>()),
    ),
    Provider<AuthRepository>(
      create: (context) => AuthRepositoryImpl(
        remoteDataSource: context.read<AuthRemoteDataSource>(),
        networkChecker: context.read<NetworkChecker>(),
      ),
    ),
    Provider<GetCurrentSessionUseCase>(
      create: (context) =>
          GetCurrentSessionUseCase(context.read<AuthRepository>()),
    ),
    Provider<LoginWithGoogleUseCase>(
      create: (context) =>
          LoginWithGoogleUseCase(context.read<AuthRepository>()),
    ),
    Provider<LogoutUseCase>(
      create: (context) => LogoutUseCase(context.read<AuthRepository>()),
    ),
    Provider<GetProfileUseCase>(
      create: (context) => GetProfileUseCase(context.read<AuthRepository>()),
    ),
    ChangeNotifierProvider<AuthViewModel>(
      create: (context) => AuthViewModel(
        getCurrentSessionUseCase: context.read<GetCurrentSessionUseCase>(),
        loginWithGoogleUseCase: context.read<LoginWithGoogleUseCase>(),
        logoutUseCase: context.read<LogoutUseCase>(),
        getProfileUseCase: context.read<GetProfileUseCase>(),
      ),
    ),

    Provider<CurrentSession>(
      create: (context) => AuthCurrentSession(context.read<AuthViewModel>()),
    ),
    Provider<AppRouter>(
      create: (context) => AppRouter(context.read<AuthViewModel>()),
    ),
    Provider<SettingsLocalDataSource>(
      create: (context) =>
          SettingsLocalDataSource(context.read<SharedPreferences>()),
    ),
    Provider<SettingsRepository>(
      create: (context) =>
          SettingsRepositoryImpl(context.read<SettingsLocalDataSource>()),
    ),
    Provider<GetThemeModeUseCase>(
      create: (context) =>
          GetThemeModeUseCase(context.read<SettingsRepository>()),
    ),
    Provider<SaveThemeModeUseCase>(
      create: (context) =>
          SaveThemeModeUseCase(context.read<SettingsRepository>()),
    ),
    ChangeNotifierProvider<SettingsViewModel>(
      create: (context) => SettingsViewModel(
        getThemeModeUseCase: context.read<GetThemeModeUseCase>(),
        saveThemeModeUseCase: context.read<SaveThemeModeUseCase>(),
      ),
    ),
    Provider<RolesRemoteDataSource>(
      create: (context) => RolesRemoteDataSource(context.read<ApiClient>()),
    ),
    Provider<RolesRepository>(
      create: (context) =>
          RolesRepositoryImpl(context.read<RolesRemoteDataSource>()),
    ),
    Provider<GetRolesUseCase>(
      create: (context) => GetRolesUseCase(context.read<RolesRepository>()),
    ),
    ChangeNotifierProvider<RolesViewModel>(
      create: (context) => RolesViewModel(context.read<GetRolesUseCase>()),
    ),
    Provider<SedeRemoteDataSource>(
      create: (context) => SedeRemoteDataSource(context.read<ApiClient>()),
    ),
    Provider<SedeRepository>(
      create: (context) => SedeRepositoryImpl(
        remoteDataSource: context.read<SedeRemoteDataSource>(),
        networkChecker: context.read<NetworkChecker>(),
      ),
    ),
    Provider<GetSedesUseCase>(
      create: (context) => GetSedesUseCase(context.read<SedeRepository>()),
    ),
    Provider<CreateSedeUseCase>(
      create: (context) => CreateSedeUseCase(
        repository: context.read<SedeRepository>(),
        currentSession: context.read<CurrentSession>(),
      ),
    ),
    Provider<UpdateSedeUseCase>(
      create: (context) => UpdateSedeUseCase(context.read<SedeRepository>()),
    ),
    Provider<ChangeSedeStatusUseCase>(
  create: (context) => ChangeSedeStatusUseCase(
    context.read<SedeRepository>(),
  ),
),
    ChangeNotifierProvider<SedeViewModel>(
  create: (context) => SedeViewModel(
    getItemsUseCase: context.read<GetSedesUseCase>(),
    createUseCase: context.read<CreateSedeUseCase>(),
    updateUseCase: context.read<UpdateSedeUseCase>(),
    changeStatusUseCase: context.read<ChangeSedeStatusUseCase>(),
  ),
),
    Provider<LugarOperativoRemoteDataSource>(
      create: (context) =>
          LugarOperativoRemoteDataSource(context.read<ApiClient>()),
    ),
    Provider<LugarOperativoRepository>(
      create: (context) => LugarOperativoRepositoryImpl(
        context.read<LugarOperativoRemoteDataSource>(),
      ),
    ),
    Provider<GetLugaresOperativosUseCase>(
      create: (context) =>
          GetLugaresOperativosUseCase(context.read<LugarOperativoRepository>()),
    ),
    Provider<CreateLugarOperativoUseCase>(
      create: (context) =>
          CreateLugarOperativoUseCase(context.read<LugarOperativoRepository>()),
    ),
    Provider<UpdateLugarOperativoUseCase>(
      create: (context) =>
          UpdateLugarOperativoUseCase(context.read<LugarOperativoRepository>()),
    ),
    Provider<DeleteLugarOperativoUseCase>(
      create: (context) =>
          DeleteLugarOperativoUseCase(context.read<LugarOperativoRepository>()),
    ),
    ChangeNotifierProvider<LugarOperativoViewModel>(
      create: (context) => LugarOperativoViewModel(
        getItemsUseCase: context.read<GetLugaresOperativosUseCase>(),
        createUseCase: context.read<CreateLugarOperativoUseCase>(),
        updateUseCase: context.read<UpdateLugarOperativoUseCase>(),
        deleteUseCase: context.read<DeleteLugarOperativoUseCase>(),
        networkChecker: context.read<NetworkChecker>(),
      ),
    ),
    Provider<PuestoRemoteDataSource>(
      create: (context) => PuestoRemoteDataSource(context.read<ApiClient>()),
    ),
    Provider<PuestoRepository>(
      create: (context) =>
          PuestoRepositoryImpl(context.read<PuestoRemoteDataSource>()),
    ),
    Provider<GetPuestosUseCase>(
      create: (context) => GetPuestosUseCase(context.read<PuestoRepository>()),
    ),
    Provider<CreatePuestoUseCase>(
      create: (context) =>
          CreatePuestoUseCase(context.read<PuestoRepository>()),
    ),
    Provider<UpdatePuestoUseCase>(
      create: (context) =>
          UpdatePuestoUseCase(context.read<PuestoRepository>()),
    ),
    Provider<DeletePuestoUseCase>(
      create: (context) =>
          DeletePuestoUseCase(context.read<PuestoRepository>()),
    ),
    ChangeNotifierProvider<PuestoViewModel>(
      create: (context) => PuestoViewModel(
        getItemsUseCase: context.read<GetPuestosUseCase>(),
        createUseCase: context.read<CreatePuestoUseCase>(),
        updateUseCase: context.read<UpdatePuestoUseCase>(),
        deleteUseCase: context.read<DeletePuestoUseCase>(),
        networkChecker: context.read<NetworkChecker>(),
      ),
    ),
    Provider<FrutaRemoteDataSource>(
      create: (context) => FrutaRemoteDataSource(context.read<ApiClient>()),
    ),
    Provider<FrutaRepository>(
      create: (context) =>
          FrutaRepositoryImpl(context.read<FrutaRemoteDataSource>()),
    ),
    Provider<GetFrutasUseCase>(
      create: (context) => GetFrutasUseCase(context.read<FrutaRepository>()),
    ),
    Provider<CreateFrutaUseCase>(
      create: (context) => CreateFrutaUseCase(context.read<FrutaRepository>()),
    ),
    Provider<UpdateFrutaUseCase>(
      create: (context) => UpdateFrutaUseCase(context.read<FrutaRepository>()),
    ),
    Provider<DeleteFrutaUseCase>(
      create: (context) => DeleteFrutaUseCase(context.read<FrutaRepository>()),
    ),
    ChangeNotifierProvider<FrutaViewModel>(
      create: (context) => FrutaViewModel(
        getItemsUseCase: context.read<GetFrutasUseCase>(),
        createUseCase: context.read<CreateFrutaUseCase>(),
        updateUseCase: context.read<UpdateFrutaUseCase>(),
        deleteUseCase: context.read<DeleteFrutaUseCase>(),
        networkChecker: context.read<NetworkChecker>(),
      ),
    ),
    Provider<VariedadRemoteDataSource>(
      create: (context) => VariedadRemoteDataSource(context.read<ApiClient>()),
    ),
    Provider<VariedadRepository>(
      create: (context) =>
          VariedadRepositoryImpl(context.read<VariedadRemoteDataSource>()),
    ),
    Provider<GetVariedadesUseCase>(
      create: (context) =>
          GetVariedadesUseCase(context.read<VariedadRepository>()),
    ),
    Provider<CreateVariedadUseCase>(
      create: (context) =>
          CreateVariedadUseCase(context.read<VariedadRepository>()),
    ),
    Provider<UpdateVariedadUseCase>(
      create: (context) =>
          UpdateVariedadUseCase(context.read<VariedadRepository>()),
    ),
    Provider<DeleteVariedadUseCase>(
      create: (context) =>
          DeleteVariedadUseCase(context.read<VariedadRepository>()),
    ),
    ChangeNotifierProvider<VariedadViewModel>(
      create: (context) => VariedadViewModel(
        getItemsUseCase: context.read<GetVariedadesUseCase>(),
        createUseCase: context.read<CreateVariedadUseCase>(),
        updateUseCase: context.read<UpdateVariedadUseCase>(),
        deleteUseCase: context.read<DeleteVariedadUseCase>(),
        networkChecker: context.read<NetworkChecker>(),
      ),
    ),
    Provider<CalidadRemoteDataSource>(
      create: (context) => CalidadRemoteDataSource(context.read<ApiClient>()),
    ),
    Provider<CalidadRepository>(
      create: (context) =>
          CalidadRepositoryImpl(context.read<CalidadRemoteDataSource>()),
    ),
    Provider<GetCalidadesUseCase>(
      create: (context) =>
          GetCalidadesUseCase(context.read<CalidadRepository>()),
    ),
    Provider<CreateCalidadUseCase>(
      create: (context) =>
          CreateCalidadUseCase(context.read<CalidadRepository>()),
    ),
    Provider<UpdateCalidadUseCase>(
      create: (context) =>
          UpdateCalidadUseCase(context.read<CalidadRepository>()),
    ),
    Provider<DeleteCalidadUseCase>(
      create: (context) =>
          DeleteCalidadUseCase(context.read<CalidadRepository>()),
    ),
    ChangeNotifierProvider<CalidadViewModel>(
      create: (context) => CalidadViewModel(
        getItemsUseCase: context.read<GetCalidadesUseCase>(),
        createUseCase: context.read<CreateCalidadUseCase>(),
        updateUseCase: context.read<UpdateCalidadUseCase>(),
        deleteUseCase: context.read<DeleteCalidadUseCase>(),
        networkChecker: context.read<NetworkChecker>(),
      ),
    ),
    Provider<TipoJabaRemoteDataSource>(
      create: (context) => TipoJabaRemoteDataSource(context.read<ApiClient>()),
    ),
    Provider<TipoJabaRepository>(
      create: (context) =>
          TipoJabaRepositoryImpl(context.read<TipoJabaRemoteDataSource>()),
    ),
    Provider<GetTiposJabaUseCase>(
      create: (context) =>
          GetTiposJabaUseCase(context.read<TipoJabaRepository>()),
    ),
    Provider<CreateTipoJabaUseCase>(
      create: (context) =>
          CreateTipoJabaUseCase(context.read<TipoJabaRepository>()),
    ),
    Provider<UpdateTipoJabaUseCase>(
      create: (context) =>
          UpdateTipoJabaUseCase(context.read<TipoJabaRepository>()),
    ),
    Provider<DeleteTipoJabaUseCase>(
      create: (context) =>
          DeleteTipoJabaUseCase(context.read<TipoJabaRepository>()),
    ),
    ChangeNotifierProvider<TipoJabaViewModel>(
      create: (context) => TipoJabaViewModel(
        getItemsUseCase: context.read<GetTiposJabaUseCase>(),
        createUseCase: context.read<CreateTipoJabaUseCase>(),
        updateUseCase: context.read<UpdateTipoJabaUseCase>(),
        deleteUseCase: context.read<DeleteTipoJabaUseCase>(),
        networkChecker: context.read<NetworkChecker>(),
      ),
    ),
    Provider<CamionRemoteDataSource>(
      create: (context) => CamionRemoteDataSource(context.read<ApiClient>()),
    ),
    Provider<CamionRepository>(
      create: (context) =>
          CamionRepositoryImpl(context.read<CamionRemoteDataSource>()),
    ),
    Provider<GetCamionesUseCase>(
      create: (context) => GetCamionesUseCase(context.read<CamionRepository>()),
    ),
    Provider<CreateCamionUseCase>(
      create: (context) =>
          CreateCamionUseCase(context.read<CamionRepository>()),
    ),
    Provider<UpdateCamionUseCase>(
      create: (context) =>
          UpdateCamionUseCase(context.read<CamionRepository>()),
    ),
    Provider<DeleteCamionUseCase>(
      create: (context) =>
          DeleteCamionUseCase(context.read<CamionRepository>()),
    ),
    ChangeNotifierProvider<CamionViewModel>(
      create: (context) => CamionViewModel(
        getItemsUseCase: context.read<GetCamionesUseCase>(),
        createUseCase: context.read<CreateCamionUseCase>(),
        updateUseCase: context.read<UpdateCamionUseCase>(),
        deleteUseCase: context.read<DeleteCamionUseCase>(),
        networkChecker: context.read<NetworkChecker>(),
      ),
    ),
    Provider<UsuarioRemoteDataSource>(
      create: (context) => UsuarioRemoteDataSource(context.read<ApiClient>()),
    ),
    Provider<UsuarioRepository>(
      create: (context) =>
          UsuarioRepositoryImpl(context.read<UsuarioRemoteDataSource>()),
    ),
    Provider<GetUsuariosUseCase>(
      create: (context) =>
          GetUsuariosUseCase(context.read<UsuarioRepository>()),
    ),
    Provider<CreateUsuarioUseCase>(
      create: (context) =>
          CreateUsuarioUseCase(context.read<UsuarioRepository>()),
    ),
    Provider<UpdateUsuarioUseCase>(
      create: (context) =>
          UpdateUsuarioUseCase(context.read<UsuarioRepository>()),
    ),
    Provider<DeleteUsuarioUseCase>(
      create: (context) =>
          DeleteUsuarioUseCase(context.read<UsuarioRepository>()),
    ),
    ChangeNotifierProvider<UsuarioViewModel>(
      create: (context) => UsuarioViewModel(
        getItemsUseCase: context.read<GetUsuariosUseCase>(),
        createUseCase: context.read<CreateUsuarioUseCase>(),
        updateUseCase: context.read<UpdateUsuarioUseCase>(),
        deleteUseCase: context.read<DeleteUsuarioUseCase>(),
        networkChecker: context.read<NetworkChecker>(),
      ),
    ),
    Provider<ClienteRemoteDataSource>(
      create: (context) => ClienteRemoteDataSource(context.read<ApiClient>()),
    ),
    Provider<ClienteRepository>(
      create: (context) =>
          ClienteRepositoryImpl(context.read<ClienteRemoteDataSource>()),
    ),
    Provider<GetClientesUseCase>(
      create: (context) =>
          GetClientesUseCase(context.read<ClienteRepository>()),
    ),
    Provider<CreateClienteUseCase>(
      create: (context) =>
          CreateClienteUseCase(context.read<ClienteRepository>()),
    ),
    Provider<UpdateClienteUseCase>(
      create: (context) =>
          UpdateClienteUseCase(context.read<ClienteRepository>()),
    ),
    Provider<DeleteClienteUseCase>(
      create: (context) =>
          DeleteClienteUseCase(context.read<ClienteRepository>()),
    ),
    ChangeNotifierProvider<ClienteViewModel>(
      create: (context) => ClienteViewModel(
        getItemsUseCase: context.read<GetClientesUseCase>(),
        createUseCase: context.read<CreateClienteUseCase>(),
        updateUseCase: context.read<UpdateClienteUseCase>(),
        deleteUseCase: context.read<DeleteClienteUseCase>(),
        networkChecker: context.read<NetworkChecker>(),
      ),
    ),
  ];
}
