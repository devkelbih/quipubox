import '../../domain/entities/detalle_carga_calidad.dart';

class DetalleCargaCalidadModel extends DetalleCargaCalidad {
  const DetalleCargaCalidadModel({
    super.id,
    super.idEmpresa,
    required super.idDetalleCarga,
    required super.idCalidad,
    required super.cantidad,
    super.precioUnitario,
    super.nombreCalidad,
  });

  factory DetalleCargaCalidadModel.fromJson(Map<String, dynamic> json) {
    final calidad = json['calidades'];
    return DetalleCargaCalidadModel(
      id: int.tryParse('${json['id_detalle_carga_calidad']}'),
      idEmpresa: int.tryParse('${json['id_empresa']}'),
      idDetalleCarga: int.parse('${json['id_detalle_carga']}'),
      idCalidad: int.parse('${json['id_calidad']}'),
      cantidad: int.parse('${json['cantidad']}'),
      precioUnitario: json['precio_unitario'] == null
          ? null
          : double.parse('${json['precio_unitario']}'),
      nombreCalidad: calidad is Map ? calidad['nombre']?.toString() : null,
    );
  }

  DetalleCargaCalidad toEntity() => DetalleCargaCalidad(
    id: id,
    idEmpresa: idEmpresa,
    idDetalleCarga: idDetalleCarga,
    idCalidad: idCalidad,
    cantidad: cantidad,
    precioUnitario: precioUnitario,
    nombreCalidad: nombreCalidad,
  );

  static Map<String, dynamic> toCreateJson(DetalleCargaCalidad item) => {
    'id_calidad': item.idCalidad,
    'cantidad': item.cantidad,
    if (item.precioUnitario != null) 'precio_unitario': item.precioUnitario,
  };
}
