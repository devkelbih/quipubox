import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:quipubox/core/network/api_client.dart';
import 'package:quipubox/core/session/current_session.dart';
import 'package:quipubox/features/operaciones/carga/data/datasources/operacion_carga_remote_data_source.dart';
import 'package:quipubox/features/operaciones/carga/data/repositories/operacion_carga_repository_impl.dart';
import 'package:quipubox/features/operaciones/carga/domain/repositories/operacion_carga_repository.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/cancelar_operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/change_estado_operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/create_detalle_operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/create_operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/finalizar_operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/generar_guias_operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/generar_guias_por_puesto_operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/get_detalles_operacion.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/get_detalles_pendientes.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/get_detalles_reparto_pendientes.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/get_operacion_carga_by_id.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/get_operaciones_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/update_operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/presentation/viewmodels/carga_viewmodel.dart';

class CargaModule {
  const CargaModule._();

  static List<SingleChildWidget> get providers => [
    Provider<OperacionCargaRemoteDataSource>(
      create: (context) =>
          OperacionCargaRemoteDataSource(apiClient: context.read<ApiClient>()),
    ),
    Provider<OperacionCargaRepository>(
      create: (context) => OperacionCargaRepositoryImpl(
        remoteDataSource: context.read<OperacionCargaRemoteDataSource>(),
      ),
    ),
    Provider<GetOperacionesCargaUseCase>(
      create: (context) => GetOperacionesCargaUseCase(
        repository: context.read<OperacionCargaRepository>(),
      ),
    ),
    Provider<GetOperacionCargaByIdUseCase>(
      create: (context) => GetOperacionCargaByIdUseCase(
        repository: context.read<OperacionCargaRepository>(),
      ),
    ),
    Provider<CreateOperacionCargaUseCase>(
      create: (context) => CreateOperacionCargaUseCase(
        repository: context.read<OperacionCargaRepository>(),
        currentSession: context.read<CurrentSession>(),
      ),
    ),
    Provider<UpdateOperacionCargaUseCase>(
      create: (context) => UpdateOperacionCargaUseCase(
        repository: context.read<OperacionCargaRepository>(),
        currentSession: context.read<CurrentSession>(),
      ),
    ),
    Provider<ChangeEstadoOperacionCargaUseCase>(
      create: (context) => ChangeEstadoOperacionCargaUseCase(
        repository: context.read<OperacionCargaRepository>(),
        currentSession: context.read<CurrentSession>(),
      ),
    ),
    Provider<CancelarOperacionCargaUseCase>(
      create: (context) => CancelarOperacionCargaUseCase(
        repository: context.read<OperacionCargaRepository>(),
        currentSession: context.read<CurrentSession>(),
      ),
    ),
    Provider<FinalizarOperacionCargaUseCase>(
      create: (context) => FinalizarOperacionCargaUseCase(
        repository: context.read<OperacionCargaRepository>(),
        currentSession: context.read<CurrentSession>(),
      ),
    ),
    Provider<GenerarGuiasOperacionCargaUseCase>(
      create: (context) => GenerarGuiasOperacionCargaUseCase(
        repository: context.read<OperacionCargaRepository>(),
        currentSession: context.read<CurrentSession>(),
      ),
    ),
    Provider<GenerarGuiasPorPuestoOperacionCargaUseCase>(
      create: (context) => GenerarGuiasPorPuestoOperacionCargaUseCase(
        repository: context.read<OperacionCargaRepository>(),
        currentSession: context.read<CurrentSession>(),
      ),
    ),
    Provider<GetDetallesOperacionUseCase>(
      create: (context) => GetDetallesOperacionUseCase(
        repository: context.read<OperacionCargaRepository>(),
      ),
    ),
    Provider<CreateDetalleOperacionCargaUseCase>(
      create: (context) => CreateDetalleOperacionCargaUseCase(
        repository: context.read<OperacionCargaRepository>(),
        currentSession: context.read<CurrentSession>(),
      ),
    ),
    Provider<GetDetallesPendientesUseCase>(
      create: (context) => GetDetallesPendientesUseCase(
        repository: context.read<OperacionCargaRepository>(),
      ),
    ),
    Provider<GetDetallesRepartoPendientesUseCase>(
      create: (context) => GetDetallesRepartoPendientesUseCase(
        repository: context.read<OperacionCargaRepository>(),
      ),
    ),
    ChangeNotifierProvider<CargaViewModel>(
      create: (context) => CargaViewModel(
        getOperacionesUseCase: context.read<GetOperacionesCargaUseCase>(),
        getOperacionByIdUseCase: context.read<GetOperacionCargaByIdUseCase>(),
        createOperacionUseCase: context.read<CreateOperacionCargaUseCase>(),
        updateOperacionUseCase: context.read<UpdateOperacionCargaUseCase>(),
        changeEstadoUseCase: context.read<ChangeEstadoOperacionCargaUseCase>(),
        cancelarUseCase: context.read<CancelarOperacionCargaUseCase>(),
        finalizarUseCase: context.read<FinalizarOperacionCargaUseCase>(),
        generarGuiasUseCase: context.read<GenerarGuiasOperacionCargaUseCase>(),
        getDetallesUseCase: context.read<GetDetallesOperacionUseCase>(),
      ),
    ),
  ];
}
