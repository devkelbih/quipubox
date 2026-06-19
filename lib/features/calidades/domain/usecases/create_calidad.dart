import 'package:quipubox/features/calidades/domain/entities/calidad.dart';
import 'package:quipubox/features/calidades/domain/repositories/calidad_repository.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/session/current_session.dart';

class CreateCalidadUseCase {
  final CalidadRepository repository;
  final CurrentSession currentSession;

  CreateCalidadUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<Calidad> call(Calidad calidad) {
    final idEmpresa = currentSession.currentCompanyId;

    if (idEmpresa == null) {
      throw const AppException('No se encontró la empresa del usuario.');
    }

    return repository.create(
      calidad.copyWith(idEmpresa: idEmpresa),
    );
  }
}
