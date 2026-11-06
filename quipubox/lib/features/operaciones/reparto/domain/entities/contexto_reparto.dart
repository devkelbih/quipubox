import '../../../carga/domain/entities/detalle_carga.dart';
import '../../../carga/domain/entities/detalle_carga_calidad.dart';
import '../../../carga/domain/entities/operacion_carga.dart';
import '../../../../organizacion/clientes/domain/entities/cliente.dart';
import '../../../../organizacion/clientes/domain/entities/cliente_puesto.dart';
import '../../../../organizacion/clientes/domain/enums/tipos_relacion_cliente_sedes.dart';
import 'reparto.dart';

class ContextoReparto {
  final OperacionCarga operacion;
  final DetalleCarga detalle;
  final List<DetalleCargaCalidad> calidades;
  final List<Reparto> repartos;
  final List<Cliente> clientes;
  const ContextoReparto({
    required this.operacion,
    required this.detalle,
    required this.calidades,
    required this.repartos,
    required this.clientes,
  });
  bool get editable => !const [
    'cancelada',
    'cancelado',
    'completado',
  ].contains(operacion.estado);
  int get clasificadas => calidades.fold(0, (n, c) => n + c.cantidad);
  int get asignadas => repartos.fold(0, (n, r) => n + r.cantidad);
  int asignadoCalidad(int id, {int? excluirLinea}) => repartos
      .expand((r) => r.lineas)
      .where(
        (l) =>
            l.idCalidadCarga == id &&
            (excluirLinea == null || l.id != excluirLinea),
      )
      .fold(0, (n, l) => n + l.cantidad);
  int saldoCalidad(int id, {int? excluirLinea}) =>
      (calidades.where((c) => c.id == id).firstOrNull?.cantidad ?? 0) -
      asignadoCalidad(id, excluirLinea: excluirLinea);
  List<Cliente> get receptores => clientes
      .where(
        (c) =>
            c.estado &&
            c.sedes.any(
              (s) =>
                  s.estado &&
                  s.idSede == operacion.idSedeDestino &&
                  const [
                    TipoRelacionClienteSede.receptor,
                    TipoRelacionClienteSede.ambos,
                  ].contains(s.tipoRelacion),
            ),
      )
      .toList();
  List<ClientePuesto> puestos(int receptor) =>
      clientes
          .where((c) => c.id == receptor)
          .firstOrNull
          ?.puestos
          .where(
            (p) =>
                p.estado &&
                p.fechaFin == null &&
                (p.puesto?.estado ?? false) &&
                p.puesto?.lugarOperativo?.idSede == operacion.idSedeDestino,
          )
          .toList() ??
      [];
}
