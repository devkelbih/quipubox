import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:quipubox/features/clientes/data/datasources/clientes_remote_data_source.dart';
import 'package:quipubox/features/clientes/data/repositories/clientes_repository_impl.dart';
import 'package:quipubox/features/clientes/domain/repositories/clientes_repository.dart';
import 'package:quipubox/features/clientes/domain/usecases/change_cliente_estado.dart';
import 'package:quipubox/features/clientes/domain/usecases/create_cliente.dart';
import 'package:quipubox/features/clientes/domain/usecases/get_clientes.dart';
import 'package:quipubox/features/clientes/domain/usecases/update_cliente.dart';
import 'package:quipubox/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';

class ClientesModule {
  const ClientesModule._();

  static List<SingleChildWidget> get providers => [
    Provider<ClienteRemoteDataSource>(
      create: (context) => ClienteRemoteDataSource(apiClient: context.read()),
    ),

    Provider<ClienteRepository>(
      create: (context) =>
          ClienteRepositoryImpl(remoteDataSource: context.read()),
    ),

    Provider<GetClientesUseCase>(
      create: (context) => GetClientesUseCase(repository: context.read()),
    ),

    Provider<CreateClienteUseCase>(
      create: (context) => CreateClienteUseCase(
        repository: context.read(),
        currentSession: context.read(),
      ),
    ),

    Provider<UpdateClienteUseCase>(
      create: (context) => UpdateClienteUseCase(repository: context.read()),
    ),

    Provider<ChangeClienteEstadoUseCase>(
      create: (context) =>
          ChangeClienteEstadoUseCase(repository: context.read()),
    ),

    ChangeNotifierProvider<ClienteViewModel>(
      create: (context) => ClienteViewModel(
        getItemsUseCase: context.read(),
        createUseCase: context.read(),
        updateUseCase: context.read(),
        changeStatusUseCase: context.read(),
      ),
    ),
  ];
}
