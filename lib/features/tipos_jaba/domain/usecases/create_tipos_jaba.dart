import 'package:quipubox/features/tipos_jaba/domain/entities/tipos_jaba.dart';
import 'package:quipubox/features/tipos_jaba/domain/repositories/tipos_jaba_repository.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/session/current_session.dart';

class CreateTipoJabaUseCase {
  final TipoJabaRepository repository;
  final CurrentSession currentSession;

  CreateTipoJabaUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<TipoJaba> call(TipoJaba tipoJaba) {
    final idEmpresa = currentSession.currentCompanyId;

    if (idEmpresa == null) {
      throw const AppException('No se encontró la empresa del usuario.');
    }

    return repository.create(
      tipoJaba.copyWith(idEmpresa: idEmpresa),
    );
  }
}