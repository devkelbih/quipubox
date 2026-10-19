import '../entities/detalle_carga.dart';
import '../repositories/operacion_carga_repository.dart';

class GetDetallesPendientesUseCase {
  final OperacionCargaRepository repository;

  const GetDetallesPendientesUseCase({required this.repository});

  Future<List<DetalleCarga>> call() => repository.getDetallesPendientes();
}
