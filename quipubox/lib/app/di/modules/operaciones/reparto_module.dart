import '../../../../features/operaciones/reparto/domain/usecases/get_distribucion_operacion.dart';
import '../../../../features/operaciones/reparto/presentation/viewmodels/reparto_operacion_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/session/current_session.dart';
import '../../../../features/operaciones/carga/domain/usecases/get_operaciones_carga.dart';
import '../../../../features/operaciones/carga/domain/usecases/get_operacion_carga_by_id.dart';
import '../../../../features/operaciones/carga/domain/usecases/get_detalles_operacion.dart';
import '../../../../features/operaciones/carga/domain/usecases/get_calidades_detalle.dart';
import '../../../../features/organizacion/clientes/domain/usecases/get_clientes.dart';
import '../../../../features/organizacion/puestos/domain/usecases/get_puestos.dart';
import '../../../../features/operaciones/reparto/data/datasources/reparto_remote_data_source.dart';
import '../../../../features/operaciones/reparto/data/repositories/reparto_repository_impl.dart';
import '../../../../features/operaciones/reparto/domain/repositories/reparto_repository.dart';
import '../../../../features/operaciones/reparto/domain/usecases/get_repartos.dart';
import '../../../../features/operaciones/reparto/domain/usecases/get_contexto_reparto.dart';
import '../../../../features/operaciones/reparto/domain/usecases/save_asignaciones_reparto.dart';
import '../../../../features/operaciones/reparto/domain/usecases/update_reparto.dart';
import '../../../../features/operaciones/reparto/domain/usecases/save_linea_reparto.dart';
import '../../../../features/operaciones/reparto/domain/usecases/delete_reparto.dart';
import '../../../../features/operaciones/reparto/presentation/viewmodels/reparto_list_viewmodel.dart';
import '../../../../features/operaciones/reparto/presentation/viewmodels/reparto_detail_viewmodel.dart';

class RepartoModule {
  const RepartoModule._();
  static List<SingleChildWidget> get providers => [
    Provider<RepartoRemoteDataSource>(
      create: (c) => RepartoRemoteDataSource(c.read<ApiClient>()),
    ),
    Provider<RepartoRepository>(
      create: (c) => RepartoRepositoryImpl(c.read<RepartoRemoteDataSource>()),
    ),
    Provider<GetRepartosUseCase>(
      create: (c) => GetRepartosUseCase(c.read<RepartoRepository>()),
    ),
    Provider<GetContextoRepartoUseCase>(
      create: (c) => GetContextoRepartoUseCase(
        repository: c.read<RepartoRepository>(),
        getOperacion: c.read<GetOperacionCargaByIdUseCase>(),
        getDetalles: c.read<GetDetallesOperacionUseCase>(),
        getCalidades: c.read<GetCalidadesDetalleUseCase>(),
        getClientes: c.read<GetClientesUseCase>(),
        getPuestos: c.read<GetPuestosUseCase>(),
      ),
    ),
    Provider<SaveAsignacionesRepartoUseCase>(
      create: (c) => SaveAsignacionesRepartoUseCase(
        repository: c.read<RepartoRepository>(),
        getContexto: c.read<GetContextoRepartoUseCase>(),
        currentSession: c.read<CurrentSession>(),
      ),
    ),
    Provider<UpdateRepartoUseCase>(
      create: (c) => UpdateRepartoUseCase(
        repository: c.read<RepartoRepository>(),
        getContexto: c.read<GetContextoRepartoUseCase>(),
        currentSession: c.read<CurrentSession>(),
      ),
    ),
    Provider<SaveLineaRepartoUseCase>(
      create: (c) => SaveLineaRepartoUseCase(
        repository: c.read<RepartoRepository>(),
        getContexto: c.read<GetContextoRepartoUseCase>(),
        currentSession: c.read<CurrentSession>(),
      ),
    ),
    Provider<DeleteRepartoUseCase>(
      create: (c) => DeleteRepartoUseCase(
        repository: c.read<RepartoRepository>(),
        getContexto: c.read<GetContextoRepartoUseCase>(),
        currentSession: c.read<CurrentSession>(),
      ),
    ),
    Provider<GetDistribucionOperacionUseCase>(
      create: (c) => GetDistribucionOperacionUseCase(
        getOperacion: c.read<GetOperacionCargaByIdUseCase>(),
        getCargas: c.read<GetDetallesOperacionUseCase>(),
        getRepartos: c.read<GetRepartosUseCase>(),
      ),
    ),
    Provider<RepartoOperacionViewModel Function()>(
      create: (c) =>
          () => RepartoOperacionViewModel(
            c.read<GetDistribucionOperacionUseCase>(),
          ),
    ),
    Provider<RepartoListViewModel Function()>(
      create: (c) =>
          () => RepartoListViewModel(
            getOperaciones: c.read<GetOperacionesCargaUseCase>(),
          ),
    ),
    Provider<RepartoDetailViewModel Function()>(
      create: (c) =>
          () => RepartoDetailViewModel(
            getContexto: c.read<GetContextoRepartoUseCase>(),
            saveAsignaciones: c.read<SaveAsignacionesRepartoUseCase>(),
            updateReparto: c.read<UpdateRepartoUseCase>(),
            saveLinea: c.read<SaveLineaRepartoUseCase>(),
            deleteReparto: c.read<DeleteRepartoUseCase>(),
          ),
    ),
  ];
}
