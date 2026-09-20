import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:quipubox/features/roles/data/datasources/roles_remote_data_source.dart';
import 'package:quipubox/features/roles/data/repositories/roles_repository_impl.dart';
import 'package:quipubox/features/roles/domain/repositories/roles_repository.dart';
import 'package:quipubox/features/roles/domain/usecases/get_roles.dart';
import 'package:quipubox/features/roles/presentation/viewmodels/roles_viewmodel.dart';

class RolesModule {
  const RolesModule._();

  static List<SingleChildWidget> get providers => [
        Provider<RolesRemoteDataSource>(
          create: (context) => RolesRemoteDataSource(
            apiClient: context.read(),
          ),
        ),

        Provider<RolesRepository>(
          create: (context) => RolesRepositoryImpl(
            remoteDataSource: context.read(),
          ),
        ),

        Provider<GetRolesUseCase>(
          create: (context) => GetRolesUseCase(
            repository: context.read(),
          ),
        ),

        ChangeNotifierProvider<RolesViewModel>(
          create: (context) => RolesViewModel(
            getRolesUseCase: context.read(),
          ),
        ),
      ];
}