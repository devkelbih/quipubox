import '../../../../organizacion/clientes/domain/entities/cliente.dart';
import '../../../../organizacion/puestos/domain/entities/puesto.dart';

class RepartoLinea {
  final int? id;
  final int? idEmpresa;
  final int idCalidadCarga;
  final int cantidad;
  final double? precio;
  final String? nombre;
  const RepartoLinea({
    this.id,
    this.idEmpresa,
    required this.idCalidadCarga,
    required this.cantidad,
    this.precio,
    this.nombre,
  });
  RepartoLinea copyWith({int? idEmpresa}) => RepartoLinea(
    id: id,
    idEmpresa: idEmpresa ?? this.idEmpresa,
    idCalidadCarga: idCalidadCarga,
    cantidad: cantidad,
    precio: precio,
    nombre: nombre,
  );
}

class Reparto {
  final int id;
  final int detalleId;
  final int? operacionId;
  final int? receptorId;
  final int puestoId;
  final int cantidad;
  final int? orden;
  final String? seccion;
  final String? observaciones;
  final Cliente? receptor;
  final Puesto? puesto;
  final List<RepartoLinea> lineas;
  final bool tieneEntregas;
  final bool tieneGuia;
  const Reparto({
    required this.id,
    required this.detalleId,
    this.operacionId,
    this.receptorId,
    required this.puestoId,
    required this.cantidad,
    this.orden,
    this.seccion,
    this.observaciones,
    this.receptor,
    this.puesto,
    this.lineas = const [],
    this.tieneEntregas = false,
    this.tieneGuia = false,
  });
  int get cantidadDesglosada => lineas.fold(0, (n, l) => n + l.cantidad);
  bool get protegido => tieneEntregas || tieneGuia;
}

class AsignacionReparto {
  final int? idEmpresa;
  final int receptorId;
  final int puestoId;
  final int cantidad;
  final int? orden;
  final String? seccion;
  final String? observaciones;
  final List<RepartoLinea> lineas;
  const AsignacionReparto({
    this.idEmpresa,
    required this.receptorId,
    required this.puestoId,
    required this.cantidad,
    this.orden,
    this.seccion,
    this.observaciones,
    this.lineas = const [],
  });
  AsignacionReparto copyWith({int? idEmpresa}) => AsignacionReparto(
    idEmpresa: idEmpresa ?? this.idEmpresa,
    receptorId: receptorId,
    puestoId: puestoId,
    cantidad: cantidad,
    orden: orden,
    seccion: seccion,
    observaciones: observaciones,
    lineas: lineas
        .map((l) => l.copyWith(idEmpresa: idEmpresa ?? this.idEmpresa))
        .toList(),
  );
}
