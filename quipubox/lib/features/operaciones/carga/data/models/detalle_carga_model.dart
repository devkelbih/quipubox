import 'package:quipubox/features/catalogos/frutas/data/models/fruta_model.dart';
import 'package:quipubox/features/catalogos/tipos_jaba/data/models/tipos_jaba_model.dart';
import 'package:quipubox/features/catalogos/variedades/data/models/variedad_model.dart';
import 'package:quipubox/features/catalogos/variedades/data/models/variedad_resumen_model.dart';
import 'package:quipubox/features/organizacion/clientes/data/models/cliente_model.dart';
import 'package:quipubox/features/organizacion/clientes/data/models/cliente_puesto_model.dart';
import 'package:quipubox/features/organizacion/clientes/data/models/cliente_sede_model.dart';
import 'package:quipubox/features/organizacion/lugares_operativos/data/models/lugar_operativo_model.dart';
import 'package:quipubox/features/organizacion/puestos/data/models/puesto_model.dart';
import 'package:quipubox/features/organizacion/sedes/data/models/sede_model.dart';

import '../../../../catalogos/frutas/domain/entities/fruta.dart';
import '../../../../catalogos/tipos_jaba/domain/entities/tipos_jaba.dart';
import '../../../../catalogos/variedades/domain/entities/variedad.dart';
import '../../../../organizacion/clientes/domain/entities/cliente.dart';
import '../../../../organizacion/clientes/domain/entities/cliente_puesto.dart';
import '../../../../organizacion/clientes/domain/entities/cliente_sede.dart';
import '../../../../organizacion/lugares_operativos/domain/entities/lugar_operativo.dart';
import '../../../../organizacion/puestos/domain/entities/puesto.dart';
import '../../../../organizacion/sedes/domain/entities/sede.dart';
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
  final ClienteModel? clienteEmisor;
  final FrutaModel? fruta;
  final VariedadModel? variedad;
  final TipoJabaModel? tipoJaba;
  final List<String> calidades;
  final List<String> clientesReceptores;

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
    this.clienteEmisor,
    this.fruta,
    this.variedad,
    this.tipoJaba,
    this.calidades = const [],
    this.clientesReceptores = const [],
  });

  factory DetalleCargaModel.fromJson(Map<String, dynamic> json) {
    final frutaJson = _asMap(json['frutas']);
    final variedadJson = _asMap(json['variedades']);
    final tipoJabaJson = _asMap(json['tipos_jaba']);
    final clienteJson = _asMap(json['clientes']);

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
      calidades:
          (json['detalle_carga_calidades'] is List
                  ? json['detalle_carga_calidades'] as List
                  : const [])
              .whereType<Map>()
              .map(
                (item) =>
                    _asMap(item['calidades'])?['nombre']?.toString().trim() ??
                    '',
              )
              .where((nombre) => nombre.isNotEmpty)
              .toSet()
              .toList(),
      clientesReceptores:
          (json['items_reparto'] is List
                  ? json['items_reparto'] as List
                  : const [])
              .whereType<Map>()
              .map((item) {
                final cliente = _asMap(item['clientes']);
                return '${cliente?['nombres'] ?? ''} ${cliente?['apellidos'] ?? ''}'
                    .trim();
              })
              .where((nombre) => nombre.isNotEmpty)
              .toSet()
              .toList(),
      fruta: frutaJson == null ? null : FrutaModel.fromJson(frutaJson),
      variedad: variedadJson == null
          ? null
          : VariedadModel.fromJson(variedadJson),
      tipoJaba: tipoJabaJson == null
          ? null
          : TipoJabaModel.fromJson(tipoJabaJson),
      clienteEmisor: clienteJson == null
          ? null
          : ClienteModel.fromJson(clienteJson),
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
      clienteEmisor: _clienteModelFromEntity(detalle.clienteEmisor),
      fruta: _frutaModelFromEntity(detalle.fruta),
      variedad: _variedadModelFromEntity(detalle.variedad),
      tipoJaba: _tipoJabaModelFromEntity(detalle.tipoJaba),
      calidades: detalle.calidades,
      clientesReceptores: detalle.clientesReceptores,
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
    clienteEmisor: clienteEmisor?.toEntity(),
    fruta: fruta?.toEntity(),
    variedad: variedad?.toEntity(),
    tipoJaba: tipoJaba?.toEntity(),
    calidades: calidades,
    clientesReceptores: clientesReceptores,
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

Map<String, dynamic>? _asMap(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;

ClienteModel? _clienteModelFromEntity(Cliente? cliente) {
  if (cliente == null) return null;
  return ClienteModel(
    id: cliente.id ?? 0,
    idEmpresa: cliente.idEmpresa ?? 0,
    nombres: cliente.nombres,
    apellidos: cliente.apellidos,
    apodo: cliente.apodo,
    telefono: cliente.telefono,
    observaciones: cliente.observaciones,
    estado: cliente.estado,
    sedes: cliente.sedes.map(_clienteSedeModelFromEntity).toList(),
    puestos: cliente.puestos.map(_clientePuestoModelFromEntity).toList(),
  );
}

ClienteSedeModel _clienteSedeModelFromEntity(ClienteSede relacion) {
  return ClienteSedeModel(
    id: relacion.id ?? 0,
    idEmpresa: relacion.idEmpresa ?? 0,
    idCliente: relacion.idCliente ?? 0,
    idSede: relacion.idSede,
    sede: _sedeModelFromEntity(relacion.sede),
    tipoRelacion: relacion.tipoRelacion,
    observaciones: relacion.observaciones,
    estado: relacion.estado,
    createdAt: relacion.createdAt,
  );
}

ClientePuestoModel _clientePuestoModelFromEntity(ClientePuesto relacion) {
  return ClientePuestoModel(
    id: relacion.id ?? 0,
    idEmpresa: relacion.idEmpresa ?? 0,
    idCliente: relacion.idCliente ?? 0,
    idPuesto: relacion.idPuesto,
    puesto: _puestoModelFromEntity(relacion.puesto),
    fechaInicio: relacion.fechaInicio,
    fechaFin: relacion.fechaFin,
    estado: relacion.estado,
    observaciones: relacion.observaciones,
    seccion: relacion.seccion,
    createdAt: relacion.createdAt,
  );
}

PuestoModel? _puestoModelFromEntity(Puesto? puesto) {
  if (puesto == null) return null;
  return PuestoModel(
    id: puesto.id ?? 0,
    idEmpresa: puesto.idEmpresa ?? 0,
    idLugar: puesto.idLugar,
    lugarOperativo: _lugarOperativoModelFromEntity(puesto.lugarOperativo),
    estado: puesto.estado,
    numeroPuesto: puesto.numeroPuesto,
    referencia: puesto.referencia,
  );
}

LugarOperativoModel? _lugarOperativoModelFromEntity(LugarOperativo? lugar) {
  if (lugar == null) return null;
  return LugarOperativoModel(
    id: lugar.id ?? 0,
    idEmpresa: lugar.idEmpresa ?? 0,
    idSede: lugar.idSede,
    sede: _sedeModelFromEntity(lugar.sede),
    estado: lugar.estado,
    nombre: lugar.nombre,
    direccionReferencia: lugar.direccionReferencia,
    observaciones: lugar.observaciones,
    tipoLugar: lugar.tipoLugar,
  );
}

SedeModel? _sedeModelFromEntity(Sede? sede) {
  if (sede == null) return null;
  return SedeModel(
    id: sede.id ?? 0,
    idEmpresa: sede.idEmpresa ?? 0,
    estado: sede.estado,
    nombre: sede.nombre,
    tipoSede: sede.tipoSede,
    direccion: sede.direccion,
    ciudad: sede.ciudad,
    departamento: sede.departamento,
  );
}

FrutaModel? _frutaModelFromEntity(Fruta? fruta) {
  if (fruta == null) return null;
  return FrutaModel(
    id: fruta.id ?? 0,
    idEmpresa: fruta.idEmpresa ?? 0,
    estado: fruta.estado,
    nombre: fruta.nombre,
    descripcion: fruta.descripcion,
    variedades: fruta.variedades
        ?.map(
          (variedad) => VariedadResumenModel(
            id: variedad.id,
            nombre: variedad.nombre,
            estado: variedad.estado,
          ),
        )
        .toList(),
  );
}

VariedadModel? _variedadModelFromEntity(Variedad? variedad) {
  if (variedad == null) return null;
  return VariedadModel(
    id: variedad.id ?? 0,
    idEmpresa: variedad.idEmpresa ?? 0,
    idFruta: variedad.idFruta,
    fruta: _frutaModelFromEntity(variedad.fruta),
    estado: variedad.estado,
    nombre: variedad.nombre,
    descripcion: variedad.descripcion,
  );
}

TipoJabaModel? _tipoJabaModelFromEntity(TiposJaba? tipoJaba) {
  if (tipoJaba == null) return null;
  return TipoJabaModel(
    id: tipoJaba.id ?? 0,
    idEmpresa: tipoJaba.idEmpresa ?? 0,
    estado: tipoJaba.estado,
    nombre: tipoJaba.nombre,
    tipoMaterial: tipoJaba.tipoMaterial,
    descripcion: tipoJaba.descripcion,
  );
}
