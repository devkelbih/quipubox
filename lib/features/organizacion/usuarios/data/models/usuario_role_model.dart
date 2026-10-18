class UsuarioRoleModel {
  final int idUsuarioRol;
  final int idUsuario;
  final int idRolUsuario;
  final DateTime createdAt;

  const UsuarioRoleModel({
    required this.idUsuarioRol,
    required this.idUsuario,
    required this.idRolUsuario,
    required this.createdAt,
  });

  factory UsuarioRoleModel.fromJson(Map<String, dynamic> json) {
    return UsuarioRoleModel(
      idUsuarioRol: json['id_usuario_rol'] as int,
      idUsuario: json['id_usuario'] as int,
      idRolUsuario: json['id_rol_usuario'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

}
