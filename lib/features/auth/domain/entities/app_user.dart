import '../../../company/domain/entities/empresa.dart';
import '../../../roles/domain/entities/role.dart';
import '../../../sedes/domain/entities/sede.dart';

class AppUser {
  final int id;

  final Empresa empresa;
  final Sede sede;
  final List<Role> roles;

  final String email;
  final String nombres;
  final String apellidos;
  final String estadoAcceso;
  final bool estado;

  final String? telefono;
  final String? avatarUrl;

  const AppUser({
    required this.id,
    required this.empresa,
    required this.sede,
    required this.roles,
    required this.email,
    required this.nombres,
    required this.apellidos,
    required this.estadoAcceso,
    required this.estado,
    this.telefono,
    this.avatarUrl,
  });

  String get fullName => '$nombres $apellidos'.trim();

  int get idEmpresa => empresa.id;

  int get idSede => sede.id!;

  List<int> get roleIds => roles.map((e) => e.id).toList();

  List<String> get roleNames => roles.map((e) => e.nombre).toList();

  bool hasRoleId(int roleId) {
    return roles.any((role) => role.id == roleId);
  }

  bool hasRoleName(String roleName) {
    return roles.any(
      (role) => role.nombre.toLowerCase().trim() == roleName.toLowerCase().trim(),
    );
  }
}