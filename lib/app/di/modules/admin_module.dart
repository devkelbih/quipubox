import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/network_checker.dart';
import '../../../core/session/current_session.dart';

import '../../../features/roles/data/datasources/roles_remote_data_source.dart';
import '../../../features/roles/data/repositories/roles_repository_impl.dart';
import '../../../features/roles/domain/repositories/roles_repository.dart';
import '../../../features/roles/domain/usecases/get_roles.dart';
import '../../../features/roles/presentation/viewmodels/roles_viewmodel.dart';

import '../../../features/sedes/data/datasources/sedes_remote_data_source.dart';
import '../../../features/sedes/data/repositories/sedes_repository_impl.dart';
import '../../../features/sedes/domain/repositories/sedes_repository.dart';
import '../../../features/sedes/domain/usecases/change_sede_status.dart';
import '../../../features/sedes/domain/usecases/create_sede.dart';
import '../../../features/sedes/domain/usecases/get_sedes.dart';
import '../../../features/sedes/domain/usecases/update_sede.dart';
import '../../../features/sedes/presentation/viewmodels/sedes_viewmodel.dart';

import '../../../features/lugares_operativos/data/datasources/lugares_operativos_remote_data_source.dart';
import '../../../features/lugares_operativos/data/repositories/lugares_operativos_repository_impl.dart';
import '../../../features/lugares_operativos/domain/repositories/lugares_operativos_repository.dart';
import '../../../features/lugares_operativos/domain/usecases/create_lugar_operativo.dart';
import '../../../features/lugares_operativos/domain/usecases/delete_lugar_operativo.dart';
import '../../../features/lugares_operativos/domain/usecases/get_lugares_operativos.dart';
import '../../../features/lugares_operativos/domain/usecases/update_lugar_operativo.dart';
import '../../../features/lugares_operativos/presentation/viewmodels/lugares_operativos_viewmodel.dart';

import '../../../features/puestos/data/datasources/puestos_remote_data_source.dart';
import '../../../features/puestos/data/repositories/puestos_repository_impl.dart';
import '../../../features/puestos/domain/repositories/puestos_repository.dart';
import '../../../features/puestos/domain/usecases/create_puesto.dart';
import '../../../features/puestos/domain/usecases/delete_puesto.dart';
import '../../../features/puestos/domain/usecases/get_puestos.dart';
import '../../../features/puestos/domain/usecases/update_puesto.dart';
import '../../../features/puestos/presentation/viewmodels/puestos_viewmodel.dart';

import '../../../features/usuarios/data/datasources/usuarios_remote_data_source.dart';
import '../../../features/usuarios/data/repositories/usuarios_repository_impl.dart';
import '../../../features/usuarios/domain/repositories/usuarios_repository.dart';
import '../../../features/usuarios/domain/usecases/create_usuario.dart';
import '../../../features/usuarios/domain/usecases/delete_usuario.dart';
import '../../../features/usuarios/domain/usecases/get_usuarios.dart';
import '../../../features/usuarios/domain/usecases/update_usuario.dart';
import '../../../features/usuarios/presentation/viewmodels/usuarios_viewmodel.dart';

import '../../../features/clientes/data/datasources/clientes_remote_data_source.dart';
import '../../../features/clientes/data/repositories/clientes_repository_impl.dart';
import '../../../features/clientes/domain/repositories/clientes_repository.dart';
import '../../../features/clientes/domain/usecases/create_cliente.dart';
import '../../../features/clientes/domain/usecases/delete_cliente.dart';
import '../../../features/clientes/domain/usecases/get_clientes.dart';
import '../../../features/clientes/domain/usecases/update_cliente.dart';
import '../../../features/clientes/presentation/viewmodels/clientes_viewmodel.dart';

class AdminModule {
  const AdminModule._();

