import 'package:quipubox/features/clientes/domain/entities/cliente_sede.dart';

class ClienteSedeRequestModel {
  final int idSede;
  final String tipoRelacion;

  const ClienteSedeRequestModel({
    required this.idSede,
    required this.tipoRelacion,
  });

  factory ClienteSedeRequestModel.fromEntity(
    ClienteSede clienteSede,
  ) {
    return ClienteSedeRequestModel(
      idSede: clienteSede.idSede,
      tipoRelacion: clienteSede.tipoRelacion.value,
    );
  }

  Map<String, dynamic> toCreateJson() => {
    'id_sede': idSede,
    'tipo_relacion': tipoRelacion,
  };

  Map<String, dynamic> toUpdateJson() => {
    'tipo_relacion': tipoRelacion,
  };
}