import 'package:quipubox/features/calidades/domain/entities/calidad.dart';
import 'package:quipubox/features/calidades/domain/repositories/calidad_repository.dart';

class ChangeCalidadStatusUseCase {
  final CalidadRepository repository;

  ChangeCalidadStatusUseCase(this.repository);

  Future<Calidad> call({required int id, required bool estado}) {
    return repository.changeStatus(id: id, estado: estado);
  }
}
