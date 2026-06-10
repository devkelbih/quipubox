class Usuario {
  final int id;
final int idEmpresa;
final bool estado;
final int idSede;
final String nombres;
final String apellidos;
final String? telefono;
final String email;
  const Usuario({required this.id, required this.idEmpresa, required this.estado, required this.idSede, required this.nombres, required this.apellidos, this.telefono, required this.email});
}
