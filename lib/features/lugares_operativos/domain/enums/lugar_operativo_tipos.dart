enum LugarOperativoTipos {
  mercado('mercado', 'Mercado'),
  almacen('almacen', 'Almacén'),
  calle('calle', 'Calle'),
  rampa('rampa', 'Rampa'),
  pasaje('pasaje', 'Pasaje'),
  otro('otro', 'Otro');

  final String value;
  final String label;

  const LugarOperativoTipos(this.value, this.label);

  static LugarOperativoTipos fromValue(String value) {
    return LugarOperativoTipos.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase().trim(),
      orElse: () => throw Exception('Tipo de lugar operativo no válido: $value'),
    );
  }
}