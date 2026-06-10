import '../repositories/lugares_operativos_repository.dart';
class DeleteLugarOperativoUseCase { final LugarOperativoRepository repository; DeleteLugarOperativoUseCase(this.repository); Future<void> call(int id) => repository.delete(id); }
