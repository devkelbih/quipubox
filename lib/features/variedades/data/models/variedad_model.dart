import '../../domain/entities/variedad.dart';

class VariedadModel extends Variedad {
  const VariedadModel({
    required super.id,
    required super.idEmpresa,
    required super.idFruta,
    required super.estado,
    required super.nombre,
    super.descripcion,
    super.frutaNombre,
    super.empresaNombre,
  });

  factory VariedadModel.fromJson(Map<String, dynamic> json) {
    final empresa = json['empresas'] is Map<String, dynamic>
        ? json['empresas'] as Map<String, dynamic>
        : <String, dynamic>{};

    final fruta = json['frutas'] is Map<String, dynamic>
        ? json['frutas'] as Map<String, dynamic>
        : <String, dynamic>{};

    return VariedadModel(
      id: json['id_variedad'] as int? ?? json['id'] as int?,
      idEmpresa: json['id_empresa'] as int?,
      idFruta: json['id_fruta'] as int?,
      estado: json['estado'] == true,
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      frutaNombre: fruta['nombre']?.toString(),
      empresaNombre: empresa['nombre_comercial']?.toString(),
    );
  }

  static List<VariedadModel> listFrom(dynamic response) {
    if (response is List) {
      return response
          .whereType<Map>()
          .map((e) => VariedadModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    if (response is Map<String, dynamic> && response['data'] is List) {
      return (response['data'] as List)
          .whereType<Map>()
          .map((e) => VariedadModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    if (response is Map<String, dynamic>) {
      return [VariedadModel.fromJson(response)];
    }

    return [];
  }
}
