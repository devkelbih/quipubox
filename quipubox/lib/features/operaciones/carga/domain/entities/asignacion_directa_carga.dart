/// Instrucción de creación: la API la guarda en items_reparto,
/// no como campos del detalle de mercadería.
class AsignacionDirectaCarga {
  final int idClienteReceptor;
  final int idPuesto;
  final String? seccion;

  const AsignacionDirectaCarga({
    required this.idClienteReceptor,
    required this.idPuesto,
    this.seccion,
  });
}
