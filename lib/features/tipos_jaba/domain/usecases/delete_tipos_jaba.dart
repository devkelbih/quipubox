import '../repositories/tipos_jaba_repository.dart';
class DeleteTipoJabaUseCase { final TipoJabaRepository repository; DeleteTipoJabaUseCase(this.repository); Future<void> call(int id) => repository.delete(id); }
