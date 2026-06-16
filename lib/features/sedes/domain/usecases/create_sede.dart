import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/session/current_session.dart';
import '../entities/sede.dart';
import '../repositories/sedes_repository.dart';

class CreateSedeUseCase {
  final SedeRepository repository;
  final CurrentSession currentSession;

  CreateSedeUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<Sede> call(Sede sede) {
    final idEmpresa = currentSession.currentCompanyId;

    if (idEmpresa == null) {
      throw const AppException('No se encontró la empresa del usuario.');
    }

    return repository.create(
      sede.copyWith(idEmpresa: idEmpresa),
    );
  }
}