import 'package:quipubox/core/common/string_extensions.dart';

enum EstadoOperacionCarga {
  pendiente('pendiente', 'Pendiente'),
  enCurso('en_curso', 'En curso'),
  enTransito('en_transito', 'En tránsito'),
  repartiendo('repartiendo', 'Repartiendo'),
  completado('completado', 'Completado');

  final String value;
  final String label;

  const EstadoOperacionCarga(this.value, this.label);

  static EstadoOperacionCarga fromValue(String value) {
    return EstadoOperacionCarga.values.firstWhere(
      (e) => e.value.toLowerCase() == value.value.toLowerCase(),
      orElse: () =>
          throw Exception('Estado de operación de carga no válido: $value'),
    );
  }
}
