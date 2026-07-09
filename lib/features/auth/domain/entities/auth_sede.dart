import 'package:quipubox/features/sedes/domain/enums/tipo_sede.dart';

class AuthSede {
  final int id;
  final String nombre;
  final TipoSede tipoSede;
  final String? ciudad;
  final String? departamento;
  const AuthSede({
    required this.id,
    required this.nombre,
    required this.tipoSede,
    this.ciudad,
    this.departamento,
  });
}
