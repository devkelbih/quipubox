import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:quipubox/features/camiones/data/datasources/camiones_remote_data_source.dart';
import 'package:quipubox/features/camiones/data/repositories/camiones_repository_impl.dart';
import 'package:quipubox/features/camiones/domain/repositories/camiones_repository.dart';
import 'package:quipubox/features/camiones/domain/usecases/change_camion_status.dart';
import 'package:quipubox/features/camiones/domain/usecases/create_camion.dart';
import 'package:quipubox/features/camiones/domain/usecases/get_camiones.dart';
import 'package:quipubox/features/camiones/domain/usecases/update_camion.dart';
import 'package:quipubox/features/camiones/presentation/viewmodels/camiones_viewmodel.dart';

class CamionesModule {
  const CamionesModule._();

  static List<SingleChildWidget> get providers => [
        Provider<CamionRemoteDataSource>(
          create: (context) => CamionRemoteDataSource(
            apiClient: context.read(),
          ),
        ),

        Provider<CamionRepository>(
          create: (context) => CamionRepositoryImpl(
            remoteDataSource: context.read(),
          ),
        ),

        Provider<GetCamionesUseCase>(
          create: (context) => GetCamionesUseCase(
            repository: context.read(),
          ),
        ),

        Provider<CreateCamionUseCase>(
          create: (context) => CreateCamionUseCase(
            repository: context.read(),
            currentSession: context.read(),
          ),
        ),

        Provider<UpdateCamionUseCase>(
          create: (context) => UpdateCamionUseCase(
            repository: context.read(),
          ),
        ),

        Provider<ChangeCamionStatusUseCase>(
          create: (context) => ChangeCamionStatusUseCase(
            repository: context.read(),
          ),
        ),

        ChangeNotifierProvider<CamionViewModel>(
          create: (context) => CamionViewModel(
            getItemsUseCase: context.read(),
            createUseCase: context.read(),
            updateUseCase: context.read(),
            changeStatusUseCase: context.read(),
          ),
        ),
      ];
}