import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/network_checker.dart';
import '../../../core/session/current_session.dart';

import '../../../features/frutas/data/datasources/frutas_remote_data_source.dart';
import '../../../features/frutas/data/repositories/frutas_repository_impl.dart';
import '../../../features/frutas/domain/repositories/frutas_repository.dart';
import '../../../features/frutas/domain/usecases/create_fruta.dart';
import '../../../features/frutas/domain/usecases/delete_fruta.dart';
import '../../../features/frutas/domain/usecases/get_frutas.dart';
import '../../../features/frutas/domain/usecases/update_fruta.dart';
import '../../../features/frutas/presentation/viewmodels/frutas_viewmodel.dart';

import '../../../features/variedades/data/datasources/variedades_remote_data_source.dart';
import '../../../features/variedades/data/repositories/variedades_repository_impl.dart';
import '../../../features/variedades/domain/repositories/variedades_repository.dart';
import '../../../features/variedades/domain/usecases/create_variedad.dart';
import '../../../features/variedades/domain/usecases/delete_variedad.dart';
import '../../../features/variedades/domain/usecases/get_variedades.dart';
import '../../../features/variedades/domain/usecases/update_variedad.dart';
import '../../../features/variedades/presentation/viewmodels/variedades_viewmodel.dart';

import '../../../features/calidades/data/datasources/calidades_remote_data_source.dart';
import '../../../features/calidades/data/repositories/calidades_repository_impl.dart';
import '../../../features/calidades/domain/repositories/calidades_repository.dart';
import '../../../features/calidades/domain/usecases/create_calidad.dart';
import '../../../features/calidades/domain/usecases/delete_calidad.dart';
import '../../../features/calidades/domain/usecases/get_calidades.dart';
import '../../../features/calidades/domain/usecases/update_calidad.dart';
import '../../../features/calidades/presentation/viewmodels/calidades_viewmodel.dart';

import '../../../features/tipos_jaba/data/datasources/tipos_jaba_remote_data_source.dart';
import '../../../features/tipos_jaba/data/repositories/tipos_jaba_repository_impl.dart';
import '../../../features/tipos_jaba/domain/repositories/tipos_jaba_repository.dart';
import '../../../features/tipos_jaba/domain/usecases/create_tipos_jaba.dart';
import '../../../features/tipos_jaba/domain/usecases/delete_tipos_jaba.dart';
import '../../../features/tipos_jaba/domain/usecases/get_tipos_jaba.dart';
import '../../../features/tipos_jaba/domain/usecases/update_tipos_jaba.dart';
import '../../../features/tipos_jaba/presentation/viewmodels/tipos_jaba_viewmodel.dart';

import '../../../features/camiones/data/datasources/camiones_remote_data_source.dart';
import '../../../features/camiones/data/repositories/camiones_repository_impl.dart';
import '../../../features/camiones/domain/repositories/camiones_repository.dart';
import '../../../features/camiones/domain/usecases/change_camion_status.dart';
import '../../../features/camiones/domain/usecases/create_camion.dart';
import '../../../features/camiones/domain/usecases/get_camiones.dart';
import '../../../features/camiones/domain/usecases/update_camion.dart';
import '../../../features/camiones/presentation/viewmodels/camiones_viewmodel.dart';

class CatalogosModule {
  const CatalogosModule._();

