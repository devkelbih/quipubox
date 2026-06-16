import '../../domain/entities/lugar_operativo.dart';

class LugarOperativoModel extends LugarOperativo {
  const LugarOperativoModel({
    required super.id,
    required super.idEmpresa,
    required super.idSede,
    required super.estado,
    required super.nombre,
    super.direccionReferencia,
    super.observaciones,
    required super.tipoLugar,
    super.empresa,
    required super.sede,
  });

  factory LugarOperativoModel.fromJson(Map<String, dynamic> json) {
    final empresa = json['empresas'] is Map<String, dynamic>
        ? json['empresas'] as Map<String, dynamic>
        : <String, dynamic>{};

    final sede = json['sedes'] is Map<String, dynamic>
        ? json['sedes'] as Map<String, dynamic>
        : <String, dynamic>{};

    return LugarOperativoModel(
      id: json['id_lugar'] as int? ?? 0,
      idEmpresa: json['id_empresa'] as int? ?? 0,
      idSede: json['id_sede'] as int? ?? 0,
      estado: json['estado'] == true,
      nombre: json['nombre']?.toString() ?? '',
      direccionReferencia: _cleanNullable(json['direccion_referencia']),
      observaciones: _cleanNullable(json['observaciones']),
      tipoLugar: json['tipo_lugar']?.toString() ?? 'otro',
      empresa: empresa.isEmpty
          ? null
          : LugarEmpresaResumen(
              id: empresa['id_empresa'] as int? ?? 0,
              nombreComercial:
                  empresa['nombre_comercial']?.toString() ?? 'Sin empresa',
              ruc: _cleanNullable(empresa['ruc']),
            ),
      sede: LugarSedeResumen(
        id: sede['id_sede'] as int? ?? json['id_sede'] as int? ?? 0,
        nombre: sede['nombre']?.toString() ?? 'Sede sin nombre',
        tipoSede: _cleanNullable(sede['tipo_sede']),
        ciudad: _cleanNullable(sede['ciudad']),
        departamento: _cleanNullable(sede['departamento']),
        estado: sede['estado'] == true,
      ),
    );
  }

  static List<LugarOperativoModel> listFrom(dynamic response) {
    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map(LugarOperativoModel.fromJson)
          .toList();
    }

    if (response is Map<String, dynamic> && response['data'] is List) {
      return (response['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(LugarOperativoModel.fromJson)
          .toList();
    }

    if (response is Map<String, dynamic>) {
      return [LugarOperativoModel.fromJson(response)];
    }

    return [];
  }

  static String? _cleanNullable(dynamic value) {
    final text = value?.toString().trim();

    if (text == null || text.isEmpty || text.toLowerCase() == 'null') {
      return null;
    }

    return text;
  }
}