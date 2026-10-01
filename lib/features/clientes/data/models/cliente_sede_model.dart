import '../../../sedes/data/models/sede_model.dart';
import '../../domain/entities/cliente_sede.dart';
import '../../domain/enums/tipos_relacion_cliente_sedes.dart';

class ClienteSedeModel {
  final int id;
  final int idEmpresa;
  final int idCliente;

  final int idSede;
  final SedeModel? sede;

  final TipoRelacionClienteSede tipoRelacion;

  final String? observaciones;
  final bool estado;
  final DateTime? createdAt;

  const ClienteSedeModel({
    required this.id,
    required this.idEmpresa,
    required this.idCliente,
    required this.idSede,
    this.sede,
    required this.tipoRelacion,
    this.observaciones,
    required this.estado,
    this.createdAt,
  });

  /// Convierte el JSON recibido desde la API
  /// hacia un modelo de infraestructura.
  factory ClienteSedeModel.fromJson(Map<String, dynamic> json) {
    final sedeJson = json['sedes'] is Map
        ? Map<String, dynamic>.from(json['sedes'] as Map)
        : null;

    return ClienteSedeModel(
      id: _readInt(json['id_cliente_sede'] ?? json['id']),
      idEmpresa: _readInt(json['id_empresa']),
      idCliente: _readInt(json['id_cliente']),
      idSede: _readInt(json['id_sede']),
      sede: sedeJson != null ? SedeModel.fromJson(sedeJson) : null,
      tipoRelacion: TipoRelacionClienteSede.fromValue(
        json['tipo_relacion']!.toString(),
      ),
      observaciones: _readNullableString(json['observaciones']),
      estado: json['estado'] == true,
      createdAt: _readDateTime(json['created_at']),
    );
  }

  /// Convierte el modelo hacia la entidad
  /// utilizada por la capa Domain.
  ClienteSede toEntity() {
    return ClienteSede(
      id: id,
      idEmpresa: idEmpresa,
      idCliente: idCliente,
      idSede: idSede,
      sede: sede?.toEntity(),
      tipoRelacion: tipoRelacion,
      observaciones: observaciones,
      estado: estado,
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