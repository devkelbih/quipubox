import '../../../../../core/state/base_state_viewmodel.dart';
import '../../domain/entities/contexto_reparto.dart';
import '../../domain/entities/reparto.dart';
import '../../domain/usecases/get_contexto_reparto.dart';
import '../../domain/usecases/save_asignaciones_reparto.dart';
import '../../domain/usecases/update_reparto.dart';
import '../../domain/usecases/save_linea_reparto.dart';
import '../../domain/usecases/delete_reparto.dart';

class RepartoDetailViewModel extends BaseStateViewModel {
  final GetContextoRepartoUseCase getContexto;
  final SaveAsignacionesRepartoUseCase saveAsignaciones;
  final UpdateRepartoUseCase updateReparto;
  final SaveLineaRepartoUseCase saveLinea;
  final DeleteRepartoUseCase deleteReparto;
  RepartoDetailViewModel({
    required this.getContexto,
    required this.saveAsignaciones,
    required this.updateReparto,
    required this.saveLinea,
    required this.deleteReparto,
  });
  ContextoReparto? data;
  Future<void> load(int operationId, int detailId) async {
    final result = await run<ContextoReparto>(
      state: ViewModelActionState.loading,
      action: () => getContexto(operationId, detailId),
    );
    if (result != null) {
      data = result;
      notifyListeners();
    }
  }

  Future<bool> _mutate(
    Future<void> Function(ContextoReparto c) action, {
    bool deleting = false,
  }) async {
    if (isBusy || data == null) return false;
    final current = data!;
    final ok = await runBool(
      state: deleting
          ? ViewModelActionState.deleting
          : ViewModelActionState.saving,
      action: () => action(current),
    );
    if (ok) await load(current.operacion.id!, current.detalle.id!);
    return ok;
  }

  Future<bool> assign(List<AsignacionReparto> items) =>
      _mutate((c) => saveAsignaciones(c.operacion.id!, c.detalle.id!, items));
  Future<bool> update(int id, AsignacionReparto item) =>
      _mutate((c) => updateReparto(c.operacion.id!, c.detalle.id!, id, item));
  Future<bool> line(int itemId, RepartoLinea item) =>
      _mutate((c) => saveLinea(c.operacion.id!, c.detalle.id!, itemId, item));
  Future<bool> remove(int itemId, {int? lineaId}) => _mutate(
    (c) =>
        deleteReparto(c.operacion.id!, c.detalle.id!, itemId, lineaId: lineaId),
    deleting: true,
  );
}
