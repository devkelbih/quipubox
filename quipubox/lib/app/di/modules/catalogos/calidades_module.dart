import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:quipubox/features/catalogos/calidades/data/datasources/calidad_remote_data_source.dart';
import 'package:quipubox/features/catalogos/calidades/data/repositories/calidad_repository_impl.dart';
import 'package:quipubox/features/catalogos/calidades/domain/repositories/calidad_repository.dart';
import 'package:quipubox/features/catalogos/calidades/domain/usecases/change_calidad_status.dart';
import 'package:quipubox/features/catalogos/calidades/domain/usecases/create_calidad.dart';
import 'package:quipubox/features/catalogos/calidades/domain/usecases/get_calidades.dart';
import 'package:quipubox/features/catalogos/calidades/domain/usecases/update_calidad.dart';
import 'package:quipubox/features/catalogos/calidades/presentation/viewmodels/calidades_viewmodel.dart';

class CalidadesModule {
  const CalidadesModule._();

  static List<SingleChildWidget> get providers => [
        Provider<CalidadRemoteDataSource>(
          create: (context) => CalidadRemoteDataSource(
            apiClient: context.read(),
          ),
        ),

        Provider<CalidadRepository>(
          create: (context) => CalidadRepositoryImpl(
            remoteDataSource: context.read(),
          ),
        ),

        Provider<GetCalidadesUseCase>(
          create: (context) => GetCalidadesUseCase(
            repository: context.read(),
          ),
        ),

        Provider<CreateCalidadUseCase>(
          create: (context) => CreateCalidadUseCase(
            repository: context.read(),
            currentSession: context.read(),
          ),
        ),

        Provider<UpdateCalidadUseCase>(
          create: (context) => UpdateCalidadUseCase(
            repository: context.read(),
          ),
        ),

        Provider<ChangeCalidadStatusUseCase>(
          create: (context) => ChangeCalidadStatusUseCase(
            repository: context.read(),
          ),
        ),

        ChangeNotifierProvider<CalidadViewModel>(
          create: (context) => CalidadViewModel(
            getItemsUseCase: context.read(),
            createUseCase: context.read(),
            updateUseCase: context.read(),
            changeStatusUseCase: context.read(),
          ),
        ),
      ];
}