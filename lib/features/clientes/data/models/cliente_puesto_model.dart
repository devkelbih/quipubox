import '../../../puestos/data/models/puesto_model.dart';
import '../../domain/entities/cliente_puesto.dart';
import '../../domain/enums/secciones_cliente_puesto.dart';

class ClientePuestoModel {
  final int id;
  final int idEmpresa;
  final int idCliente;

  final int idPuesto;
  final PuestoModel? puesto;

  final DateTime? fechaInicio;
  final DateTime? fechaFin;

  final bool estado;
  final String? observaciones;

  final SeccionClientePuesto? seccion;

  final DateTime? createdAt;

  const ClientePuestoModel({
    required this.id,
    required this.idEmpresa,
    required this.idCliente,
    required this.idPuesto,
    this.puesto,
    this.fechaInicio,
    this.fechaFin,
    required this.estado,
    this.observaciones,
    this.seccion,
    this.createdAt,
  });

  /// Convierte el JSON recibido desde la API
  /// hacia un modelo de infraestructura.
  factory ClientePuestoModel.fromJson(Map<String, dynamic> json) {
    final puestoJson = json['puestos'] is Map
        ? Map<String, dynamic>.from(json['puestos'] as Map)
        : null;

    return ClientePuestoModel(
      id: _readInt(json['id_cliente_puesto'] ?? json['id']),
      idEmpresa: _readInt(json['id_empresa']),
      idCliente: _readInt(json['id_cliente']),
      idPuesto: _readInt(json['id_puesto']),
      puesto: puestoJson != null ? PuestoModel.fromJson(puestoJson) : null,
      fechaInicio: _readDateTime(json['fecha_inicio']),
      fechaFin: _readDateTime(json['fecha_fin']),
      estado: json['estado'] == true,
      observaciones: _readNullableString(json['observaciones']),
      seccion: json['seccion'] == null
          ? null
          : SeccionClientePuesto.fromValue(json['seccion'].toString()),
      createdAt: _readDateTime(json['created_at']),
    );
  }

  /// Convierte el modelo hacia la entidad
  /// utilizada por la capa Domain.
  ClientePuesto toEntity() {
    return ClientePuesto(
      id: id,
      idEmpresa: idEmpresa,
      idCliente: idCliente,
      idPuesto: idPuesto,
      puesto: puesto?.toEntity(),
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
      estado: estado,
      observaciones: observaciones,
      seccion: seccion,
      createdAt: createdAt,
    );
  }

  static int _readInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String? _readNullableString(dynamic value) {
    final text = value?.toString().trim();

    if (text == null || text.isEmpty) {
      return null;
    }

    return text;
  }

  static DateTime? _readDateTime(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
  }
}
