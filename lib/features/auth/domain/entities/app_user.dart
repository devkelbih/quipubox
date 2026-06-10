class AppUser {
  final int id;
  final int idEmpresa;
  final int idRol;
  final int idSede;

  final String email;
  final String nombres;
  final String apellidos;
  final String estadoAcceso;
  final bool estado;
  final String? telefono;
  final String? avatarUrl;

  final String? empresaNombre;
  final String? razonSocial;
  final String? nombreComercial;
  final String? empresaRuc;

  final String? rolNombre;
  final String? sedeNombre;

  const AppUser({
    required this.id,
    required this.idEmpresa,
    required this.idRol,
    required this.idSede,
    required this.email,
    required this.nombres,
    required this.apellidos,
    required this.estadoAcceso,
    required this.estado,
    this.telefono,
    this.avatarUrl,
    this.empresaNombre,
    this.razonSocial,
    this.nombreComercial,
    this.empresaRuc,
    this.rolNombre,
    this.sedeNombre,
  });

  String get fullName => '$nombres $apellidos'.trim();
}