class LugarOperativo {
  final int id;
final int idEmpresa;
final bool estado;
final int idSede;
final String nombre;
final String? direccionReferencia;
final String? observaciones;
final String tipoLugar;
  const LugarOperativo({required this.id, required this.idEmpresa, required this.estado, required this.idSede, required this.nombre, this.direccionReferencia, this.observaciones, required this.tipoLugar});
}
