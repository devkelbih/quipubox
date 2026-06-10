import '../repositories/sedes_repository.dart';
class DeleteSedeUseCase { final SedeRepository repository; DeleteSedeUseCase(this.repository); Future<void> call(int id) => repository.delete(id); }
