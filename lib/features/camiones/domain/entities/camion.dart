class Camion {
  final int? id;
  final int? idEmpresa;
  final bool estado;
  final String placa;
  final String? descripcion;
  final String? observaciones;

  const Camion({
    this.id,
    this.idEmpresa,
    required this.estado,
    required this.placa,
    this.descripcion,
    this.observaciones,
  });

  Camion copyWith({
    int? id,
    int? idEmpresa,
    bool? estado,
    String? placa,
    String? descripcion,
    String? observaciones,
  }) {
    return Camion(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      estado: estado ?? this.estado,
      placa: placa ?? this.placa,
      descripcion: descripcion ?? this.descripcion,
      observaciones: observaciones ?? this.observaciones,
    );
  }
}
