import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:quipubox/features/usuarios/data/datasources/usuarios_remote_data_source.dart';
import 'package:quipubox/features/usuarios/data/repositories/usuarios_repository_impl.dart';
import 'package:quipubox/features/usuarios/domain/repositories/usuarios_repository.dart';
import 'package:quipubox/features/usuarios/domain/usecases/add_usuario_role.dart';
import 'package:quipubox/features/usuarios/domain/usecases/change_usuario_status.dart';
import 'package:quipubox/features/usuarios/domain/usecases/create_usuario.dart';
import 'package:quipubox/features/usuarios/domain/usecases/get_usuarios.dart';
import 'package:quipubox/features/usuarios/domain/usecases/remove_usuario_role.dart';
import 'package:quipubox/features/usuarios/domain/usecases/update_usuario.dart';
import 'package:quipubox/features/usuarios/presentation/viewmodels/usuarios_viewmodel.dart';

class UsuariosModule {
  const UsuariosModule._();

  static List<SingleChildWidget> get providers => [
        Provider<UsuarioRemoteDataSource>(
          create: (context) => UsuarioRemoteDataSource(
            apiClient: context.read(),
          ),
        ),

        Provider<UsuarioRepository>(
          create: (context) => UsuarioRepositoryImpl(
            remoteDataSource: context.read(),
          ),
        ),

        Provider<GetUsuariosUseCase>(
          create: (context) => GetUsuariosUseCase(
            repository: context.read(),
          ),
        ),

        Provider<CreateUsuarioUseCase>(
          create: (context) => CreateUsuarioUseCase(
            repository: context.read(),
            currentSession: context.read(),
          ),
        ),

        Provider<UpdateUsuarioUseCase>(
          create: (context) => UpdateUsuarioUseCase(
            repository: context.read(),
          ),
        ),

        Provider<ChangeUsuarioStatusUseCase>(
          create: (context) => ChangeUsuarioStatusUseCase(
            repository: context.read(),
          ),
        ),

        Provider<AddUsuarioRoleUseCase>(
          create: (context) => AddUsuarioRoleUseCase(
            repository: context.read(),
          ),
        ),

        Provider<RemoveUsuarioRoleUseCase>(
          create: (context) => RemoveUsuarioRoleUseCase(
            repository: context.read(),
          ),
        ),

        ChangeNotifierProvider<UsuarioViewModel>(
          create: (context) => UsuarioViewModel(
            getItemsUseCase: context.read(),
            createUseCase: context.read(),
            updateUseCase: context.read(),
            changeStatusUseCase: context.read(),
            addRoleUseCase: context.read(),
            removeRoleUseCase: context.read(),
          ),
        ),
      ];
}