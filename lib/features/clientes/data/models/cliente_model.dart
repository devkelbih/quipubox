import 'package:quipubox/features/clientes/data/models/cliente_puesto_model.dart';
import 'package:quipubox/features/clientes/data/models/cliente_sede_model.dart';

import '../../domain/entities/cliente.dart';

class ClienteModel {
  final int id;
  final int idEmpresa;

  final String nombres;
  final String? apellidos;
  final String? apodo;
  final String? telefono;
  final String? observaciones;

  final bool estado;

  final List<ClienteSedeModel> sedes;
  final List<ClientePuestoModel> puestos;

  const ClienteModel({
    required this.id,
    required this.idEmpresa,
    required this.nombres,
    this.apellidos,
    this.apodo,
    this.telefono,
    this.observaciones,
    required this.estado,
    required this.sedes,
    required this.puestos,
  });

  /// Convierte el JSON recibido desde la API
  /// hacia un modelo de infraestructura.
  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    final sedesJson = json['cliente_sede'] is List
        ? json['cliente_sede'] as List
        : const [];

    final puestosJson = json['clientes_puestos'] is List
        ? json['clientes_puestos'] as List
        : const [];

    return ClienteModel(
      id: _readInt(json['id_cliente'] ?? json['id']),
      idEmpresa: _readInt(json['id_empresa']),
      nombres: json['nombres']?.toString() ?? '',
      apellidos: _readNullableString(json['apellidos']),
      apodo: _readNullableString(json['apodo']),
      telefono: _readNullableString(json['telefono']),
      observaciones: _readNullableString(json['observaciones']),
      estado: json['estado'] == true,
      sedes: sedesJson
          .whereType<Map>()
          .map(
            (e) => ClienteSedeModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
      puestos: puestosJson
          .whereType<Map>()
          .map(
            (e) => ClientePuestoModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
    );
  }

  /// Convierte el modelo hacia la entidad
  /// utilizada por la capa Domain.
  Cliente toEntity() {
    return Cliente(
      id: id,
      idEmpresa: idEmpresa,
      nombres: nombres,
      apellidos: apellidos,
      apodo: apodo,
      telefono: telefono,
      observaciones: observaciones,
      estado: estado,
      sedes: sedes.map((e) => e.toEntity()).toList(),
      puestos: puestos.map((e) => e.toEntity()).toList(),
    );
  }

  static List<ClienteModel> listFrom(dynamic data) {
    if (data is! List) return [];

    return data
        .whereType<Map>()
        .map(
          (e) => ClienteModel.fromJson(
            Map<String, dynamic>.from(e),
          ),
        )
        .toList();
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
}