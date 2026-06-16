import '../../domain/entities/role.dart';

class RoleModel extends Role {
  const RoleModel({
    required super.id,
    required super.nombre,
    super.descripcion,
    required super.estado,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id_rol_usuario'] as int? ?? json['id'] as int? ?? 0,
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      estado: json['estado'] == true,
    );
  }

  static List<RoleModel> listFrom(dynamic response) {
    if (response is! List) return [];

    return response
        .whereType<Map>()
        .map((e) => RoleModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}