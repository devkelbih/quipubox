enum TipoRelacionClienteSede {
  emisor('emisor', 'Emisor'),

  receptor('receptor', 'Receptor'),

  ambos('ambos', 'Ambos');

  final String value;
  final String label;

  const TipoRelacionClienteSede(this.value, this.label);

  static TipoRelacionClienteSede fromValue(String value) {
    return TipoRelacionClienteSede.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase().trim(),
      orElse: () => throw Exception(
        'Tipo de relación de cliente con sede no válido: $value',
      ),
    );
  }
}
