import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/core/session/current_session.dart';

import '../entities/lugar_operativo.dart';
import '../repositories/lugares_operativos_repository.dart';

class CreateLugarOperativoUseCase {
  final LugarOperativoRepository repository;
  final CurrentSession currentSession;

  CreateLugarOperativoUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<LugarOperativo> call(LugarOperativo lugarOperativo) {
    final idEmpresa = currentSession.currentCompanyId;

    if (idEmpresa == null) {
      throw const AppException('No se encontró la empresa del usuario.');
    }

    return repository.create(
      lugarOperativo.copyWith(
        idEmpresa: idEmpresa,
      ),
    );
  }
}