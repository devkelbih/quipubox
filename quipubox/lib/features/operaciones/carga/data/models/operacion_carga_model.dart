import '../../domain/entities/operacion_carga.dart';
import 'detalle_carga_model.dart';

class OperacionCargaModel {
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
  final List<DetalleCargaModel>? detalles;

  const OperacionCargaModel({
    this.id,
    this.idEmpresa,
    required this.idSedeOrigen,
    this.idSedeDestino,
    required this.idCamion,
    this.idEncargadoCarga,
    this.idRepartidorAsignado,
    required this.fechaCarga,
    this.horaCarga,
    required this.estado,
    this.observaciones,
    this.detalles,
  });

  factory OperacionCargaModel.fromJson(Map<String, dynamic> json) {
    final rawDetalles = json['detalle_carga'];

    return OperacionCargaModel(
      id: _asInt(json['id_operacion']),
      idEmpresa: _asInt(json['id_empresa']),
      idSedeOrigen: _requiredInt(json, 'id_sede_origen'),
      idSedeDestino: _asInt(json['id_sede_destino']),
      idCamion: _requiredInt(json, 'id_camion'),
      idEncargadoCarga: _asInt(json['id_encargado_carga']),
      idRepartidorAsignado: _asInt(json['id_repartidor_asignado']),
      fechaCarga: DateTime.parse(json['fecha_carga'].toString()),
      horaCarga: _timeString(json['hora_carga']),
      estado: json['estado']?.toString() ?? 'pendiente',
      observaciones: json['observaciones']?.toString(),
      detalles: rawDetalles is List
          ? rawDetalles
                .map(
                  (item) => DetalleCargaModel.fromJson(
                    Map<String, dynamic>.from(item as Map),
                  ),
                )
                .toList()
          : null,
    );
  }

  factory OperacionCargaModel.fromEntity(OperacionCarga operacion) {
    return OperacionCargaModel(
      id: operacion.id,
      idEmpresa: operacion.idEmpresa,
      idSedeOrigen: operacion.idSedeOrigen,
      idSedeDestino: operacion.idSedeDestino,
      idCamion: operacion.idCamion,
      idEncargadoCarga: operacion.idEncargadoCarga,
      idRepartidorAsignado: operacion.idRepartidorAsignado,
      fechaCarga: operacion.fechaCarga,
      horaCarga: operacion.horaCarga,
      estado: operacion.estado,
      observaciones: operacion.observaciones,
      detalles: operacion.detalles?.map(DetalleCargaModel.fromEntity).toList(),
    );
  }

  OperacionCarga toEntity() => OperacionCarga(
    id: id,
    idEmpresa: idEmpresa,
    idSedeOrigen: idSedeOrigen,
    idSedeDestino: idSedeDestino,
    idCamion: idCamion,
    idEncargadoCarga: idEncargadoCarga,
    idRepartidorAsignado: idRepartidorAsignado,
    fechaCarga: fechaCarga,
    horaCarga: horaCarga,
    estado: estado,
    observaciones: observaciones,
    detalles: detalles?.map((model) => model.toEntity()).toList(),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id_operacion': id,
    // TODO: Descomentar cuando el backend añada id_empresa al DTO
    // if (idEmpresa != null) 'id_empresa': idEmpresa,
    'id_sede_origen': idSedeOrigen,
    if (idSedeDestino != null) 'id_sede_destino': idSedeDestino,
    'id_camion': idCamion,
    if (idEncargadoCarga != null) 'id_encargado_carga': idEncargadoCarga,
    if (idRepartidorAsignado != null)
      'id_repartidor_asignado': idRepartidorAsignado,
    'fecha_carga': fechaCarga.toIso8601String(),
    if (horaCarga != null) 'hora_carga': horaCarga,
    'estado': estado,
    if (observaciones != null) 'observaciones': observaciones,
    if (detalles != null)
      'detalle_carga': detalles!.map((model) => model.toJson()).toList(),
  };
}

String? _timeString(dynamic value) {
  if (value == null) return null;
  final text = value.toString();
  final time = text.contains('T') ? text.split('T').last : text;
  return time.split('.').first.replaceFirst(RegExp(r'Z$'), '');
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

int _requiredInt(Map<String, dynamic> json, String key) {
  final value = _asInt(json[key]);
  if (value == null) throw FormatException('Falta el campo $key');
  return value;
}
