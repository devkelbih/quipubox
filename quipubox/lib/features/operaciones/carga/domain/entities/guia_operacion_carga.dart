class GuiaOperacionCarga {
  final int? id;
  final String numeroGuia;
  final DateTime? fechaEmision;
  final int? idRepartidor;
  final int? idItemReparto;
  final int? idPuesto;
  final String? estado;
  final String? observaciones;

  const GuiaOperacionCarga({
    this.id,
    required this.numeroGuia,
    this.fechaEmision,
    this.idRepartidor,
    this.idItemReparto,
    this.idPuesto,
    this.estado,
    this.observaciones,
  });
}
