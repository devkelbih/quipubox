import '../repositories/calidades_repository.dart';
class DeleteCalidadUseCase { final CalidadRepository repository; DeleteCalidadUseCase(this.repository); Future<void> call(int id) => repository.delete(id); }
