import '../../domain/entities/operacion_carga.dart';

class OperacionCargaRequestModel {
  final int idSedeOrigen;
  final int? idSedeDestino;
  final int idCamion;
  final int? idEncargadoCarga;
  final int? idRepartidorAsignado;
  final DateTime fechaCarga;
  final String? horaCarga;
  final String? estado;
  final String? observaciones;

  const OperacionCargaRequestModel({
    required this.idSedeOrigen,
    this.idSedeDestino,
    required this.idCamion,
    this.idEncargadoCarga,
    this.idRepartidorAsignado,
    required this.fechaCarga,
    this.horaCarga,
    this.estado,
    this.observaciones,
  });

  factory OperacionCargaRequestModel.fromEntity(OperacionCarga operacion) {
    return OperacionCargaRequestModel(
      idSedeOrigen: operacion.idSedeOrigen,
      idSedeDestino: operacion.idSedeDestino,
      idCamion: operacion.idCamion,
      idEncargadoCarga: operacion.idEncargadoCarga,
      idRepartidorAsignado: operacion.idRepartidorAsignado,
      fechaCarga: operacion.fechaCarga,
      horaCarga: operacion.horaCarga,
      estado: operacion.estado,
      observaciones: operacion.observaciones,
    );
  }

  Map<String, dynamic> toCreateJson() => {
    'id_sede_origen': idSedeOrigen,
    if (idSedeDestino != null) 'id_sede_destino': idSedeDestino,
    'id_camion': idCamion,
    if (idEncargadoCarga != null) 'id_encargado_carga': idEncargadoCarga,
    if (idRepartidorAsignado != null)
      'id_repartidor_asignado': idRepartidorAsignado,
    'fecha_carga': _dateOnly(fechaCarga),
    if (horaCarga != null) 'hora_carga': horaCarga,
    if (estado != null) 'estado': estado,
    if (observaciones != null) 'observaciones': observaciones,
  };

  Map<String, dynamic> toUpdateJson() => toCreateJson();
}

String _dateOnly(DateTime date) => date.toIso8601String().split('T').first;
