import 'package:quipubox/features/auth/domain/entities/auth_sede.dart';

import '../../../company/domain/entities/empresa.dart';
import '../../../roles/domain/entities/role.dart';

class AuthenticatedUser {
  final int id;

  final Empresa empresa;
  final AuthSede sede;
  final List<Role> roles;

  final String email;
  final String nombres;
  final String apellidos;
  final bool estado;

  final String? telefono;
  final String? avatarUrl;

  const AuthenticatedUser({
    required this.id,
    required this.empresa,
    required this.sede,
    required this.roles,
    required this.email,
    required this.nombres,
    required this.apellidos,
    required this.estado,
    this.telefono,
    this.avatarUrl,
  });

  String get fullName => '$nombres $apellidos'.trim();

  int get idEmpresa => empresa.id;

  int get idSede => sede.id;

  List<int> get roleIds => roles.map((e) => e.id).toList();

  List<String> get roleNames => roles.map((e) => e.nombre).toList();

  bool hasRoleId(int roleId) {
    return roles.any((role) => role.id == roleId);
  }

  bool hasRoleName(String roleName) {
    return roles.any(
      (role) =>
          role.nombre.toLowerCase().trim() == roleName.toLowerCase().trim(),
    );
  }
}
