import '../repositories/variedades_repository.dart';
class DeleteVariedadUseCase { final VariedadRepository repository; DeleteVariedadUseCase(this.repository); Future<void> call(int id) => repository.delete(id); }
