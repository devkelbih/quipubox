import '../entities/calidad.dart';
import '../repositories/calidades_repository.dart';
class GetCalidadesUseCase { final CalidadRepository repository; GetCalidadesUseCase(this.repository); Future<List<Calidad>> call() => repository.getAll(); }
