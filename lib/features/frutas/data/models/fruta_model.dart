import '../../domain/entities/fruta.dart';

class FrutaModel extends Fruta {
  const FrutaModel({
    required super.id,
    required super.idEmpresa,
    required super.estado,
    required super.nombre,
    super.descripcion,
    super.empresaNombre,
    super.variedadesCount = 0,
  });

  factory FrutaModel.fromJson(Map<String, dynamic> json) {
    final empresa = json['empresas'] is Map<String, dynamic>
        ? json['empresas'] as Map<String, dynamic>
        : <String, dynamic>{};

    final variedades = json['variedades'] is List
        ? json['variedades'] as List
        : const [];

    return FrutaModel(
      id: json['id_fruta'] as int? ?? json['id'] as int?,
      idEmpresa: json['id_empresa'] as int?,
      estado: json['estado'] == true,
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      empresaNombre: empresa['nombre_comercial']?.toString(),
      variedadesCount: variedades.length,
    );
  }

  static List<FrutaModel> listFrom(dynamic response) {
    if (response is List) {
      return response
          .whereType<Map>()
          .map((e) => FrutaModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    if (response is Map<String, dynamic> && response['data'] is List) {
      return (response['data'] as List)
          .whereType<Map>()
          .map((e) => FrutaModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    if (response is Map<String, dynamic>) {
      return [FrutaModel.fromJson(response)];
    }

    return [];
  }
}
