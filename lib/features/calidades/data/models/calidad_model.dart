import '../../domain/entities/calidad.dart';

class CalidadModel extends Calidad {
  const CalidadModel({
    required super.id,
    required super.idEmpresa,
    required super.estado,
    required super.nombre,
    super.descripcion,
    super.empresaNombre,
  });

  factory CalidadModel.fromJson(Map<String, dynamic> json) {
    final empresa = json['empresas'] is Map<String, dynamic>
        ? json['empresas'] as Map<String, dynamic>
        : <String, dynamic>{};

    return CalidadModel(
      id: json['id_calidad'] as int? ?? json['id'] as int?,
      idEmpresa: json['id_empresa'] as int?,
      estado: json['estado'] == true,
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      empresaNombre: empresa['nombre_comercial']?.toString(),
    );
  }

  static List<CalidadModel> listFrom(dynamic response) {
    if (response is List) {
      return response
          .whereType<Map>()
          .map((e) => CalidadModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    if (response is Map<String, dynamic> && response['data'] is List) {
      return (response['data'] as List)
          .whereType<Map>()
          .map((e) => CalidadModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    if (response is Map<String, dynamic>) {
      return [CalidadModel.fromJson(response)];
    }

    return [];
  }
}
