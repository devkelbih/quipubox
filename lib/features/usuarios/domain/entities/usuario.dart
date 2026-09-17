import '../../../roles/domain/entities/role.dart';
import '../../../sedes/domain/entities/sede.dart';

class Usuario {
  final int? id;

  final int? idEmpresa;

  /// FK utilizada para crear y actualizar.
  final int idSede;

  /// Relación opcional cargada desde el backend.
  final Sede? sede;

  /// Relación muchos-a-muchos mediante usuarios_roles.
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
    required this.idSede,
    this.sede,
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
    int? idSede,
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
      idSede: idSede ?? this.idSede,
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
