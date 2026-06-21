import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/current_session.dart';
import '../../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../../features/auth/domain/repositories/auth_repository.dart';
import '../../../features/auth/domain/usecases/clear_cached_user_usecase.dart';
import '../../../features/auth/domain/usecases/get_cached_user_usecase.dart';
import '../../../features/auth/domain/usecases/get_current_session_usecase.dart';
import '../../../features/auth/domain/usecases/get_profile_usecase.dart';
import '../../../features/auth/domain/usecases/login_with_google_usecase.dart';
import '../../../features/auth/domain/usecases/logout_usecase.dart';
import '../../../features/auth/domain/usecases/save_cached_user_usecase.dart';
import '../../../features/auth/presentation/session/auth_current_session.dart';
import '../../../features/auth/presentation/viewmodels/auth_viewmodel.dart';

class AuthModule {
  const AuthModule._();

  static List<SingleChildWidget> providers = [
    Provider<AuthRemoteDataSource>(
      create: (context) => AuthRemoteDataSource(context.read<ApiClient>()),
    ),
    Provider<FlutterSecureStorage>(create: (_) => const FlutterSecureStorage()),
    Provider<AuthLocalDataSource>(
      create: (context) =>
          AuthLocalDataSource(context.read<FlutterSecureStorage>()),
    ),

    Provider<AuthRepository>(
      create: (context) => AuthRepositoryImpl(
        remoteDataSource: context.read<AuthRemoteDataSource>(),
        localDataSource: context.read<AuthLocalDataSource>(),
      ),
    ),

    Provider<GetCurrentSessionUseCase>(
      create: (context) =>
          GetCurrentSessionUseCase(context.read<AuthRepository>()),
    ),

    Provider<LoginWithGoogleUseCase>(
      create: (context) =>
          LoginWithGoogleUseCase(context.read<AuthRepository>()),
    ),

    Provider<LogoutUseCase>(
      create: (context) => LogoutUseCase(context.read<AuthRepository>()),
    ),

    Provider<GetProfileUseCase>(
      create: (context) => GetProfileUseCase(context.read<AuthRepository>()),
    ),

    Provider<GetCachedUserUseCase>(
      create: (context) => GetCachedUserUseCase(context.read<AuthRepository>()),
    ),

    Provider<SaveCachedUserUseCase>(
      create: (context) =>
          SaveCachedUserUseCase(context.read<AuthRepository>()),
    ),

    Provider<ClearCachedUserUseCase>(
      create: (context) =>
          ClearCachedUserUseCase(context.read<AuthRepository>()),
    ),

    ChangeNotifierProvider<AuthViewModel>(
      create: (context) => AuthViewModel(
        getCurrentSessionUseCase: context.read<GetCurrentSessionUseCase>(),
        loginWithGoogleUseCase: context.read<LoginWithGoogleUseCase>(),
        logoutUseCase: context.read<LogoutUseCase>(),
        getProfileUseCase: context.read<GetProfileUseCase>(),
        getCachedUserUseCase: context.read<GetCachedUserUseCase>(),
        saveCachedUserUseCase: context.read<SaveCachedUserUseCase>(),
        clearCachedUserUseCase: context.read<ClearCachedUserUseCase>(),
      ),
    ),

    Provider<CurrentSession>(
      create: (context) => AuthCurrentSession(context.read<AuthViewModel>()),
    ),
  ];
}
