import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:quipubox/features/calidades/data/datasources/calidad_remote_data_source.dart';
import 'package:quipubox/features/calidades/data/repositories/calidad_repository_impl.dart';
import 'package:quipubox/features/calidades/domain/repositories/calidad_repository.dart';
import 'package:quipubox/features/frutas/data/datasources/fruta_remote_data_source.dart';
import 'package:quipubox/features/frutas/data/repositories/fruta_repository_impl.dart';
import 'package:quipubox/features/frutas/domain/repositories/fruta_repository.dart';
import 'package:quipubox/features/variedades/data/datasources/variedad_remote_data_source.dart';
import 'package:quipubox/features/variedades/data/repositories/variedad_repository_impl.dart';
import 'package:quipubox/features/variedades/domain/repositories/variedad_repository.dart';
import 'package:quipubox/features/variedades/domain/usecases/get_variedades_by_fruta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/current_session.dart';

import '../../../features/frutas/domain/usecases/change_fruta_status.dart';
import '../../../features/frutas/domain/usecases/create_fruta.dart';
import '../../../features/frutas/domain/usecases/get_frutas.dart';
import '../../../features/frutas/domain/usecases/update_fruta.dart';
import '../../../features/frutas/presentation/viewmodels/frutas_viewmodel.dart';

import '../../../features/variedades/domain/usecases/change_variedad_status.dart';
import '../../../features/variedades/domain/usecases/create_variedad.dart';
import '../../../features/variedades/domain/usecases/get_variedades.dart';
import '../../../features/variedades/domain/usecases/update_variedad.dart';
import '../../../features/variedades/presentation/viewmodels/variedades_viewmodel.dart';

import '../../../features/calidades/domain/usecases/change_calidad_status.dart';
import '../../../features/calidades/domain/usecases/create_calidad.dart';
import '../../../features/calidades/domain/usecases/get_calidades.dart';
import '../../../features/calidades/domain/usecases/update_calidad.dart';
import '../../../features/calidades/presentation/viewmodels/calidades_viewmodel.dart';

