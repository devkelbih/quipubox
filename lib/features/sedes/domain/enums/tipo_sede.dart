enum TipoSede {
  origen('origen', 'Origen'),
  destino('destino', 'Destino'),
  ambos('ambos', 'Ambos');

  final String value;
  final String label;

  const TipoSede(this.value, this.label);

  static TipoSede fromValue(String value) {
    return TipoSede.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase().trim(),
      orElse: () => throw Exception('Tipo de sede no válido: $value'),
    );
  }
}
