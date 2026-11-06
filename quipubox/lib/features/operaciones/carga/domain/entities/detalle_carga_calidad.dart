class DetalleCargaCalidad {
  final int? id;
  final int? idEmpresa;
  final int idDetalleCarga;
  final int idCalidad;
  final int cantidad;
  final double? precioUnitario;
  final String? nombreCalidad;

  const DetalleCargaCalidad({
    this.id,
    this.idEmpresa,
    required this.idDetalleCarga,
    required this.idCalidad,
    required this.cantidad,
    this.precioUnitario,
    this.nombreCalidad,
  });

  DetalleCargaCalidad copyWith({int? idEmpresa}) => DetalleCargaCalidad(
    id: id,
    idEmpresa: idEmpresa ?? this.idEmpresa,
    idDetalleCarga: idDetalleCarga,
    idCalidad: idCalidad,
    cantidad: cantidad,
    precioUnitario: precioUnitario,
    nombreCalidad: nombreCalidad,
  );
}
