import '../../domain/entities/role.dart';

class RoleModel {
  final int id;
  final String nombre;
  final String? descripcion;
  final bool estado;

  const RoleModel({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.estado,
  });

  /// Convierte el JSON recibido desde la API
  /// en un modelo de infraestructura (Data Layer).
  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id_rol_usuario'] as int? ?? json['id'] as int? ?? 0,
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      estado: json['estado'] == true,
    );
  }

  /// Convierte el modelo hacia la entidad de dominio.
  ///
  /// La capa Domain nunca debería depender
  /// de modelos de infraestructura.
  Role toEntity() {
    return Role(
      id: id,
      nombre: nombre,
      descripcion: descripcion,
      estado: estado,
    );
  }

  /// Convierte una entidad de dominio
  /// nuevamente en un modelo.
  ///
  /// Útil para:
  /// - Cache local
  /// - Persistencia
  /// - Serialización
  /// - Construcción de otros modelos complejos
  factory RoleModel.fromEntity(Role role) {
    return RoleModel(
      id: role.id,
      nombre: role.nombre,
      descripcion: role.descripcion,
      estado: role.estado,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'estado': estado,
    };
  }
}
