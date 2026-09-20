import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:quipubox/features/puestos/data/datasources/puestos_remote_data_source.dart';
import 'package:quipubox/features/puestos/data/repositories/puestos_repository_impl.dart';
import 'package:quipubox/features/puestos/domain/repositories/puestos_repository.dart';
import 'package:quipubox/features/puestos/domain/usecases/change_puesto_status.dart';
import 'package:quipubox/features/puestos/domain/usecases/create_puesto.dart';
import 'package:quipubox/features/puestos/domain/usecases/get_puestos.dart';
import 'package:quipubox/features/puestos/domain/usecases/update_puesto.dart';
import 'package:quipubox/features/puestos/presentation/viewmodels/puestos_viewmodel.dart';

class PuestosModule {
  const PuestosModule._();

  static List<SingleChildWidget> get providers => [
        Provider<PuestoRemoteDataSource>(
          create: (context) => PuestoRemoteDataSource(
            apiClient: context.read(),
          ),
        ),

        Provider<PuestoRepository>(
          create: (context) => PuestoRepositoryImpl(
            remoteDataSource: context.read(),
          ),
        ),

        Provider<GetPuestosUseCase>(
          create: (context) => GetPuestosUseCase(
            repository: context.read(),
          ),
        ),

        Provider<CreatePuestoUseCase>(
          create: (context) => CreatePuestoUseCase(
            repository: context.read(),
            currentSession: context.read(),
          ),
        ),

        Provider<UpdatePuestoUseCase>(
          create: (context) => UpdatePuestoUseCase(
            repository: context.read(),
          ),
        ),

        Provider<ChangePuestoStatusUseCase>(
          create: (context) => ChangePuestoStatusUseCase(
            repository: context.read(),
          ),
        ),

        ChangeNotifierProvider<PuestoViewModel>(
          create: (context) => PuestoViewModel(
            getItemsUseCase: context.read(),
            createUseCase: context.read(),
            updateUseCase: context.read(),
            changeStatusUseCase: context.read(),
          ),
        ),
      ];
}