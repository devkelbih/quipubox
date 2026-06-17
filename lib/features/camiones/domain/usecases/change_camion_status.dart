
import 'package:quipubox/features/camiones/domain/entities/camion.dart';
import 'package:quipubox/features/camiones/domain/repositories/camiones_repository.dart';

class ChangeCamionStatusUseCase {
  final CamionRepository repository;

  ChangeCamionStatusUseCase(this.repository);

  Future<Camion> call({required int id, required bool estado}) {
    return repository.changeStatus(id: id, estado: estado);
  }
}
