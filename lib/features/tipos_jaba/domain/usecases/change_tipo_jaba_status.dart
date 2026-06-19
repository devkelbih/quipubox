import 'package:quipubox/features/tipos_jaba/domain/entities/tipos_jaba.dart';
import 'package:quipubox/features/tipos_jaba/domain/repositories/tipos_jaba_repository.dart';

class ChangeTipoJabaStatusUseCase {
  final TipoJabaRepository repository;

  ChangeTipoJabaStatusUseCase(this.repository);

  Future<TipoJaba> call({required int id, required bool estado}) {
    return repository.changeStatus(id: id, estado: estado);
  }
}
