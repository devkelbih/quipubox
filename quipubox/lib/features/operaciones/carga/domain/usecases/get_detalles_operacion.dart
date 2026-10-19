import '../entities/detalle_carga.dart';
import '../repositories/operacion_carga_repository.dart';

class GetDetallesOperacionUseCase {
  final OperacionCargaRepository repository;

  const GetDetallesOperacionUseCase({required this.repository});

  Future<List<DetalleCarga>> call(int operacionId) {
    return repository.getDetalles(operacionId);
  }
}
