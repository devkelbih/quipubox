import '../../domain/entities/detalle_carga.dart';

class DetalleCargaRequestModel {
  final int idClienteEmisor;
  final int idFruta;
  final int? idVariedad;
  final int idTipoJaba;
  final int cantidadJabas;
  final bool esReparto;
  final String? instruccionReparto;
  final String? observaciones;
  final bool requiereRetornoJabas;
  final int? idClienteReceptor;
  final int? idPuesto;
  final String? idSeccion;

  const DetalleCargaRequestModel({
    required this.idClienteEmisor,
    required this.idFruta,
    this.idVariedad,
    required this.idTipoJaba,
    required this.cantidadJabas,
    required this.esReparto,
    this.instruccionReparto,
    this.observaciones,
    required this.requiereRetornoJabas,
    this.idClienteReceptor,
    this.idPuesto,
    this.idSeccion,
  });

  factory DetalleCargaRequestModel.fromEntity(DetalleCarga detalle) {
    return DetalleCargaRequestModel(
      idClienteEmisor: detalle.idClienteEmisor,
      idFruta: detalle.idFruta,
      idVariedad: detalle.idVariedad,
      idTipoJaba: detalle.idTipoJaba,
      cantidadJabas: detalle.cantidadJabas,
      esReparto: detalle.esReparto,
      instruccionReparto: detalle.instruccionReparto,
      observaciones: detalle.observaciones,
      requiereRetornoJabas: detalle.requiereRetornoJabas,
      idClienteReceptor: detalle.idClienteReceptor,
      idPuesto: detalle.idPuesto,
      idSeccion: detalle.idSeccion,
    );
  }

  Map<String, dynamic> toCreateJson() => {
    'id_cliente_emisor': idClienteEmisor,
    'id_fruta': idFruta,
    if (idVariedad != null) 'id_variedad': idVariedad,
    'id_tipo_jaba': idTipoJaba,
    'cantidad_jabas': cantidadJabas,
    'es_reparto': esReparto,
    if (instruccionReparto != null) 'instruccion_reparto': instruccionReparto,
    if (observaciones != null) 'observaciones': observaciones,
    'requiere_retorno_jabas': requiereRetornoJabas,
    if (idClienteReceptor != null) 'id_cliente_receptor': idClienteReceptor,
    if (idPuesto != null) 'id_puesto': idPuesto,
    if (idSeccion != null) 'id_seccion': idSeccion,
  };
}