  static List<SingleChildWidget> providers = [
    // Frutas

    Provider<FrutaRemoteDataSource>(
      create: (context) => FrutaRemoteDataSource(
        context.read<ApiClient>(),
      ),
    ),

    Provider<FrutaRepository>(
      create: (context) => FrutaRepositoryImpl(
        context.read<FrutaRemoteDataSource>(),
      ),
    ),

    Provider<GetFrutasUseCase>(
      create: (context) => GetFrutasUseCase(
        context.read<FrutaRepository>(),
      ),
    ),

    Provider<CreateFrutaUseCase>(
      create: (context) => CreateFrutaUseCase(
        context.read<FrutaRepository>(),
      ),
    ),

    Provider<UpdateFrutaUseCase>(
      create: (context) => UpdateFrutaUseCase(
        context.read<FrutaRepository>(),
      ),
    ),

    Provider<DeleteFrutaUseCase>(
      create: (context) => DeleteFrutaUseCase(
        context.read<FrutaRepository>(),
      ),
    ),

    ChangeNotifierProvider<FrutaViewModel>(
      create: (context) => FrutaViewModel(
        getItemsUseCase: context.read<GetFrutasUseCase>(),
        createUseCase: context.read<CreateFrutaUseCase>(),
        updateUseCase: context.read<UpdateFrutaUseCase>(),
        deleteUseCase: context.read<DeleteFrutaUseCase>(),
        networkChecker: context.read<NetworkChecker>(),
      ),
    ),

    // Variedades

    Provider<VariedadRemoteDataSource>(
      create: (context) => VariedadRemoteDataSource(
        context.read<ApiClient>(),
      ),
    ),

    Provider<VariedadRepository>(
      create: (context) => VariedadRepositoryImpl(
        context.read<VariedadRemoteDataSource>(),
      ),
    ),

    Provider<GetVariedadesUseCase>(
      create: (context) => GetVariedadesUseCase(
        context.read<VariedadRepository>(),
      ),
    ),

    Provider<CreateVariedadUseCase>(
      create: (context) => CreateVariedadUseCase(
        context.read<VariedadRepository>(),
      ),
    ),

    Provider<UpdateVariedadUseCase>(
      create: (context) => UpdateVariedadUseCase(
        context.read<VariedadRepository>(),
      ),
    ),

    Provider<DeleteVariedadUseCase>(
      create: (context) => DeleteVariedadUseCase(
        context.read<VariedadRepository>(),
      ),
    ),

    ChangeNotifierProvider<VariedadViewModel>(
      create: (context) => VariedadViewModel(
        getItemsUseCase: context.read<GetVariedadesUseCase>(),
        createUseCase: context.read<CreateVariedadUseCase>(),
        updateUseCase: context.read<UpdateVariedadUseCase>(),
        deleteUseCase: context.read<DeleteVariedadUseCase>(),
        networkChecker: context.read<NetworkChecker>(),
      ),
    ),

    // Calidades

    Provider<CalidadRemoteDataSource>(
      create: (context) => CalidadRemoteDataSource(
        context.read<ApiClient>(),
      ),
    ),

    Provider<CalidadRepository>(
      create: (context) => CalidadRepositoryImpl(
        context.read<CalidadRemoteDataSource>(),
      ),
    ),

    Provider<GetCalidadesUseCase>(
      create: (context) => GetCalidadesUseCase(
        context.read<CalidadRepository>(),
      ),
    ),

    Provider<CreateCalidadUseCase>(
      create: (context) => CreateCalidadUseCase(
        context.read<CalidadRepository>(),
      ),
    ),

    Provider<UpdateCalidadUseCase>(
      create: (context) => UpdateCalidadUseCase(
        context.read<CalidadRepository>(),
      ),
    ),

    Provider<DeleteCalidadUseCase>(
      create: (context) => DeleteCalidadUseCase(
        context.read<CalidadRepository>(),
      ),
    ),

    ChangeNotifierProvider<CalidadViewModel>(
      create: (context) => CalidadViewModel(
        getItemsUseCase: context.read<GetCalidadesUseCase>(),
        createUseCase: context.read<CreateCalidadUseCase>(),
        updateUseCase: context.read<UpdateCalidadUseCase>(),
        deleteUseCase: context.read<DeleteCalidadUseCase>(),
        networkChecker: context.read<NetworkChecker>(),
      ),
    ),

    // Tipos de jaba

    Provider<TipoJabaRemoteDataSource>(
      create: (context) => TipoJabaRemoteDataSource(
        context.read<ApiClient>(),
      ),
    ),

    Provider<TipoJabaRepository>(
      create: (context) => TipoJabaRepositoryImpl(
        context.read<TipoJabaRemoteDataSource>(),
      ),
    ),

    Provider<GetTiposJabaUseCase>(
      create: (context) => GetTiposJabaUseCase(
        context.read<TipoJabaRepository>(),
      ),
    ),

    Provider<CreateTipoJabaUseCase>(
      create: (context) => CreateTipoJabaUseCase(
        context.read<TipoJabaRepository>(),
      ),
    ),

    Provider<UpdateTipoJabaUseCase>(
      create: (context) => UpdateTipoJabaUseCase(
        context.read<TipoJabaRepository>(),
      ),
    ),

    Provider<DeleteTipoJabaUseCase>(
      create: (context) => DeleteTipoJabaUseCase(
        context.read<TipoJabaRepository>(),
      ),
    ),

    ChangeNotifierProvider<TipoJabaViewModel>(
      create: (context) => TipoJabaViewModel(
        getItemsUseCase: context.read<GetTiposJabaUseCase>(),
        createUseCase: context.read<CreateTipoJabaUseCase>(),
        updateUseCase: context.read<UpdateTipoJabaUseCase>(),
        deleteUseCase: context.read<DeleteTipoJabaUseCase>(),
        networkChecker: context.read<NetworkChecker>(),
      ),
    ),

    // Camiones

    Provider<CamionRemoteDataSource>(
      create: (context) => CamionRemoteDataSource(
        context.read<ApiClient>(),
      ),
    ),

    Provider<CamionRepository>(
      create: (context) => CamionRepositoryImpl(
        remoteDataSource: context.read<CamionRemoteDataSource>(),
        networkChecker: context.read<NetworkChecker>(),
      ),
    ),

    Provider<GetCamionesUseCase>(
      create: (context) => GetCamionesUseCase(
        context.read<CamionRepository>(),
      ),
    ),

    Provider<CreateCamionUseCase>(
      create: (context) => CreateCamionUseCase(
        repository: context.read<CamionRepository>(),
        currentSession: context.read<CurrentSession>(),
      ),
    ),

    Provider<UpdateCamionUseCase>(
      create: (context) => UpdateCamionUseCase(
        context.read<CamionRepository>(),
      ),
    ),

    Provider<ChangeCamionStatusUseCase>(
      create: (context) => ChangeCamionStatusUseCase(
        context.read<CamionRepository>(),
      ),
    ),

    ChangeNotifierProvider<CamionViewModel>(
      create: (context) => CamionViewModel(
        getItemsUseCase: context.read<GetCamionesUseCase>(),
        createUseCase: context.read<CreateCamionUseCase>(),
        updateUseCase: context.read<UpdateCamionUseCase>(),
        changeStatusUseCase: context.read<ChangeCamionStatusUseCase>(),
      ),
    ),
  ];
}