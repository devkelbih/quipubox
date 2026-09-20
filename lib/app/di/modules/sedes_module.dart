import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:quipubox/features/sedes/data/datasources/sedes_remote_data_source.dart';
import 'package:quipubox/features/sedes/data/repositories/sedes_repository_impl.dart';
import 'package:quipubox/features/sedes/domain/repositories/sedes_repository.dart';
import 'package:quipubox/features/sedes/domain/usecases/change_sede_status.dart';
import 'package:quipubox/features/sedes/domain/usecases/create_sede.dart';
import 'package:quipubox/features/sedes/domain/usecases/get_sedes.dart';
import 'package:quipubox/features/sedes/domain/usecases/update_sede.dart';
import 'package:quipubox/features/sedes/presentation/viewmodels/sedes_viewmodel.dart';

class SedesModule {
  const SedesModule._();

  static List<SingleChildWidget> get providers => [
    Provider<SedeRemoteDataSource>(
      create: (context) => SedeRemoteDataSource(apiClient: context.read()),
    ),

    Provider<SedeRepository>(
      create: (context) => SedeRepositoryImpl(remoteDataSource: context.read()),
    ),

    Provider<GetSedesUseCase>(
      create: (context) => GetSedesUseCase(repository: context.read()),
    ),

    Provider<CreateSedeUseCase>(
      create: (context) => CreateSedeUseCase(
        repository: context.read(),
        currentSession: context.read(),
      ),
    ),

    Provider<UpdateSedeUseCase>(
      create: (context) => UpdateSedeUseCase(repository: context.read()),
    ),

    Provider<ChangeSedeStatusUseCase>(
      create: (context) => ChangeSedeStatusUseCase(repository: context.read()),
    ),

    ChangeNotifierProvider<SedeViewModel>(
      create: (context) => SedeViewModel(
        getSedesUseCase: context.read(),
        createSedeUseCase: context.read(),
        updateSedeUseCase: context.read(),
        changeSedeStatusUseCase: context.read(),
      ),
    ),
  ];
}
