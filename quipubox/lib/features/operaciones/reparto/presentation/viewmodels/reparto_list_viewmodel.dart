import '../../../../../core/state/base_state_viewmodel.dart';
import '../../../carga/domain/entities/operacion_carga.dart';
import '../../../carga/domain/usecases/get_operaciones_carga.dart';

class RepartoListViewModel extends BaseStateViewModel {
  final GetOperacionesCargaUseCase getOperaciones;
  RepartoListViewModel({required this.getOperaciones});
  List<OperacionCarga> operaciones = [];
  String? estado;
  DateTime? fecha;
  Future<void> setFilters({String? estado, DateTime? fecha}) async {
    this.estado = estado;
    this.fecha = fecha;
    await load();
  }

  Future<void> load() async {
    if (isLoading) return;
    final result = await run<List<OperacionCarga>>(
      state: ViewModelActionState.loading,
      action: () => getOperaciones(estado: estado, fecha: fecha),
    );
    if (result == null) return;
    operaciones = result.where((o) => o.id != null).toList()
      ..sort((a, b) => b.fechaCarga.compareTo(a.fechaCarga));
    notifyListeners();
  }
}
