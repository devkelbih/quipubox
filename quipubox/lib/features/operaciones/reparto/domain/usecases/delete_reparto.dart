import '../../../../../core/exceptions/app_exception.dart';
import '../../../../../core/session/current_session.dart';
import '../../../carga/domain/usecases/operacion_carga_usecase_helpers.dart';
import '../repositories/reparto_repository.dart';
import 'get_contexto_reparto.dart';
import 'reparto_validation.dart';

class DeleteRepartoUseCase {
  final RepartoRepository repository;
  final GetContextoRepartoUseCase getContexto;
  final CurrentSession currentSession;
  const DeleteRepartoUseCase({
    required this.repository,
    required this.getContexto,
    required this.currentSession,
  });
  Future<void> call(
    int operationId,
    int detailId,
    int itemId, {
    int? lineaId,
  }) async {
    requireCurrentCompanyId(currentSession);
    final c = await getContexto(operationId, detailId);
    final item = requireItem(c, itemId);
    if (lineaId != null) {
      if (!item.lineas.any((l) => l.id == lineaId)) {
        throw const AppException('La línea ya no pertenece a esta asignación.');
      }
      await repository.deleteLinea(lineaId);
    } else {
      if (item.lineas.isNotEmpty) {
        throw const AppException(
          'Elimina primero las líneas de calidad de esta asignación.',
        );
      }
      await repository.delete(itemId);
    }
  }
}
