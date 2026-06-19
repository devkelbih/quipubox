import 'package:quipubox/features/frutas/domain/entities/fruta.dart';
import 'package:quipubox/features/frutas/domain/repositories/fruta_repository.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/session/current_session.dart';

class CreateFrutaUseCase {
  final FrutaRepository repository;
  final CurrentSession currentSession;

  CreateFrutaUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<Fruta> call(Fruta fruta) {
    final idEmpresa = currentSession.currentCompanyId;

    if (idEmpresa == null) {
      throw const AppException('No se encontró la empresa del usuario.');
    }

    return repository.create(
      fruta.copyWith(idEmpresa: idEmpresa),
    );
  }
}
