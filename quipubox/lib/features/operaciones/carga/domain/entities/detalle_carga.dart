class DetalleCarga {
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
  final int? idClienteReceptor;
  final int? idPuesto;
  final String? idSeccion;

  const DetalleCarga({
    this.id,
    this.idEmpresa,
    this.idOperacion,
    required this.idClienteEmisor,
    required this.idFruta,
    this.idVariedad,
    required this.idTipoJaba,
    required this.cantidadJabas,
    this.esReparto = false,
    this.instruccionReparto,
    this.observaciones,
    this.requiereRetornoJabas = false,
    this.idClienteReceptor,
    this.idPuesto,
    this.idSeccion,
  });

  DetalleCarga copyWith({
    int? id,
    int? idEmpresa,
    int? idOperacion,
    int? idClienteEmisor,
    int? idFruta,
    int? idVariedad,
    int? idTipoJaba,
    int? cantidadJabas,
    bool? esReparto,
    String? instruccionReparto,
    String? observaciones,
    bool? requiereRetornoJabas,
    int? idClienteReceptor,
    int? idPuesto,
    String? idSeccion,
  }) {
    return DetalleCarga(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idOperacion: idOperacion ?? this.idOperacion,
      idClienteEmisor: idClienteEmisor ?? this.idClienteEmisor,
      idFruta: idFruta ?? this.idFruta,
      idVariedad: idVariedad ?? this.idVariedad,
      idTipoJaba: idTipoJaba ?? this.idTipoJaba,
      cantidadJabas: cantidadJabas ?? this.cantidadJabas,
      esReparto: esReparto ?? this.esReparto,
      instruccionReparto: instruccionReparto ?? this.instruccionReparto,
      observaciones: observaciones ?? this.observaciones,
      requiereRetornoJabas: requiereRetornoJabas ?? this.requiereRetornoJabas,
      idClienteReceptor: idClienteReceptor ?? this.idClienteReceptor,
      idPuesto: idPuesto ?? this.idPuesto,
      idSeccion: idSeccion ?? this.idSeccion,
    );
  }
}
