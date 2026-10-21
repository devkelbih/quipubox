import 'package:quipubox/features/catalogos/camiones/data/models/camion_model.dart';
import 'package:quipubox/features/organizacion/roles/data/models/role_model.dart';
import 'package:quipubox/features/organizacion/sedes/data/models/sede_model.dart';
import 'package:quipubox/features/organizacion/usuarios/data/models/usuario_model.dart';

import '../../../../catalogos/camiones/domain/entities/camion.dart';
import '../../../../organizacion/sedes/domain/entities/sede.dart';
import '../../../../organizacion/usuarios/domain/entities/usuario.dart';
import '../../domain/entities/operacion_carga.dart';
import 'detalle_carga_model.dart';

class OperacionCargaModel {
  final int? id;
  final int? idEmpresa;
  final int idSedeOrigen;
  final int? idSedeDestino;
  final int idCamion;
  final int? idEncargadoCarga;
  final int? idRepartidorAsignado;
  final DateTime fechaCarga;
  final String? horaCarga;
  final String estado;
  final String? observaciones;
  final List<DetalleCargaModel>? detalles;
  final SedeModel? sedeOrigen;
  final SedeModel? sedeDestino;
  final CamionModel? camion;
  final UsuarioModel? encargadoCarga;
  final UsuarioModel? repartidorAsignado;

  const OperacionCargaModel({
    this.id,
    this.idEmpresa,
    required this.idSedeOrigen,
    this.idSedeDestino,
    required this.idCamion,
    this.idEncargadoCarga,
    this.idRepartidorAsignado,
    required this.fechaCarga,
    this.horaCarga,
    required this.estado,
    this.observaciones,
    this.detalles,
    this.sedeOrigen,
    this.sedeDestino,
    this.camion,
    this.encargadoCarga,
    this.repartidorAsignado,
  });

  factory OperacionCargaModel.fromJson(Map<String, dynamic> json) {
    final rawDetalles = json['detalle_carga'];
    final camionJson = _asMap(json['camiones']);
    final sedeOrigenJson = _asMap(
      json['sedes_operaciones_carga_id_sede_origenTosedes'],
    );
    final sedeDestinoJson = _asMap(
      json['sedes_operaciones_carga_id_sede_destinoTosedes'],
    );
    final encargadoJson = _asMap(
      json['usuarios_operaciones_carga_id_encargado_cargaTousuarios'],
    );
    final repartidorJson = _asMap(
      json['usuarios_operaciones_carga_id_repartidor_asignadoTousuarios'],
    );

    return OperacionCargaModel(
      id: _asInt(json['id_operacion']),
      idEmpresa: _asInt(json['id_empresa']),
      idSedeOrigen: _requiredInt(json, 'id_sede_origen'),
      idSedeDestino: _asInt(json['id_sede_destino']),
      idCamion: _requiredInt(json, 'id_camion'),
      idEncargadoCarga: _asInt(json['id_encargado_carga']),
      idRepartidorAsignado: _asInt(json['id_repartidor_asignado']),
      fechaCarga: DateTime.parse(json['fecha_carga'].toString()),
      horaCarga: _timeString(json['hora_carga']),
      estado: json['estado']?.toString() ?? 'pendiente',
      observaciones: json['observaciones']?.toString(),
      detalles: rawDetalles is List
          ? rawDetalles
                .map(
                  (item) => DetalleCargaModel.fromJson(
                    Map<String, dynamic>.from(item as Map),
                  ),
                )
                .toList()
          : null,
      camion: camionJson == null ? null : CamionModel.fromJson(camionJson),
      sedeOrigen: sedeOrigenJson == null
          ? null
          : SedeModel.fromJson(sedeOrigenJson),
      sedeDestino: sedeDestinoJson == null
          ? null
          : SedeModel.fromJson(sedeDestinoJson),
      encargadoCarga: encargadoJson == null
          ? null
          : UsuarioModel.fromJson(encargadoJson),
      repartidorAsignado: repartidorJson == null
          ? null
          : UsuarioModel.fromJson(repartidorJson),
    );
  }

