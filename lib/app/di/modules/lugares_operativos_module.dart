import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:quipubox/features/lugares_operativos/data/datasources/lugares_operativos_remote_data_source.dart';
import 'package:quipubox/features/lugares_operativos/data/repositories/lugares_operativos_repository_impl.dart';
import 'package:quipubox/features/lugares_operativos/domain/repositories/lugares_operativos_repository.dart';
import 'package:quipubox/features/lugares_operativos/domain/usecases/change_lugar_operativo_status.dart';
import 'package:quipubox/features/lugares_operativos/domain/usecases/create_lugar_operativo.dart';
import 'package:quipubox/features/lugares_operativos/domain/usecases/get_lugares_operativos.dart';
import 'package:quipubox/features/lugares_operativos/domain/usecases/update_lugar_operativo.dart';
import 'package:quipubox/features/lugares_operativos/presentation/viewmodels/lugares_operativos_viewmodel.dart';

class LugaresOperativosModule {
  const LugaresOperativosModule._();

  static List<SingleChildWidget> get providers => [
        Provider<LugarOperativoRemoteDataSource>(
          create: (context) => LugarOperativoRemoteDataSource(
            apiClient: context.read(),
          ),
        ),

        Provider<LugarOperativoRepository>(
          create: (context) => LugarOperativoRepositoryImpl(
            remoteDataSource: context.read(),
          ),
        ),

        Provider<GetLugaresOperativosUseCase>(
          create: (context) => GetLugaresOperativosUseCase(
            repository: context.read(),
          ),
        ),

        Provider<CreateLugarOperativoUseCase>(
          create: (context) => CreateLugarOperativoUseCase(
            repository: context.read(),
            currentSession: context.read(),
          ),
        ),

        Provider<UpdateLugarOperativoUseCase>(
          create: (context) => UpdateLugarOperativoUseCase(
            repository: context.read(),
          ),
        ),

        Provider<ChangeLugarOperativoStatusUseCase>(
          create: (context) => ChangeLugarOperativoStatusUseCase(
            repository: context.read(),
          ),
        ),

        ChangeNotifierProvider<LugarOperativoViewModel>(
          create: (context) => LugarOperativoViewModel(
            getItemsUseCase: context.read(),
            createUseCase: context.read(),
            updateUseCase: context.read(),
            changeStatusUseCase: context.read(),
          ),
        ),
      ];
}