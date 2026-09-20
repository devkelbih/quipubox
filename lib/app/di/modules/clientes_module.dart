import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:quipubox/core/network/network_checker.dart';

import 'package:quipubox/features/clientes/data/datasources/clientes_remote_data_source.dart';
import 'package:quipubox/features/clientes/data/repositories/clientes_repository_impl.dart';
import 'package:quipubox/features/clientes/domain/repositories/clientes_repository.dart';
import 'package:quipubox/features/clientes/domain/usecases/create_cliente.dart';
import 'package:quipubox/features/clientes/domain/usecases/delete_cliente.dart';
import 'package:quipubox/features/clientes/domain/usecases/get_clientes.dart';
import 'package:quipubox/features/clientes/domain/usecases/update_cliente.dart';
import 'package:quipubox/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';

class ClientesModule {
  const ClientesModule._();

  static List<SingleChildWidget> get providers => [
        Provider<ClienteRemoteDataSource>(
          create: (context) => ClienteRemoteDataSource(
            apiClient: context.read(),
          ),
        ),

        Provider<ClienteRepository>(
          create: (context) => ClienteRepositoryImpl(
            remoteDataSource: context.read(),
          ),
        ),

        Provider<GetClientesUseCase>(
          create: (context) => GetClientesUseCase(
            repository: context.read(),
          ),
        ),

        Provider<CreateClienteUseCase>(
          create: (context) => CreateClienteUseCase(
            repository: context.read(),
          ),
        ),

        Provider<UpdateClienteUseCase>(
          create: (context) => UpdateClienteUseCase(
            repository: context.read(),
          ),
        ),

        Provider<DeleteClienteUseCase>(
          create: (context) => DeleteClienteUseCase(
            repository: context.read(),
          ),
        ),

        ChangeNotifierProvider<ClienteViewModel>(
          create: (context) => ClienteViewModel(
            getItemsUseCase: context.read(),
            createUseCase: context.read(),
            updateUseCase: context.read(),
            deleteUseCase: context.read(),
            networkChecker: context.read<NetworkChecker>(),
          ),
        ),
      ];
}