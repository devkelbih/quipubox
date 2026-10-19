import '../../domain/entities/detalle_carga.dart';
import '../../domain/entities/guia_operacion_carga.dart';
import '../../domain/entities/operacion_carga.dart';
import '../../domain/repositories/operacion_carga_repository.dart';
import '../datasources/operacion_carga_remote_data_source.dart';
import '../models/detalle_carga_request_model.dart';
import '../models/operacion_carga_request_model.dart';

class OperacionCargaRepositoryImpl implements OperacionCargaRepository {
  final OperacionCargaRemoteDataSource remoteDataSource;

  const OperacionCargaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<OperacionCarga>> getAll({String? estado, DateTime? fecha}) async {
    final models = await remoteDataSource.getAll(estado: estado, fecha: fecha);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<OperacionCarga> getById(int id) async {
    final model = await remoteDataSource.getById(id);
    return model.toEntity();
  }

  @override
  Future<OperacionCarga> create(OperacionCarga operacion) async {
    final request = OperacionCargaRequestModel.fromEntity(operacion);
    final model = await remoteDataSource.create(request);
    return model.toEntity();
  }

  @override
  Future<OperacionCarga> update(OperacionCarga operacion) async {
    final request = OperacionCargaRequestModel.fromEntity(operacion);
    final model = await remoteDataSource.update(
      operacion.id!,
      request: request,
    );
    return model.toEntity();
  }

  @override
  Future<OperacionCarga> changeEstado({
    required int id,
    required String estado,
  }) async {
    final model = await remoteDataSource.changeEstado(id: id, estado: estado);
    return model.toEntity();
  }

  @override
  Future<OperacionCarga> cancelar(int id) async {
    final model = await remoteDataSource.cancelar(id);
    return model.toEntity();
  }

  @override
  Future<OperacionCarga> finalizar(int id) async {
    final model = await remoteDataSource.finalizar(id);
    return model.toEntity();
  }

  @override
  Future<List<GuiaOperacionCarga>> generarGuias(int id) async {
    final models = await remoteDataSource.generarGuias(id);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<GuiaOperacionCarga>> generarGuiasPorPuesto(int id) async {
    final models = await remoteDataSource.generarGuiasPorPuesto(id);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<DetalleCarga>> getDetalles(int operacionId) async {
    final models = await remoteDataSource.getDetalles(operacionId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<DetalleCarga> createDetalle(
    int operacionId,
    DetalleCarga detalle,
  ) async {
    final request = DetalleCargaRequestModel.fromEntity(detalle);
    final model = await remoteDataSource.createDetalle(operacionId, request);
    return model.toEntity();
  }

  @override
  Future<List<DetalleCarga>> getDetallesPendientes() async {
    final models = await remoteDataSource.getDetallesPendientes();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<DetalleCarga>> getDetallesRepartoPendientes(
    int operacionId,
  ) async {
    final models = await remoteDataSource.getDetallesRepartoPendientes(
      operacionId,
    );
    return models.map((model) => model.toEntity()).toList();
  }
}
