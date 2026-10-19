import '../entities/operacion_carga.dart';
import '../repositories/operacion_carga_repository.dart';

class GetOperacionesCargaUseCase {
  final OperacionCargaRepository repository;

  const GetOperacionesCargaUseCase({required this.repository});

  Future<List<OperacionCarga>> call({String? estado, DateTime? fecha}) {
    return repository.getAll(estado: estado, fecha: fecha);
  }
}
