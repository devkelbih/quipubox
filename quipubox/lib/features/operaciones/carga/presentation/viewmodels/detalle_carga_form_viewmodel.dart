import '../../domain/usecases/update_detalle_operacion_carga.dart';
import '../../../../../core/state/base_state_viewmodel.dart';
import '../../../../../core/exceptions/app_exception.dart';
import '../../../../organizacion/clientes/domain/entities/cliente.dart';
import '../../../../organizacion/clientes/domain/entities/cliente_puesto.dart';
import '../../../../organizacion/clientes/domain/enums/tipos_relacion_cliente_sedes.dart';
import '../../../../organizacion/clientes/domain/usecases/get_clientes.dart';
import '../../../../catalogos/frutas/domain/entities/fruta.dart';
import '../../../../catalogos/frutas/domain/usecases/get_frutas.dart';
import '../../../../catalogos/variedades/domain/entities/variedad.dart';
import '../../../../catalogos/variedades/domain/usecases/get_variedades.dart';
import '../../../../catalogos/tipos_jaba/domain/entities/tipos_jaba.dart';
import '../../../../catalogos/tipos_jaba/domain/usecases/get_tipos_jaba.dart';
import '../../domain/entities/detalle_carga.dart';
import '../../domain/entities/asignacion_directa_carga.dart';
import '../../domain/usecases/create_detalle_operacion_carga.dart';
import '../../domain/usecases/get_operacion_carga_by_id.dart';
import '../../domain/entities/operacion_carga.dart';

class DetalleCargaFormViewModel extends BaseStateViewModel {
  final GetClientesUseCase getClientes;
  final GetFrutasUseCase getFrutas;
  final GetVariedadesUseCase getVariedades;
  final GetTiposJabaUseCase getTiposJaba;
  DetalleCarga? editing;
  final UpdateDetalleOperacionCargaUseCase updateDetalle;
  final CreateDetalleOperacionCargaUseCase createDetalle;
  final GetOperacionCargaByIdUseCase getOperacion;
  OperacionCarga? operacion;

  DetalleCargaFormViewModel({
    required this.getClientes,
    required this.getFrutas,
    required this.getVariedades,
    required this.getTiposJaba,
    required this.createDetalle,
    required this.updateDetalle,
    required this.getOperacion,
  });

  List<Cliente> clientes = [];
  List<Fruta> frutas = [];
  List<Variedad> variedades = [];
  List<TiposJaba> tiposJaba = [];
  int? idEmisor;
  int? idFruta;
  int? idVariedad;
  int? idTipoJaba;
  int? idReceptor;
  ClientePuesto? puestoDirecto;
  bool esReparto = false;
  bool requiereRetorno = false;
  bool loaded = false;

  List<Variedad> get variedadesDisponibles => variedades
      .where(
        (item) =>
            (item.estado || item.id == editing?.idVariedad) &&
            item.id != null &&
            item.idFruta == idFruta,
      )
      .toList();

  List<ClientePuesto> puestosDe(Cliente cliente) => cliente.puestos
      .where(
        (relacion) =>
            relacion.estado &&
            relacion.fechaFin == null &&
            relacion.idPuesto > 0 &&
            (relacion.puesto?.estado ?? true),
      )
      .toList();

  bool _tieneTipo(Cliente cliente, TipoRelacionClienteSede tipo, int? idSede) =>
      cliente.sedes.any(
        (relacion) =>
            relacion.estado &&
            relacion.idSede == idSede &&
            (relacion.tipoRelacion == tipo ||
                relacion.tipoRelacion == TipoRelacionClienteSede.ambos),
      );

  List<Cliente> get emisoresDisponibles => clientes
      .where(
        (item) =>
            item.id == editing?.idClienteEmisor ||
            _tieneTipo(
              item,
              TipoRelacionClienteSede.emisor,
              operacion?.idSedeOrigen,
            ),
      )
      .toList();

  List<Cliente> get receptoresDisponibles => clientes
      .where(
        (item) => _tieneTipo(
          item,
          TipoRelacionClienteSede.receptor,
          operacion?.idSedeDestino,
        ),
      )
      .toList();

  List<ClientePuesto> get puestosDisponibles {
    final receptor = clientes
        .where((item) => item.id == idReceptor)
        .firstOrNull;
    return receptor == null ? [] : puestosDe(receptor);
  }

  void selectFruta(int? id) {
    idFruta = id;
    idVariedad = null;
    notifyListeners();
  }

  void selectReceptor(int? id) {
    idReceptor = id;
    puestoDirecto = null;
    notifyListeners();
  }

