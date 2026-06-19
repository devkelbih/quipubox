import 'package:quipubox/features/variedades/domain/entities/variedad.dart';
import 'package:quipubox/features/variedades/domain/repositories/variedad_repository.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/session/current_session.dart';

class CreateVariedadUseCase {
  final VariedadRepository repository;
  final CurrentSession currentSession;

  CreateVariedadUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<Variedad> call(Variedad variedad) {
    final idEmpresa = currentSession.currentCompanyId;

    if (idEmpresa == null) {
      throw const AppException('No se encontró la empresa del usuario.');
    }

    if (variedad.idFruta == null) {
      throw const AppException('Selecciona una fruta.');
    }

    return repository.create(
      variedad.copyWith(idEmpresa: idEmpresa),
    );
  }
}