  factory OperacionCargaModel.fromEntity(OperacionCarga operacion) {
    return OperacionCargaModel(
      id: operacion.id,
      idEmpresa: operacion.idEmpresa,
      idSedeOrigen: operacion.idSedeOrigen,
      idSedeDestino: operacion.idSedeDestino,
      idCamion: operacion.idCamion,
      idEncargadoCarga: operacion.idEncargadoCarga,
      idRepartidorAsignado: operacion.idRepartidorAsignado,
      fechaCarga: operacion.fechaCarga,
      horaCarga: operacion.horaCarga,
      estado: operacion.estado,
      observaciones: operacion.observaciones,
      detalles: operacion.detalles?.map(DetalleCargaModel.fromEntity).toList(),
      sedeOrigen: _sedeModelFromEntity(operacion.sedeOrigen),
      sedeDestino: _sedeModelFromEntity(operacion.sedeDestino),
      camion: _camionModelFromEntity(operacion.camion),
      encargadoCarga: _usuarioModelFromEntity(operacion.encargadoCarga),
      repartidorAsignado: _usuarioModelFromEntity(operacion.repartidorAsignado),
    );
  }

  OperacionCarga toEntity() => OperacionCarga(
    id: id,
    idEmpresa: idEmpresa,
    idSedeOrigen: idSedeOrigen,
    idSedeDestino: idSedeDestino,
    idCamion: idCamion,
    idEncargadoCarga: idEncargadoCarga,
    idRepartidorAsignado: idRepartidorAsignado,
    fechaCarga: fechaCarga,
    horaCarga: horaCarga,
    estado: estado,
    observaciones: observaciones,
    detalles: detalles?.map((model) => model.toEntity()).toList(),
    sedeOrigen: sedeOrigen?.toEntity(),
    sedeDestino: sedeDestino?.toEntity(),
    camion: camion?.toEntity(),
    encargadoCarga: encargadoCarga?.toEntity(),
    repartidorAsignado: repartidorAsignado?.toEntity(),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id_operacion': id,
    // TODO: Descomentar cuando el backend añada id_empresa al DTO
    // if (idEmpresa != null) 'id_empresa': idEmpresa,
    'id_sede_origen': idSedeOrigen,
    if (idSedeDestino != null) 'id_sede_destino': idSedeDestino,
    'id_camion': idCamion,
    if (idEncargadoCarga != null) 'id_encargado_carga': idEncargadoCarga,
    if (idRepartidorAsignado != null)
      'id_repartidor_asignado': idRepartidorAsignado,
    'fecha_carga': fechaCarga.toIso8601String(),
    if (horaCarga != null) 'hora_carga': horaCarga,
    'estado': estado,
    if (observaciones != null) 'observaciones': observaciones,
    if (detalles != null)
      'detalle_carga': detalles!.map((model) => model.toJson()).toList(),
  };
}

String? _timeString(dynamic value) {
  if (value == null) return null;
  final text = value.toString();
  final time = text.contains('T') ? text.split('T').last : text;
  return time.split('.').first.replaceFirst(RegExp(r'Z$'), '');
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

CamionModel? _camionModelFromEntity(Camion? camion) {
  if (camion == null) return null;
  return CamionModel(
    id: camion.id ?? 0,
    idEmpresa: camion.idEmpresa ?? 0,
    estado: camion.estado,
    placa: camion.placa,
    descripcion: camion.descripcion,
    observaciones: camion.observaciones,
  );
}

UsuarioModel? _usuarioModelFromEntity(Usuario? usuario) {
  if (usuario == null) return null;
  return UsuarioModel(
    id: usuario.id ?? 0,
    idEmpresa: usuario.idEmpresa ?? 0,
    idSede: usuario.idSede,
    sede: _sedeModelFromEntity(usuario.sede),
    roles: usuario.roles.map(RoleModel.fromEntity).toList(),
    nombres: usuario.nombres,
    apellidos: usuario.apellidos,
    telefono: usuario.telefono,
    email: usuario.email,
    googleUid: usuario.googleUid,
    avatarUrl: usuario.avatarUrl,
    estado: usuario.estado,
  );
}
