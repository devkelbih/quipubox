import '../../../../../core/exceptions/app_exception.dart';
import '../../../../../core/session/current_session.dart';

int requireCurrentCompanyId(CurrentSession currentSession) {
  final idEmpresa = currentSession.currentCompanyId;

  if (idEmpresa == null) {
    throw const AppException('No se encontró la empresa del usuario.');
  }

  return idEmpresa;
}
