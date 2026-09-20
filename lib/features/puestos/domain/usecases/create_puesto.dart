import 'package:quipubox/features/puestos/domain/repositories/puestos_repository.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/session/current_session.dart';
import '../entities/puesto.dart';

class CreatePuestoUseCase {
  final PuestoRepository repository;
  final CurrentSession currentSession;

  CreatePuestoUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<Puesto> call(Puesto puesto) {
    final idEmpresa = currentSession.currentCompanyId;

    if (idEmpresa == null) {
      throw const AppException('No se encontró la empresa del usuario.');
    }

    return repository.create(
      puesto.copyWith(idEmpresa: idEmpresa),
    );
  }
}