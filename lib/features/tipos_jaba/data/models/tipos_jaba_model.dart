import '../../domain/entities/tipos_jaba.dart';
import '../../domain/enums/tipo_material_jaba.dart';

class TipoJabaModel extends TipoJaba {
  const TipoJabaModel({
    required super.id,
    required super.idEmpresa,
    required super.estado,
    required super.nombre,
    required super.tipoMaterial,
    super.descripcion,
    super.empresaNombre,
  });

  factory TipoJabaModel.fromJson(Map<String, dynamic> json) {
    final empresa = json['empresas'] is Map<String, dynamic>
        ? json['empresas'] as Map<String, dynamic>
        : <String, dynamic>{};

    return TipoJabaModel(
      id: json['id_tipo_jaba'] as int? ?? json['id'] as int?,
      idEmpresa: json['id_empresa'] as int?,
      estado: json['estado'] == true,
      nombre: json['nombre']?.toString() ?? '',
      tipoMaterial: TipoMaterialJaba.fromValue(
        json['tipo_material']?.toString() ?? '',
      ),
      descripcion: json['descripcion']?.toString(),
      empresaNombre: empresa['nombre_comercial']?.toString(),
    );
  }

  static List<TipoJabaModel> listFrom(dynamic response) {
    if (response is List) {
      return response
          .whereType<Map>()
          .map((e) => TipoJabaModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    if (response is Map<String, dynamic> && response['data'] is List) {
      return (response['data'] as List)
          .whereType<Map>()
          .map((e) => TipoJabaModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    if (response is Map<String, dynamic>) {
      return [TipoJabaModel.fromJson(response)];
    }

    return [];
  }
}