import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:quipubox/features/variedades/data/datasources/variedad_remote_data_source.dart';
import 'package:quipubox/features/variedades/data/repositories/variedad_repository_impl.dart';
import 'package:quipubox/features/variedades/domain/repositories/variedad_repository.dart';
import 'package:quipubox/features/variedades/domain/usecases/change_variedad_status.dart';
import 'package:quipubox/features/variedades/domain/usecases/create_variedad.dart';
import 'package:quipubox/features/variedades/domain/usecases/get_variedades.dart';
import 'package:quipubox/features/variedades/domain/usecases/update_variedad.dart';
import 'package:quipubox/features/variedades/presentation/viewmodels/variedades_viewmodel.dart';

class VariedadesModule {
  const VariedadesModule._();

  static List<SingleChildWidget> get providers => [
        Provider<VariedadRemoteDataSource>(
          create: (context) => VariedadRemoteDataSource(
            apiClient: context.read(),
          ),
        ),

        Provider<VariedadRepository>(
          create: (context) => VariedadRepositoryImpl(
            remoteDataSource: context.read(),
          ),
        ),

        Provider<GetVariedadesUseCase>(
          create: (context) => GetVariedadesUseCase(
            repository: context.read(),
          ),
        ),

        Provider<CreateVariedadUseCase>(
          create: (context) => CreateVariedadUseCase(
            repository: context.read(),
            currentSession: context.read(),
          ),
        ),

        Provider<UpdateVariedadUseCase>(
          create: (context) => UpdateVariedadUseCase(
            repository: context.read(),
          ),
        ),

        Provider<ChangeVariedadStatusUseCase>(
          create: (context) => ChangeVariedadStatusUseCase(
            repository: context.read(),
          ),
        ),

        ChangeNotifierProvider<VariedadViewModel>(
          create: (context) => VariedadViewModel(
            getItemsUseCase: context.read(),
            createUseCase: context.read(),
            updateUseCase: context.read(),
            changeStatusUseCase: context.read(),
          ),
        ),
      ];
}