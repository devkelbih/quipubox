class LugarOperativo {
  final int id;
  final int idEmpresa;
  final int idSede;
  final bool estado;

  final String nombre;
  final String? direccionReferencia;
  final String? observaciones;
  final String tipoLugar;

  final LugarEmpresaResumen? empresa;
  final LugarSedeResumen sede;

  const LugarOperativo({
    required this.id,
    required this.idEmpresa,
    required this.idSede,
    required this.estado,
    required this.nombre,
    this.direccionReferencia,
    this.observaciones,
    required this.tipoLugar,
    this.empresa,
    required this.sede,
  });
}

class LugarEmpresaResumen {
  final int id;
  final String nombreComercial;
  final String? ruc;

  const LugarEmpresaResumen({
    required this.id,
    required this.nombreComercial,
    this.ruc,
  });
}

class LugarSedeResumen {
  final int id;
  final String nombre;
  final String? tipoSede;
  final String? ciudad;
  final String? departamento;
  final bool estado;

  const LugarSedeResumen({
    required this.id,
    required this.nombre,
    this.tipoSede,
    this.ciudad,
    this.departamento,
    required this.estado,
  });
}