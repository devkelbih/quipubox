class LugarOperativoRequestModel {
  final int idEmpresa;
  final int idSede;
  final String nombre;
  final String? direccionReferencia;
  final String? observaciones;
  final String tipoLugar;

  const LugarOperativoRequestModel({
    required this.idEmpresa,
    required this.idSede,
    required this.nombre,
    this.direccionReferencia,
    this.observaciones,
    required this.tipoLugar,
  });

  Map<String, dynamic> toCreateJson() => {
        'id_empresa': idEmpresa,
        'id_sede': idSede,
        'nombre': nombre.trim(),
        if (direccionReferencia != null &&
            direccionReferencia!.trim().isNotEmpty)
          'direccion_referencia': direccionReferencia!.trim(),
        if (observaciones != null && observaciones!.trim().isNotEmpty)
          'observaciones': observaciones!.trim(),
        'tipo_lugar': tipoLugar.trim(),
      };

  Map<String, dynamic> toUpdateJson() => {
        'id_sede': idSede,
        'nombre': nombre.trim(),
        if (direccionReferencia != null &&
            direccionReferencia!.trim().isNotEmpty)
          'direccion_referencia': direccionReferencia!.trim(),
        if (observaciones != null && observaciones!.trim().isNotEmpty)
          'observaciones': observaciones!.trim(),
        'tipo_lugar': tipoLugar.trim(),
      };
}