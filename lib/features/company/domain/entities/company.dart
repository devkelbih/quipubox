class Company {
  final int idEmpresa;
  final String razonSocial;
  final String nombreComercial;
  final String? ruc;
  final String? telefono;
  final String? direccion;
  final bool estado;

  const Company({
    required this.idEmpresa,
    required this.razonSocial,
    required this.nombreComercial,
    this.ruc,
    this.telefono,
    this.direccion,
    required this.estado,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      idEmpresa: int.tryParse(json['id_empresa']?.toString() ?? '') ?? 0,
      razonSocial: json['razon_social']?.toString() ?? '',
      nombreComercial: json['nombre_comercial']?.toString() ?? '',
      ruc: json['ruc']?.toString(),
      telefono: json['telefono']?.toString(),
      direccion: json['direccion']?.toString(),
      estado: json['estado'] == true || json['estado']?.toString() == 'true',
    );
  }
}
