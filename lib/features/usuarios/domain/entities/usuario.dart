import '../../../roles/domain/entities/role.dart';
import '../../../sedes/domain/entities/sede.dart';

class Usuario {
  final int? id;

  final int? idEmpresa;
  final Sede sede;
  final List<Role> roles;

  final String nombres;
  final String? apellidos;
  final String? telefono;
  final String email;

  final String? googleUid;
  final String? avatarUrl;

  final bool estado;

  const Usuario({
    this.id,
    this.idEmpresa,
    required this.sede,
    required this.roles,
    required this.nombres,
    this.apellidos,
    this.telefono,
    required this.email,
    this.googleUid,
    this.avatarUrl,
    this.estado = true,
  });

  String get nombreCompleto => '$nombres ${apellidos ?? ''}'.trim();

  List<int> get roleIds => roles.map((e) => e.id).toList();

  Usuario copyWith({
    int? id,
    int? idEmpresa,
    Sede? sede,
    List<Role>? roles,
    String? nombres,
    String? apellidos,
    String? telefono,
    String? email,
    String? googleUid,
    String? avatarUrl,
    bool? estado,
  }) {
    return Usuario(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      sede: sede ?? this.sede,
      roles: roles ?? this.roles,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      googleUid: googleUid ?? this.googleUid,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      estado: estado ?? this.estado,
    );
  }
}