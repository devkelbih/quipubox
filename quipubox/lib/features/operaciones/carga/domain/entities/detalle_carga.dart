import '../../../../catalogos/frutas/domain/entities/fruta.dart';
import '../../../../catalogos/tipos_jaba/domain/entities/tipos_jaba.dart';
import '../../../../catalogos/variedades/domain/entities/variedad.dart';
import '../../../../organizacion/clientes/domain/entities/cliente.dart';

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
  final Cliente? clienteEmisor;

  /// Receptor único disponible en la respuesta, sin convertirlo en una lista.
  final Cliente? clienteReceptor;
  final Fruta? fruta;
  final Variedad? variedad;
  final TiposJaba? tipoJaba;
  final List<String> calidades;

  /// Null cuando la respuesta no incluye las cantidades por calidad.
  final int? cantidadClasificada;

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
    this.clienteEmisor,
    this.clienteReceptor,
    this.fruta,
    this.variedad,
    this.tipoJaba,
    this.calidades = const [],
    this.cantidadClasificada,
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
    Cliente? clienteEmisor,
    Cliente? clienteReceptor,
    Fruta? fruta,
    Variedad? variedad,
    TiposJaba? tipoJaba,
    List<String>? calidades,
    int? cantidadClasificada,
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
      clienteEmisor: clienteEmisor ?? this.clienteEmisor,
      clienteReceptor: clienteReceptor ?? this.clienteReceptor,
      fruta: fruta ?? this.fruta,
      variedad: variedad ?? this.variedad,
      tipoJaba: tipoJaba ?? this.tipoJaba,
      calidades: calidades ?? this.calidades,
      cantidadClasificada: cantidadClasificada ?? this.cantidadClasificada,
    );
  }
}
