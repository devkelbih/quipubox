import '../entities/lugar_operativo.dart';
import '../repositories/lugares_operativos_repository.dart';
class GetLugaresOperativosUseCase { final LugarOperativoRepository repository; GetLugaresOperativosUseCase(this.repository); Future<List<LugarOperativo>> call() => repository.getAll(); }
