import '../repositories/puestos_repository.dart';
class DeletePuestoUseCase { final PuestoRepository repository; DeletePuestoUseCase(this.repository); Future<void> call(int id) => repository.delete(id); }
