import '../entities/operacion_carga.dart';
import '../repositories/operacion_carga_repository.dart';

class GetOperacionCargaByIdUseCase {
  final OperacionCargaRepository repository;

  const GetOperacionCargaByIdUseCase({required this.repository});

  Future<OperacionCarga> call(int id) => repository.getById(id);
}
