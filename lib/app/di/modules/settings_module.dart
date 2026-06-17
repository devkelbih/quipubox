import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../../features/settings/domain/repositories/settings_repository.dart';
import '../../../features/settings/domain/usecases/get_theme_mode_usecase.dart';
import '../../../features/settings/domain/usecases/save_theme_mode_usecase.dart';
import '../../../features/settings/presentation/viewmodels/settings_viewmodel.dart';

class SettingsModule {
  const SettingsModule._();

  static List<SingleChildWidget> providers = [
    Provider<SettingsLocalDataSource>(
      create: (context) => SettingsLocalDataSource(
        context.read<SharedPreferences>(),
      ),
    ),

    Provider<SettingsRepository>(
      create: (context) => SettingsRepositoryImpl(
        context.read<SettingsLocalDataSource>(),
      ),
    ),

    Provider<GetThemeModeUseCase>(
      create: (context) => GetThemeModeUseCase(
        context.read<SettingsRepository>(),
      ),
    ),

    Provider<SaveThemeModeUseCase>(
      create: (context) => SaveThemeModeUseCase(
        context.read<SettingsRepository>(),
      ),
    ),

    ChangeNotifierProvider<SettingsViewModel>(
      create: (context) => SettingsViewModel(
        getThemeModeUseCase: context.read<GetThemeModeUseCase>(),
        saveThemeModeUseCase: context.read<SaveThemeModeUseCase>(),
      ),
    ),
  ];
}