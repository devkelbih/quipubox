import '../../domain/entities/puesto.dart';
class PuestoModel extends Puesto {
  const PuestoModel({required super.id, required super.idEmpresa, required super.estado, required super.idLugar, required super.numeroPuesto, super.referencia});
  factory PuestoModel.fromJson(Map<String, dynamic> json) => PuestoModel(id: json['id_puesto'] as int? ?? 0, idEmpresa: json['id_empresa'] as int? ?? 1, estado: json['estado'] == true, idLugar: json['id_lugar'] as int? ?? 0,
numeroPuesto: json['numero_puesto']?.toString() ?? '',
referencia: json['referencia']?.toString(),);
  static List<PuestoModel> listFrom(dynamic response) {
    if (response is List) return response.map((e) => PuestoModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic> && response['data'] is List) return (response['data'] as List).map((e) => PuestoModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic>) return [PuestoModel.fromJson(response)];
    return [];
  }
}