  static List<SingleChildWidget> providers = [
    // Roles

    Provider<RolesRemoteDataSource>(
      create: (context) => RolesRemoteDataSource(
        context.read<ApiClient>(),
      ),
    ),

    Provider<RolesRepository>(
      create: (context) => RolesRepositoryImpl(
        context.read<RolesRemoteDataSource>(),
      ),
    ),

    Provider<GetRolesUseCase>(
      create: (context) => GetRolesUseCase(
        context.read<RolesRepository>(),
      ),
    ),

    ChangeNotifierProvider<RolesViewModel>(
      create: (context) => RolesViewModel(
        context.read<GetRolesUseCase>(),
      ),
    ),

    // Sedes

    Provider<SedeRemoteDataSource>(
      create: (context) => SedeRemoteDataSource(
        context.read<ApiClient>(),
      ),
    ),

    Provider<SedeRepository>(
      create: (context) => SedeRepositoryImpl(
        remoteDataSource: context.read<SedeRemoteDataSource>(),
      ),
    ),

    Provider<GetSedesUseCase>(
      create: (context) => GetSedesUseCase(
        context.read<SedeRepository>(),
      ),
    ),

    Provider<CreateSedeUseCase>(
      create: (context) => CreateSedeUseCase(
        repository: context.read<SedeRepository>(),
        currentSession: context.read<CurrentSession>(),
      ),
    ),

    Provider<UpdateSedeUseCase>(
      create: (context) => UpdateSedeUseCase(
        context.read<SedeRepository>(),
      ),
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

    // Lugares operativos

    Provider<LugarOperativoRemoteDataSource>(
      create: (context) => LugarOperativoRemoteDataSource(
        context.read<ApiClient>(),
      ),
    ),

    Provider<LugarOperativoRepository>(
      create: (context) => LugarOperativoRepositoryImpl(
        context.read<LugarOperativoRemoteDataSource>(),
      ),
    ),

    Provider<GetLugaresOperativosUseCase>(
      create: (context) => GetLugaresOperativosUseCase(
        context.read<LugarOperativoRepository>(),
      ),
    ),

    Provider<CreateLugarOperativoUseCase>(
      create: (context) => CreateLugarOperativoUseCase(
        context.read<LugarOperativoRepository>(),
      ),
    ),

    Provider<UpdateLugarOperativoUseCase>(
      create: (context) => UpdateLugarOperativoUseCase(
        context.read<LugarOperativoRepository>(),
      ),
    ),

    Provider<DeleteLugarOperativoUseCase>(
      create: (context) => DeleteLugarOperativoUseCase(
        context.read<LugarOperativoRepository>(),
      ),
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

    // Puestos

    Provider<PuestoRemoteDataSource>(
      create: (context) => PuestoRemoteDataSource(
        context.read<ApiClient>(),
      ),
    ),

    Provider<PuestoRepository>(
      create: (context) => PuestoRepositoryImpl(
        context.read<PuestoRemoteDataSource>(),
      ),
    ),

    Provider<GetPuestosUseCase>(
      create: (context) => GetPuestosUseCase(
        context.read<PuestoRepository>(),
      ),
    ),

    Provider<CreatePuestoUseCase>(
      create: (context) => CreatePuestoUseCase(
        context.read<PuestoRepository>(),
      ),
    ),

    Provider<UpdatePuestoUseCase>(
      create: (context) => UpdatePuestoUseCase(
        context.read<PuestoRepository>(),
      ),
    ),

    Provider<DeletePuestoUseCase>(
      create: (context) => DeletePuestoUseCase(
        context.read<PuestoRepository>(),
      ),
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

    // Usuarios

    Provider<UsuarioRemoteDataSource>(
      create: (context) => UsuarioRemoteDataSource(
        context.read<ApiClient>(),
      ),
    ),

    Provider<UsuarioRepository>(
      create: (context) => UsuarioRepositoryImpl(
        context.read<UsuarioRemoteDataSource>(),
      ),
    ),

    Provider<GetUsuariosUseCase>(
      create: (context) => GetUsuariosUseCase(
        context.read<UsuarioRepository>(),
      ),
    ),

    Provider<CreateUsuarioUseCase>(
      create: (context) => CreateUsuarioUseCase(
        context.read<UsuarioRepository>(),
      ),
    ),

    Provider<UpdateUsuarioUseCase>(
      create: (context) => UpdateUsuarioUseCase(
        context.read<UsuarioRepository>(),
      ),
    ),

    Provider<DeleteUsuarioUseCase>(
      create: (context) => DeleteUsuarioUseCase(
        context.read<UsuarioRepository>(),
      ),
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

    // Clientes

    Provider<ClienteRemoteDataSource>(
      create: (context) => ClienteRemoteDataSource(
        context.read<ApiClient>(),
      ),
    ),

    Provider<ClienteRepository>(
      create: (context) => ClienteRepositoryImpl(
        context.read<ClienteRemoteDataSource>(),
      ),
    ),

    Provider<GetClientesUseCase>(
      create: (context) => GetClientesUseCase(
        context.read<ClienteRepository>(),
      ),
    ),

    Provider<CreateClienteUseCase>(
      create: (context) => CreateClienteUseCase(
        context.read<ClienteRepository>(),
      ),
    ),

    Provider<UpdateClienteUseCase>(
      create: (context) => UpdateClienteUseCase(
        context.read<ClienteRepository>(),
      ),
    ),

    Provider<DeleteClienteUseCase>(
      create: (context) => DeleteClienteUseCase(
        context.read<ClienteRepository>(),
      ),
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