import '../../domain/entities/sede.dart';
import '../../domain/enums/tipo_sede.dart';

class SedeModel extends Sede {
  const SedeModel({
    required super.id,
    required super.idEmpresa,
    required super.estado,
    required super.nombre,
    required super.tipoSede,
    super.direccion,
    super.ciudad,
    super.departamento,
  });

  factory SedeModel.fromJson(Map<String, dynamic> json) {
    return SedeModel(
      id: json['id_sede'] as int? ?? json['id'] as int?,
      idEmpresa: json['id_empresa'] as int?,
      estado: json['estado'] == true,
      nombre: json['nombre']?.toString() ?? '',
      tipoSede: TipoSedeX.fromValue(json['tipo_sede']?.toString() ?? ''),
      direccion: json['direccion']?.toString(),
      ciudad: json['ciudad']?.toString(),
      departamento: json['departamento']?.toString(),
    );
  }

  static List<SedeModel> listFrom(dynamic response) {
    if (response is List) {
      return response
          .whereType<Map>()
          .map((e) => SedeModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    if (response is Map<String, dynamic> && response['data'] is List) {
      return (response['data'] as List)
          .whereType<Map>()
          .map((e) => SedeModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    if (response is Map<String, dynamic>) {
      return [SedeModel.fromJson(response)];
    }

    return [];
  }
}