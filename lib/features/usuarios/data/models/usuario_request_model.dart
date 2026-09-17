import 'package:quipubox/features/usuarios/domain/entities/usuario.dart';

class UsuarioRequestModel {
  final int? idEmpresa;
  final int idSede;
  final String nombres;
  final String? apellidos;
  final String? telefono;
  final String email;
  final List<int> roles;

  const UsuarioRequestModel({
    this.idEmpresa,
    required this.idSede,
    required this.nombres,
    this.apellidos,
    this.telefono,
    required this.email,
    required this.roles,
  });

  factory UsuarioRequestModel.fromEntity(Usuario usuario) {
    return UsuarioRequestModel(
      idEmpresa: usuario.idEmpresa,
      idSede: usuario.idSede,
      nombres: usuario.nombres,
      apellidos: usuario.apellidos,
      telefono: usuario.telefono,
      email: usuario.email,
      roles: usuario.roleIds,
    );
  }

  Map<String, dynamic> toCreateJson() => {
    if (idEmpresa != null) 'id_empresa': idEmpresa,
    'id_sede': idSede,
    'nombres': nombres.trim(),
    if (apellidos != null && apellidos!.trim().isNotEmpty)
      'apellidos': apellidos!.trim(),
    if (telefono != null && telefono!.trim().isNotEmpty)
      'telefono': telefono!.trim(),
    'email': email.trim(),
    'roles': roles,
  };

  Map<String, dynamic> toUpdateJson() => {
    'id_sede': idSede,
    'nombres': nombres.trim(),
    if (apellidos != null && apellidos!.trim().isNotEmpty)
      'apellidos': apellidos!.trim(),
    if (telefono != null && telefono!.trim().isNotEmpty)
      'telefono': telefono!.trim(),
    'email': email.trim(),
    'roles': roles,
  };
}
