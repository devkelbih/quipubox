import '../../domain/usecases/update_calidad_detalle.dart';
import '../../../../../core/state/base_state_viewmodel.dart';
import '../../../../catalogos/calidades/domain/entities/calidad.dart';
import '../../../../catalogos/calidades/domain/usecases/get_calidades.dart';
import '../../domain/entities/detalle_carga_calidad.dart';
import '../../domain/usecases/get_calidades_detalle.dart';
import '../../domain/usecases/add_calidad_detalle.dart';

class DetalleCalidadViewModel extends BaseStateViewModel {
  final GetCalidadesUseCase getCalidades;
  final GetCalidadesDetalleUseCase getRegistradas;
  final UpdateCalidadDetalleUseCase updateCalidad;
  final AddCalidadDetalleUseCase addCalidad;
  DetalleCalidadViewModel({
    required this.getCalidades,
    required this.getRegistradas,
    required this.addCalidad,
    required this.updateCalidad,
  });

  List<Calidad> catalogo = [];
  List<DetalleCargaCalidad> registradas = [];
  int? detalleId;
  bool loaded = false;
  int get cantidadAsignada =>
      registradas.fold<int>(0, (total, item) => total + item.cantidad);

  List<Calidad> get disponibles => catalogo
      .where(
        (item) =>
            item.estado &&
            item.id != null &&
            !registradas.any((entry) => entry.idCalidad == item.id),
      )
      .toList();

  /// El formulario necesita el catálogo y las calidades ya asignadas.
  Future<void> load(int id) => _load(id, includeCatalogo: true);

  /// La ficha solo necesita cantidades y precios registrados.
  Future<void> loadRegistradas(int id) => _load(id, includeCatalogo: false);

  Future<void> _load(int id, {required bool includeCatalogo}) async {
    if (isLoading) return;
    detalleId = id;
    loaded = false;
    catalogo = [];
    registradas = [];
    await runBool(
      state: ViewModelActionState.loading,
      action: () async {
        if (includeCatalogo) {
          final results = await Future.wait<Object>([
            getCalidades(),
            getRegistradas(id),
          ]);
          catalogo = results[0] as List<Calidad>;
          registradas = results[1] as List<DetalleCargaCalidad>;
        } else {
          registradas = await getRegistradas(id);
        }
        loaded = true;
      },
    );
  }

  Future<bool> save({
    required int? idCalidad,
    required String cantidad,
    required String precio,
    required int cantidadTotal,
    DetalleCargaCalidad? editing,
  }) => runBool(
    state: ViewModelActionState.saving,
    action: () async {
      final item = DetalleCargaCalidad(
        id: editing?.id,
        idDetalleCarga: loaded ? detalleId ?? 0 : 0,
        idCalidad: idCalidad ?? 0,
        cantidad: int.tryParse(cantidad.trim()) ?? 0,
        precioUnitario: precio.trim().isEmpty
            ? null
            : double.tryParse(precio.trim().replaceAll(',', '.')) ?? double.nan,
      );
      final saved =
          await (editing == null ? addCalidad.call : updateCalidad.call)(
            item,
            registradas: registradas,
            cantidadTotal: cantidadTotal,
          );
      registradas = editing == null
          ? [...registradas, saved]
          : registradas.map((c) => c.id == saved.id ? saved : c).toList();
    },
  );
}
