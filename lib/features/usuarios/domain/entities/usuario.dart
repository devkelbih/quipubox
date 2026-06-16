import '../../../company/domain/entities/empresa.dart';
import '../../../roles/domain/entities/role.dart';
import '../../../sedes/domain/entities/sede.dart';

class Usuario {
  final int id;

  final Empresa empresa;
  final Sede sede;
  final List<Role> roles;

  final String nombres;
  final String apellidos;
  final String? telefono;
  final String email;

  final String? googleUid;
  final String? avatarUrl;

  final String estadoAcceso;
  final bool estado;

  const Usuario({
    required this.id,
    required this.empresa,
    required this.sede,
    required this.roles,
    required this.nombres,
    required this.apellidos,
    this.telefono,
    required this.email,
    this.googleUid,
    this.avatarUrl,
    required this.estadoAcceso,
    required this.estado,
  });

  String get nombreCompleto => '$nombres $apellidos'.trim();

  int get idEmpresa => empresa.id;

  int get idSede => sede.id!;

  List<int> get roleIds => roles.map((e) => e.id).toList();
}
