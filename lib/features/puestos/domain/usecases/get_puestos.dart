import '../entities/puesto.dart';
import '../repositories/puestos_repository.dart';
class GetPuestosUseCase { final PuestoRepository repository; GetPuestosUseCase(this.repository); Future<List<Puesto>> call() => repository.getAll(); }
