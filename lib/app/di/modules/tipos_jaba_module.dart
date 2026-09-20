import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:quipubox/features/tipos_jaba/data/datasources/tipos_jaba_remote_data_source.dart';
import 'package:quipubox/features/tipos_jaba/data/repositories/tipos_jaba_repository_impl.dart';
import 'package:quipubox/features/tipos_jaba/domain/repositories/tipos_jaba_repository.dart';
import 'package:quipubox/features/tipos_jaba/domain/usecases/change_tipo_jaba_status.dart';
import 'package:quipubox/features/tipos_jaba/domain/usecases/create_tipos_jaba.dart';
import 'package:quipubox/features/tipos_jaba/domain/usecases/get_tipos_jaba.dart';
import 'package:quipubox/features/tipos_jaba/domain/usecases/update_tipos_jaba.dart';
import 'package:quipubox/features/tipos_jaba/presentation/viewmodels/tipos_jaba_viewmodel.dart';

class TiposJabaModule {
  const TiposJabaModule._();

  static List<SingleChildWidget> get providers => [
        Provider<TipoJabaRemoteDataSource>(
          create: (context) => TipoJabaRemoteDataSource(
            apiClient: context.read(),
          ),
        ),

        Provider<TipoJabaRepository>(
          create: (context) => TipoJabaRepositoryImpl(
            remoteDataSource: context.read(),
          ),
        ),

        Provider<GetTiposJabaUseCase>(
          create: (context) => GetTiposJabaUseCase(
            repository: context.read(),
          ),
        ),

        Provider<CreateTipoJabaUseCase>(
          create: (context) => CreateTipoJabaUseCase(
            repository: context.read(),
            currentSession: context.read(),
          ),
        ),

        Provider<UpdateTipoJabaUseCase>(
          create: (context) => UpdateTipoJabaUseCase(
            repository: context.read(),
          ),
        ),

        Provider<ChangeTipoJabaStatusUseCase>(
          create: (context) => ChangeTipoJabaStatusUseCase(
            repository: context.read(),
          ),
        ),

        ChangeNotifierProvider<TipoJabaViewModel>(
          create: (context) => TipoJabaViewModel(
            getItemsUseCase: context.read(),
            createUseCase: context.read(),
            updateUseCase: context.read(),
            changeStatusUseCase: context.read(),
          ),
        ),
      ];
}