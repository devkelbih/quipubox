import '../../../../organizacion/clientes/data/models/cliente_model.dart';
import '../../../../organizacion/puestos/data/models/puesto_model.dart';
import '../../domain/entities/reparto.dart';

int readInt(dynamic value) => int.parse('$value');
Map<String, dynamic>? readMap(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;

class RepartoLineaModel {
  final Map<String, dynamic> json;
  const RepartoLineaModel(this.json);
  RepartoLinea toEntity() {
    final calidad = readMap(json['detalle_carga_calidades']);
    return RepartoLinea(
      id: int.tryParse('${json['id_item_reparto_detalle']}'),
      idCalidadCarga: readInt(json['id_detalle_carga_calidad']),
      cantidad: readInt(json['cantidad']),
      precio: json['precio_unitario'] == null
          ? null
          : double.parse('${json['precio_unitario']}'),
      nombre: readMap(calidad?['calidades'])?['nombre']?.toString(),
    );
  }

  static Map<String, dynamic> toJson(RepartoLinea l, {bool update = false}) => {
    if (!update) 'id_detalle_carga_calidad': l.idCalidadCarga,
    'cantidad': l.cantidad,
    if (update || l.precio != null) 'precio_unitario': l.precio,
  };
}

class RepartoModel {
  final Map<String, dynamic> json;
  const RepartoModel(this.json);
  Reparto toEntity() {
    final cliente = readMap(json['clientes']);
    final puesto = readMap(json['puestos']);
    return Reparto(
      id: readInt(json['id_item_reparto']),
      detalleId: readInt(json['id_detalle_carga']),
      operacionId: int.tryParse(
        '${readMap(json['detalle_carga'])?['id_operacion']}',
      ),
      receptorId: int.tryParse('${json['id_cliente_receptor']}'),
      puestoId: readInt(json['id_puesto']),
      cantidad: readInt(json['cantidad_asignada']),
      orden: int.tryParse('${json['orden_entrega']}'),
      seccion: json['seccion']?.toString(),
      observaciones: json['observaciones']?.toString(),
      receptor: cliente == null
          ? null
          : ClienteModel.fromJson(cliente).toEntity(),
      puesto: puesto == null ? null : PuestoModel.fromJson(puesto).toEntity(),
      lineas: (json['items_reparto_detalle'] as List? ?? [])
          .whereType<Map>()
          .map(
            (l) => RepartoLineaModel(Map<String, dynamic>.from(l)).toEntity(),
          )
          .toList(),
      tieneEntregas: (json['entregas'] as List? ?? []).isNotEmpty,
      tieneGuia:
          json['guia_asociada'] != null ||
          (json['guias_operativas'] as List? ?? []).isNotEmpty,
    );
  }
}

class AsignacionRepartoModel {
  static Map<String, dynamic> toJson(
    AsignacionReparto a, {
    bool simple = false,
    bool update = false,
  }) => {
    'id_cliente_receptor': a.receptorId,
    'id_puesto': a.puestoId,
    if (simple || update) 'cantidad_asignada': a.cantidad,
    if (!simple && !update)
      'detalles': a.lineas.map((l) => RepartoLineaModel.toJson(l)).toList(),
    if (update || a.orden != null) 'orden_entrega': a.orden,
    if (update || a.seccion != null) 'seccion': a.seccion,
    if (update || a.observaciones != null) 'observaciones': a.observaciones,
  };
}
