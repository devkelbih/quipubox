import '../entities/puesto.dart';
import '../repositories/puestos_repository.dart';

class GetPuestosUseCase {
  final PuestoRepository repository;
  GetPuestosUseCase({required this.repository});
  Future<List<Puesto>> call() => repository.getAll();
}