  void setReparto(bool value) {
    esReparto = value;
    idReceptor = null;
    puestoDirecto = null;
    notifyListeners();
  }

  void updateSelection({int? emisor, int? variedad, int? tipoJaba}) {
    if (emisor != null) idEmisor = emisor;
    if (variedad != null) idVariedad = variedad;
    if (tipoJaba != null) idTipoJaba = tipoJaba;
    notifyListeners();
  }

  void selectVariedad(int? value) {
    idVariedad = value;
    notifyListeners();
  }

  void selectPuesto(ClientePuesto? value) {
    puestoDirecto = value;
    notifyListeners();
  }

  void setRetorno(bool value) {
    requiereRetorno = value;
    notifyListeners();
  }

  Future<void> load(int operacionId, {DetalleCarga? item}) async {
    editing = item;
    loaded = false;
    await runBool(
      state: ViewModelActionState.loading,
      action: () async {
        final results = await Future.wait<Object>([
          // TODO: Temporal: usa /clientes/all. Reemplazar por consulta de
          // emisores/receptores por sede y tipo en el servidor, con paginación.
          getClientes(),
          getFrutas(),
          getVariedades(),
          getTiposJaba(),
          getOperacion(operacionId),
        ]);
        clientes = (results[0] as List<Cliente>)
            .where((item) => item.estado && (item.id ?? 0) > 0)
            .toList();
        frutas = (results[1] as List<Fruta>)
            .where((item) => item.estado && (item.id ?? 0) > 0)
            .toList();
        variedades = results[2] as List<Variedad>;
        tiposJaba = (results[3] as List<TiposJaba>)
            .where((item) => item.estado && (item.id ?? 0) > 0)
            .toList();
        operacion = results[4] as OperacionCarga;
        if (item != null) {
          idEmisor = item.idClienteEmisor;
          idFruta = item.idFruta;
          idVariedad = item.idVariedad;
          idTipoJaba = item.idTipoJaba;
          esReparto = item.esReparto;
          requiereRetorno = item.requiereRetornoJabas;
          idReceptor = item.clienteReceptor?.id;
          if (item.clienteEmisor != null &&
              !clientes.any((c) => c.id == item.idClienteEmisor)) {
            clientes.add(item.clienteEmisor!);
          }
          if (item.fruta != null && !frutas.any((f) => f.id == item.idFruta)) {
            frutas.add(item.fruta!);
          }
          if (item.tipoJaba != null &&
              !tiposJaba.any((t) => t.id == item.idTipoJaba)) {
            tiposJaba.add(item.tipoJaba!);
          }
          if (item.variedad != null &&
              !variedades.any((v) => v.id == item.idVariedad)) {
            variedades.add(item.variedad!);
          }
        }
        loaded = true;
      },
    );
  }

  Future<bool> save({
    required int operacionId,
    required String cantidad,
    required String instrucciones,
    required String observaciones,
  }) async {
    final result = await run<DetalleCarga>(
      state: ViewModelActionState.saving,
      action: () async {
        if (!loaded) {
          throw const AppException(
            'Espera a que se carguen los datos del formulario.',
          );
        }
        final detalle = DetalleCarga(
          id: editing?.id,
          idOperacion: operacionId,
          idClienteEmisor: idEmisor ?? 0,
          idFruta: idFruta ?? 0,
          idVariedad: idVariedad,
          idTipoJaba: idTipoJaba ?? 0,
          cantidadJabas: int.tryParse(cantidad.trim()) ?? 0,
          esReparto: esReparto,
          requiereRetornoJabas: requiereRetorno,
          instruccionReparto: instrucciones.trim().isEmpty
              ? null
              : instrucciones.trim(),
          observaciones: observaciones.trim().isEmpty
              ? null
              : observaciones.trim(),
        );
        if (editing != null) {
          return updateDetalle(
            detalle,
            variedad: variedades.where((v) => v.id == idVariedad).firstOrNull,
          );
        }
        final destino = esReparto
            ? null
            : AsignacionDirectaCarga(
                idClienteReceptor: idReceptor ?? 0,
                idPuesto: puestosDisponibles.contains(puestoDirecto)
                    ? puestoDirecto!.idPuesto
                    : 0,
                seccion: puestoDirecto?.seccion?.value,
              );
        return createDetalle(
          operacionId: operacionId,
          detalle: detalle,
          variedad: variedadesDisponibles
              .where((item) => item.id == idVariedad)
              .firstOrNull,
          asignacionDirecta: destino,
        );
      },
    );
    return result != null;
  }
}
