import 'package:quipubox/features/variedades/domain/entities/variedad.dart';
import 'package:quipubox/features/variedades/domain/repositories/variedad_repository.dart';

class ChangeVariedadStatusUseCase {
  final VariedadRepository repository;

  ChangeVariedadStatusUseCase(this.repository);

  Future<Variedad> call({required int id, required bool estado}) {
    return repository.changeStatus(id: id, estado: estado);
  }
}
