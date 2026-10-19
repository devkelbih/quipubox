import '../../domain/entities/guia_operacion_carga.dart';

class GuiaOperacionCargaModel {
  final int? id;
  final String numeroGuia;
  final DateTime? fechaEmision;
  final int? idRepartidor;
  final int? idItemReparto;
  final int? idPuesto;
  final String? estado;
  final String? observaciones;

  const GuiaOperacionCargaModel({
    this.id,
    required this.numeroGuia,
    this.fechaEmision,
    this.idRepartidor,
    this.idItemReparto,
    this.idPuesto,
    this.estado,
    this.observaciones,
  });

  factory GuiaOperacionCargaModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json['fecha_emision'];
    return GuiaOperacionCargaModel(
      id: _asInt(json['id_guia_operativa'] ?? json['id_guia']),
      numeroGuia: json['numero_guia']?.toString() ?? '',
      fechaEmision: rawDate == null ? null : DateTime.parse(rawDate.toString()),
      idRepartidor: _asInt(json['id_repartidor']),
      idItemReparto: _asInt(json['id_item_reparto']),
      idPuesto: _asInt(json['id_puesto']),
      estado: json['estado']?.toString(),
      observaciones: json['observaciones']?.toString(),
    );
  }

  GuiaOperacionCarga toEntity() => GuiaOperacionCarga(
    id: id,
    numeroGuia: numeroGuia,
    fechaEmision: fechaEmision,
    idRepartidor: idRepartidor,
    idItemReparto: idItemReparto,
    idPuesto: idPuesto,
    estado: estado,
    observaciones: observaciones,
  );
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}
