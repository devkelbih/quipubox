import '../entities/detalle_carga.dart';
import '../repositories/operacion_carga_repository.dart';

class GetDetallesRepartoPendientesUseCase {
  final OperacionCargaRepository repository;

  const GetDetallesRepartoPendientesUseCase({required this.repository});

  Future<List<DetalleCarga>> call(int operacionId) {
    return repository.getDetallesRepartoPendientes(operacionId);
  }
}
