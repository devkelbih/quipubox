class Role {
  final int id;
  final String nombre;
  final String? descripcion;
  final bool estado;

  const Role({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.estado,
  });
}