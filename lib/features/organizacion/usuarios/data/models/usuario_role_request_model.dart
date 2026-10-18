class UsuarioRoleRequestModel {
  final int idRolUsuario;

  const UsuarioRoleRequestModel({required this.idRolUsuario});

  Map<String, dynamic> toJson() {
    return {'id_rol_usuario': idRolUsuario};
  }
}