import '../../../features/tipos_jaba/data/datasources/tipos_jaba_remote_data_source.dart';
import '../../../features/tipos_jaba/data/repositories/tipos_jaba_repository_impl.dart';
import '../../../features/tipos_jaba/domain/repositories/tipos_jaba_repository.dart';
import '../../../features/tipos_jaba/domain/usecases/change_tipo_jaba_status.dart';
import '../../../features/tipos_jaba/domain/usecases/create_tipos_jaba.dart';
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
      create: (context) => FrutaRemoteDataSource(context.read<ApiClient>()),
    ),

    Provider<FrutaRepository>(
      create: (context) => FrutaRepositoryImpl(
        remoteDataSource: context.read<FrutaRemoteDataSource>(),
      ),
    ),

    Provider<GetFrutasUseCase>(
      create: (context) => GetFrutasUseCase(context.read<FrutaRepository>()),
    ),

    Provider<CreateFrutaUseCase>(
      create: (context) => CreateFrutaUseCase(
        repository: context.read<FrutaRepository>(),
        currentSession: context.read<CurrentSession>(),
      ),
    ),

    Provider<UpdateFrutaUseCase>(
      create: (context) => UpdateFrutaUseCase(context.read<FrutaRepository>()),
    ),

    Provider<ChangeFrutaStatusUseCase>(
      create: (context) =>
          ChangeFrutaStatusUseCase(context.read<FrutaRepository>()),
    ),

    ChangeNotifierProvider<FrutaViewModel>(
      create: (context) => FrutaViewModel(
        getItemsUseCase: context.read<GetFrutasUseCase>(),
        createUseCase: context.read<CreateFrutaUseCase>(),
        updateUseCase: context.read<UpdateFrutaUseCase>(),
        changeStatusUseCase: context.read<ChangeFrutaStatusUseCase>(),
      ),
    ),

    // Variedades
    Provider<VariedadRemoteDataSource>(
      create: (context) => VariedadRemoteDataSource(context.read<ApiClient>()),
    ),

    Provider<VariedadRepository>(
      create: (context) => VariedadRepositoryImpl(
        remoteDataSource: context.read<VariedadRemoteDataSource>(),
      ),
    ),

    Provider<GetVariedadesUseCase>(
      create: (context) =>
          GetVariedadesUseCase(context.read<VariedadRepository>()),
    ),

    Provider<GetVariedadesByFrutaUseCase>(
      create: (context) =>
          GetVariedadesByFrutaUseCase(context.read<VariedadRepository>()),
    ),

    Provider<CreateVariedadUseCase>(
      create: (context) => CreateVariedadUseCase(
        repository: context.read<VariedadRepository>(),
        currentSession: context.read<CurrentSession>(),
      ),
    ),

    Provider<UpdateVariedadUseCase>(
      create: (context) =>
          UpdateVariedadUseCase(context.read<VariedadRepository>()),
    ),

    Provider<ChangeVariedadStatusUseCase>(
      create: (context) =>
          ChangeVariedadStatusUseCase(context.read<VariedadRepository>()),
    ),

    ChangeNotifierProvider<VariedadViewModel>(
      create: (context) => VariedadViewModel(
        getItemsUseCase: context.read<GetVariedadesUseCase>(),
        getByFrutaUseCase: context.read<GetVariedadesByFrutaUseCase>(),
        getFrutasUseCase: context.read<GetFrutasUseCase>(),
        createUseCase: context.read<CreateVariedadUseCase>(),
        updateUseCase: context.read<UpdateVariedadUseCase>(),
        changeStatusUseCase: context.read<ChangeVariedadStatusUseCase>(),
      ),
    ),

    // Calidades
    Provider<CalidadRemoteDataSource>(
      create: (context) => CalidadRemoteDataSource(context.read<ApiClient>()),
    ),

    Provider<CalidadRepository>(
      create: (context) => CalidadRepositoryImpl(
        remoteDataSource: context.read<CalidadRemoteDataSource>(),
      ),
    ),

    Provider<GetCalidadesUseCase>(
      create: (context) =>
          GetCalidadesUseCase(context.read<CalidadRepository>()),
    ),

    Provider<CreateCalidadUseCase>(
      create: (context) => CreateCalidadUseCase(
        repository: context.read<CalidadRepository>(),
        currentSession: context.read<CurrentSession>(),
      ),
    ),

    Provider<UpdateCalidadUseCase>(
      create: (context) =>
          UpdateCalidadUseCase(context.read<CalidadRepository>()),
    ),

    Provider<ChangeCalidadStatusUseCase>(
      create: (context) =>
          ChangeCalidadStatusUseCase(context.read<CalidadRepository>()),
    ),

    ChangeNotifierProvider<CalidadViewModel>(
      create: (context) => CalidadViewModel(
        getItemsUseCase: context.read<GetCalidadesUseCase>(),
        createUseCase: context.read<CreateCalidadUseCase>(),
        updateUseCase: context.read<UpdateCalidadUseCase>(),
        changeStatusUseCase: context.read<ChangeCalidadStatusUseCase>(),
      ),
    ),

    // Tipos de jaba
    Provider<TipoJabaRemoteDataSource>(
      create: (context) => TipoJabaRemoteDataSource(context.read<ApiClient>()),
    ),

    Provider<TipoJabaRepository>(
      create: (context) => TipoJabaRepositoryImpl(
        remoteDataSource: context.read<TipoJabaRemoteDataSource>(),
      ),
    ),

    Provider<GetTiposJabaUseCase>(
      create: (context) =>
          GetTiposJabaUseCase(context.read<TipoJabaRepository>()),
    ),

    Provider<CreateTipoJabaUseCase>(
      create: (context) => CreateTipoJabaUseCase(
        repository: context.read<TipoJabaRepository>(),
        currentSession: context.read<CurrentSession>(),
      ),
    ),

    Provider<UpdateTipoJabaUseCase>(
      create: (context) =>
          UpdateTipoJabaUseCase(context.read<TipoJabaRepository>()),
    ),

    Provider<ChangeTipoJabaStatusUseCase>(
      create: (context) =>
          ChangeTipoJabaStatusUseCase(context.read<TipoJabaRepository>()),
    ),

    ChangeNotifierProvider<TipoJabaViewModel>(
      create: (context) => TipoJabaViewModel(
        getItemsUseCase: context.read<GetTiposJabaUseCase>(),
        createUseCase: context.read<CreateTipoJabaUseCase>(),
        updateUseCase: context.read<UpdateTipoJabaUseCase>(),
        changeStatusUseCase: context.read<ChangeTipoJabaStatusUseCase>(),
      ),
    ),

    // Camiones
    Provider<CamionRemoteDataSource>(
      create: (context) => CamionRemoteDataSource(context.read<ApiClient>()),
    ),

    Provider<CamionRepository>(
      create: (context) => CamionRepositoryImpl(
        remoteDataSource: context.read<CamionRemoteDataSource>(),
      ),
    ),

    Provider<GetCamionesUseCase>(
      create: (context) => GetCamionesUseCase(context.read<CamionRepository>()),
    ),

    Provider<CreateCamionUseCase>(
      create: (context) => CreateCamionUseCase(
        repository: context.read<CamionRepository>(),
        currentSession: context.read<CurrentSession>(),
      ),
    ),

    Provider<UpdateCamionUseCase>(
      create: (context) =>
          UpdateCamionUseCase(context.read<CamionRepository>()),
    ),

    Provider<ChangeCamionStatusUseCase>(
      create: (context) =>
          ChangeCamionStatusUseCase(context.read<CamionRepository>()),
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
