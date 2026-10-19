import '../../domain/entities/detalle_carga.dart';

class DetalleCargaModel {
  final int? id;
  final int? idEmpresa;
  final int? idOperacion;
  final int idClienteEmisor;
  final int idFruta;
  final int? idVariedad;
  final int idTipoJaba;
  final int cantidadJabas;
  final bool esReparto;
  final String? instruccionReparto;
  final String? observaciones;
  final bool requiereRetornoJabas;

  const DetalleCargaModel({
    this.id,
    this.idEmpresa,
    this.idOperacion,
    required this.idClienteEmisor,
    required this.idFruta,
    this.idVariedad,
    required this.idTipoJaba,
    required this.cantidadJabas,
    required this.esReparto,
    this.instruccionReparto,
    this.observaciones,
    required this.requiereRetornoJabas,
  });

  factory DetalleCargaModel.fromJson(Map<String, dynamic> json) {
    return DetalleCargaModel(
      id: _asInt(json['id_detalle_carga']),
      idEmpresa: _asInt(json['id_empresa']),
      idOperacion: _asInt(json['id_operacion']),
      idClienteEmisor: _requiredInt(json, 'id_cliente_emisor'),
      idFruta: _requiredInt(json, 'id_fruta'),
      idVariedad: _asInt(json['id_variedad']),
      idTipoJaba: _requiredInt(json, 'id_tipo_jaba'),
      cantidadJabas: _requiredInt(json, 'cantidad_jabas'),
      esReparto: json['es_reparto'] == true,
      instruccionReparto: json['instruccion_reparto']?.toString(),
      observaciones: json['observaciones']?.toString(),
      requiereRetornoJabas: json['requiere_retorno_jabas'] == true,
    );
  }

  factory DetalleCargaModel.fromEntity(DetalleCarga detalle) {
    return DetalleCargaModel(
      id: detalle.id,
      idEmpresa: detalle.idEmpresa,
      idOperacion: detalle.idOperacion,
      idClienteEmisor: detalle.idClienteEmisor,
      idFruta: detalle.idFruta,
      idVariedad: detalle.idVariedad,
      idTipoJaba: detalle.idTipoJaba,
      cantidadJabas: detalle.cantidadJabas,
      esReparto: detalle.esReparto,
      instruccionReparto: detalle.instruccionReparto,
      observaciones: detalle.observaciones,
      requiereRetornoJabas: detalle.requiereRetornoJabas,
    );
  }

  DetalleCarga toEntity() => DetalleCarga(
    id: id,
    idEmpresa: idEmpresa,
    idOperacion: idOperacion,
    idClienteEmisor: idClienteEmisor,
    idFruta: idFruta,
    idVariedad: idVariedad,
    idTipoJaba: idTipoJaba,
    cantidadJabas: cantidadJabas,
    esReparto: esReparto,
    instruccionReparto: instruccionReparto,
    observaciones: observaciones,
    requiereRetornoJabas: requiereRetornoJabas,
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id_detalle_carga': id,
    if (idEmpresa != null) 'id_empresa': idEmpresa,
    if (idOperacion != null) 'id_operacion': idOperacion,
    'id_cliente_emisor': idClienteEmisor,
    'id_fruta': idFruta,
    if (idVariedad != null) 'id_variedad': idVariedad,
    'id_tipo_jaba': idTipoJaba,
    'cantidad_jabas': cantidadJabas,
    'es_reparto': esReparto,
    if (instruccionReparto != null) 'instruccion_reparto': instruccionReparto,
    if (observaciones != null) 'observaciones': observaciones,
    'requiere_retorno_jabas': requiereRetornoJabas,
  };
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

int _requiredInt(Map<String, dynamic> json, String key) {
  final value = _asInt(json[key]);
  if (value == null) throw FormatException('Falta el campo $key');
  return value;
}
