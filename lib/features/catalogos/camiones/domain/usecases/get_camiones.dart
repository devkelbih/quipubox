import '../entities/camion.dart';
import '../repositories/camiones_repository.dart';

class GetCamionesUseCase {
  final CamionRepository repository;

  GetCamionesUseCase({required this.repository});
  Future<List<Camion>> call() => repository.getAll();
}
