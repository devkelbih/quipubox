import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/network/api_client.dart';
import '../../core/network/connectivity_service.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_with_google_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../features/catalog/data/repositories/catalog_repository_impl.dart';
import '../../features/catalog/domain/repositories/catalog_repository.dart';
import '../../features/catalog/domain/usecases/get_catalog_items_usecase.dart';
import '../../features/catalog/domain/usecases/save_catalog_item_usecase.dart';
import '../../features/catalog/presentation/viewmodels/catalog_viewmodel.dart';
import '../../features/company/data/company_repository.dart';
import '../../features/company/presentation/viewmodels/company_viewmodel.dart';
import '../../features/settings/presentation/viewmodels/settings_viewmodel.dart';

class AppProviders {
  const AppProviders._();

  static List<SingleChildWidget> get providers => [
        Provider<ApiClient>(create: (_) => ApiClient(Supabase.instance.client)),
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),

        Provider<AuthRemoteDataSource>(
          create: (_) => AuthRemoteDataSource(Supabase.instance.client),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(context.read<AuthRemoteDataSource>()),
        ),
        Provider(create: (context) => LoginWithGoogleUseCase(context.read<AuthRepository>())),
        Provider(create: (context) => LogoutUseCase(context.read<AuthRepository>())),
        Provider(create: (context) => GetCurrentUserUseCase(context.read<AuthRepository>())),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(
            authRepository: context.read<AuthRepository>(),
            loginWithGoogleUseCase: context.read<LoginWithGoogleUseCase>(),
            logoutUseCase: context.read<LogoutUseCase>(),
            getCurrentUserUseCase: context.read<GetCurrentUserUseCase>(),
          ),
        ),

        Provider<CatalogRepository>(
          create: (context) => CatalogRepositoryImpl(context.read<ApiClient>()),
        ),
        Provider(create: (context) => GetCatalogItemsUseCase(context.read<CatalogRepository>())),
        Provider(create: (context) => SaveCatalogItemUseCase(context.read<CatalogRepository>())),
        ChangeNotifierProvider(
          create: (context) => CatalogViewModel(
            getItemsUseCase: context.read<GetCatalogItemsUseCase>(),
            saveItemUseCase: context.read<SaveCatalogItemUseCase>(),
          ),
        ),

        Provider(create: (context) => CompanyRepository(context.read<ApiClient>())),
        ChangeNotifierProvider(
          create: (context) => CompanyViewModel(context.read<CompanyRepository>()),
        ),
      ];
}
