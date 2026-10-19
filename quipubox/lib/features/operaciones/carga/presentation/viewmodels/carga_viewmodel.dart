import '../../../../../core/state/base_state_viewmodel.dart';
import '../../domain/entities/detalle_carga.dart';
import '../../domain/entities/guia_operacion_carga.dart';
import '../../domain/entities/operacion_carga.dart';
import '../../domain/usecases/cancelar_operacion_carga.dart';
import '../../domain/usecases/change_estado_operacion_carga.dart';
import '../../domain/usecases/create_operacion_carga.dart';
import '../../domain/usecases/finalizar_operacion_carga.dart';
import '../../domain/usecases/generar_guias_operacion_carga.dart';
import '../../domain/usecases/get_detalles_operacion.dart';
import '../../domain/usecases/get_operacion_carga_by_id.dart';
import '../../domain/usecases/get_operaciones_carga.dart';
import '../../domain/usecases/update_operacion_carga.dart';

class CargaViewModel extends BaseStateViewModel {
  final GetOperacionesCargaUseCase getOperacionesUseCase;
  final GetOperacionCargaByIdUseCase getOperacionByIdUseCase;
  final CreateOperacionCargaUseCase createOperacionUseCase;
  final UpdateOperacionCargaUseCase updateOperacionUseCase;
  final ChangeEstadoOperacionCargaUseCase changeEstadoUseCase;
  final CancelarOperacionCargaUseCase cancelarUseCase;
  final FinalizarOperacionCargaUseCase finalizarUseCase;
  final GenerarGuiasOperacionCargaUseCase generarGuiasUseCase;
  final GetDetallesOperacionUseCase getDetallesUseCase;

  CargaViewModel({
    required this.getOperacionesUseCase,
    required this.getOperacionByIdUseCase,
    required this.createOperacionUseCase,
    required this.updateOperacionUseCase,
    required this.changeEstadoUseCase,
    required this.cancelarUseCase,
    required this.finalizarUseCase,
    required this.generarGuiasUseCase,
    required this.getDetallesUseCase,
  });

  List<OperacionCarga> items = [];
  OperacionCarga? selected;
  List<DetalleCarga> detalles = [];

  Future<void> load() async {
    final result = await run<List<OperacionCarga>>(
      state: ViewModelActionState.loading,
      action: getOperacionesUseCase.call,
    );

    if (result != null) {
      items = result;
      notifyListeners();
    }
  }

  Future<bool> loadById(int id) async {
    selected = null;
    detalles = [];
    notifyListeners();

    final result = await run<OperacionCarga>(
      state: ViewModelActionState.loading,
      action: () async {
        final operation = await getOperacionByIdUseCase(id);
        detalles = await getDetallesUseCase(id);
        return operation;
      },
    );

    if (result == null) return false;

    selected = result;
    notifyListeners();
    return true;
  }

  Future<bool> create(OperacionCarga operation) async {
    final result = await run<OperacionCarga>(
      state: ViewModelActionState.saving,
      action: () => createOperacionUseCase(operation),
    );

    if (result == null) return false;

    items = [...items, result];
    selected = result;
    detalles = result.detalles ?? [];
    notifyListeners();
    return true;
  }

  Future<bool> update(OperacionCarga operation) async {
    final result = await run<OperacionCarga>(
      state: ViewModelActionState.saving,
      action: () => updateOperacionUseCase(operation),
    );

    if (result == null) return false;

    _replaceItem(result);
    selected = result;
    detalles = result.detalles ?? detalles;
    notifyListeners();
    return true;
  }

  Future<bool> changeEstado({required int id, required String estado}) async {
    final result = await run<OperacionCarga>(
      state: ViewModelActionState.changingStatus,
      action: () => changeEstadoUseCase(id: id, estado: estado),
    );

    if (result == null) return false;

    _replaceItem(result);
    if (selected?.id == id) selected = result;
    notifyListeners();
    return true;
  }

  Future<bool> cancelar(int id) async {
    OperacionCarga? result;
    final succeeded = await runBool(
      state: ViewModelActionState.changingStatus,
      action: () async {
        result = await cancelarUseCase(id);
      },
    );

    if (!succeeded || result == null) return false;

    _replaceItem(result!);
    if (selected?.id == id) selected = result;
    notifyListeners();
    return true;
  }

  Future<bool> finalizar(int id) async {
    final result = await run<OperacionCarga>(
      state: ViewModelActionState.changingStatus,
      action: () => finalizarUseCase(id),
    );

    if (result == null) return false;

    _replaceItem(result);
    if (selected?.id == id) selected = result;
    notifyListeners();
    return true;
  }

  Future<bool> generarGuias(int id) async {
    final result = await run<List<GuiaOperacionCarga>>(
      state: ViewModelActionState.saving,
      action: () => generarGuiasUseCase(id),
    );

    if (result == null) return false;

    await loadById(id);
    notifyListeners();
    return true;
  }

  void _replaceItem(OperacionCarga operation) {
    final index = items.indexWhere((item) => item.id == operation.id);
    if (index == -1) return;

    final updated = [...items];
    updated[index] = operation;
    items = updated;
  }
}
