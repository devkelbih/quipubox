class Cliente {
  final int id;
final int idEmpresa;
final bool estado;
final String nombres;
final String? apellidos;
final String? apodo;
final String telefono;
final String? observaciones;
  const Cliente({required this.id, required this.idEmpresa, required this.estado, required this.nombres, this.apellidos, this.apodo, required this.telefono, this.observaciones});
}
