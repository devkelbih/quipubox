class Sede {
  final int id;
final int idEmpresa;
final bool estado;
final String nombre;
final String tipoSede;
final String? direccion;
final String? ciudad;
final String? departamento;
  const Sede({required this.id, required this.idEmpresa, required this.estado, required this.nombre, required this.tipoSede, this.direccion, this.ciudad, this.departamento});
}
