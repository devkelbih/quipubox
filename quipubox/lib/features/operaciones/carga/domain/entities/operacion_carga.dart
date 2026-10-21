import 'detalle_carga.dart';
import '../enums/estado_operacion_carga.dart';
import '../../../../catalogos/camiones/domain/entities/camion.dart';
import '../../../../organizacion/sedes/domain/entities/sede.dart';
import '../../../../organizacion/usuarios/domain/entities/usuario.dart';

class OperacionCarga {
  final int? id;
  final int? idEmpresa;
  final int idSedeOrigen;
  final int? idSedeDestino;
  final int idCamion;
  final int? idEncargadoCarga;
  final int? idRepartidorAsignado;
  final DateTime fechaCarga;
  final String? horaCarga;
  final String estado;
  final String? observaciones;
  final List<DetalleCarga>? detalles;
  final Sede? sedeOrigen;
  final Sede? sedeDestino;
  final Camion? camion;
  final Usuario? encargadoCarga;
  final Usuario? repartidorAsignado;

  const OperacionCarga({
    this.id,
    this.idEmpresa,
    required this.idSedeOrigen,
    this.idSedeDestino,
    required this.idCamion,
    this.idEncargadoCarga,
    this.idRepartidorAsignado,
    required this.fechaCarga,
    this.horaCarga,
    this.estado = 'pendiente',
    this.observaciones,
    this.detalles,
    this.sedeOrigen,
    this.sedeDestino,
    this.camion,
    this.encargadoCarga,
    this.repartidorAsignado,
  });

  EstadoOperacionCarga get estadoEnum => EstadoOperacionCarga.fromValue(estado);

  OperacionCarga copyWith({
    int? id,
    int? idEmpresa,
    int? idSedeOrigen,
    int? idSedeDestino,
    int? idCamion,
    int? idEncargadoCarga,
    int? idRepartidorAsignado,
    DateTime? fechaCarga,
    String? horaCarga,
    String? estado,
    String? observaciones,
    List<DetalleCarga>? detalles,
    Sede? sedeOrigen,
    Sede? sedeDestino,
    Camion? camion,
    Usuario? encargadoCarga,
    Usuario? repartidorAsignado,
  }) {
    return OperacionCarga(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idSedeOrigen: idSedeOrigen ?? this.idSedeOrigen,
      idSedeDestino: idSedeDestino ?? this.idSedeDestino,
      idCamion: idCamion ?? this.idCamion,
      idEncargadoCarga: idEncargadoCarga ?? this.idEncargadoCarga,
      idRepartidorAsignado: idRepartidorAsignado ?? this.idRepartidorAsignado,
      fechaCarga: fechaCarga ?? this.fechaCarga,
      horaCarga: horaCarga ?? this.horaCarga,
      estado: estado ?? this.estado,
      observaciones: observaciones ?? this.observaciones,
      detalles: detalles ?? this.detalles,
      sedeOrigen: sedeOrigen ?? this.sedeOrigen,
      sedeDestino: sedeDestino ?? this.sedeDestino,
      camion: camion ?? this.camion,
      encargadoCarga: encargadoCarga ?? this.encargadoCarga,
      repartidorAsignado: repartidorAsignado ?? this.repartidorAsignado,
    );
  }
}
