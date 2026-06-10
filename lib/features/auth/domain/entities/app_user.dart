class AppUser {
  final int id;
  final int idEmpresa;
  final String email;
  final String nombres;
  final String apellidos;
  final String? telefono;
  final String? avatarUrl;
  final String estadoAcceso;
  final bool estado;
  final String? empresaNombre;
  final String? rolNombre;
  final String? sedeNombre;

  const AppUser({required this.id, required this.idEmpresa, required this.email, required this.nombres, required this.apellidos, required this.estadoAcceso, required this.estado, this.telefono, this.avatarUrl, this.empresaNombre, this.rolNombre, this.sedeNombre});
  String get fullName => '$nombres $apellidos'.trim();
}
