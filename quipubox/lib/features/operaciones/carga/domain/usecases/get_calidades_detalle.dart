import '../entities/detalle_carga_calidad.dart';
import '../repositories/operacion_carga_repository.dart';

class GetCalidadesDetalleUseCase {
  final OperacionCargaRepository repository;
  const GetCalidadesDetalleUseCase({required this.repository});

  Future<List<DetalleCargaCalidad>> call(int detalleId) =>
      repository.getCalidadesDetalle(detalleId);
}
