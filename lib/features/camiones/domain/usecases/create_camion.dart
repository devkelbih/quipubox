import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/session/current_session.dart';
import '../entities/camion.dart';
import '../repositories/camiones_repository.dart';

class CreateCamionUseCase {
  final CamionRepository repository;
  final CurrentSession currentSession;

  CreateCamionUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<Camion> call(Camion camion) {
    final idEmpresa = currentSession.currentCompanyId;

    if (idEmpresa == null) {
      throw const AppException('No se encontró la empresa del usuario.');
    }

    return repository.create(
      camion.copyWith(idEmpresa: idEmpresa),
    );
  }
}