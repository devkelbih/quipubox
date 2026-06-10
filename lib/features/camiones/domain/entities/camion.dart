class Camion {
  final int id;
final int idEmpresa;
final bool estado;
final String placa;
final String? descripcion;
final String? observaciones;
  const Camion({required this.id, required this.idEmpresa, required this.estado, required this.placa, this.descripcion, this.observaciones});
}
