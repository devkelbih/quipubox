class Empresa {
  final int id;
  final String razonSocial;
  final String nombreComercial;
  final String ruc;
  final String? telefono;
  final String? direccion;
  final bool estado;

  const Empresa({
    required this.id,
    required this.razonSocial,
    required this.nombreComercial,
    required this.ruc,
    this.telefono,
    this.direccion,
    required this.estado,
  });
}