import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:quipubox/features/frutas/data/datasources/fruta_remote_data_source.dart';
import 'package:quipubox/features/frutas/data/repositories/fruta_repository_impl.dart';
import 'package:quipubox/features/frutas/domain/repositories/fruta_repository.dart';
import 'package:quipubox/features/frutas/domain/usecases/change_fruta_status.dart';
import 'package:quipubox/features/frutas/domain/usecases/create_fruta.dart';
import 'package:quipubox/features/frutas/domain/usecases/get_frutas.dart';
import 'package:quipubox/features/frutas/domain/usecases/update_fruta.dart';
import 'package:quipubox/features/frutas/presentation/viewmodels/frutas_viewmodel.dart';

class FrutasModule {
  const FrutasModule._();

  static List<SingleChildWidget> get providers => [
        Provider<FrutaRemoteDataSource>(
          create: (context) => FrutaRemoteDataSource(
            apiClient: context.read(),
          ),
        ),

        Provider<FrutaRepository>(
          create: (context) => FrutaRepositoryImpl(
            remoteDataSource: context.read(),
          ),
        ),

        Provider<GetFrutasUseCase>(
          create: (context) => GetFrutasUseCase(
            repository: context.read(),
          ),
        ),

        Provider<CreateFrutaUseCase>(
          create: (context) => CreateFrutaUseCase(
            repository: context.read(),
            currentSession: context.read(),
          ),
        ),

        Provider<UpdateFrutaUseCase>(
          create: (context) => UpdateFrutaUseCase(
            repository: context.read(),
          ),
        ),

        Provider<ChangeFrutaStatusUseCase>(
          create: (context) => ChangeFrutaStatusUseCase(
            repository: context.read(),
          ),
        ),

        ChangeNotifierProvider<FrutaViewModel>(
          create: (context) => FrutaViewModel(
            getItemsUseCase: context.read(),
            createUseCase: context.read(),
            updateUseCase: context.read(),
            changeStatusUseCase: context.read(),
          ),
        ),
      ];
}