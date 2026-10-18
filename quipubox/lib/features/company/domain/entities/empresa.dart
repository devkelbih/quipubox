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

  Empresa copyWith({
    int? id,
    String? razonSocial,
    String? nombreComercial,
    String? ruc,
    String? telefono,
    String? direccion,
    bool? estado,
  }) {
    return Empresa(
      id: id ?? this.id,
      razonSocial: razonSocial ?? this.razonSocial,
      nombreComercial: nombreComercial ?? this.nombreComercial,
      ruc: ruc ?? this.ruc,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      estado: estado ?? this.estado,
    );
  }
}