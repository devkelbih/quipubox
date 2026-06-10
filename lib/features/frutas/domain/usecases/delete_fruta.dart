import '../repositories/frutas_repository.dart';
class DeleteFrutaUseCase { final FrutaRepository repository; DeleteFrutaUseCase(this.repository); Future<void> call(int id) => repository.delete(id); }
