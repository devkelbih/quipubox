enum SeccionClientePuesto {
  a('A', 'A'),
  b('B', 'B'),
  c('C', 'C');

  final String value;
  final String label;

  const SeccionClientePuesto(this.value, this.label);

  static SeccionClientePuesto fromValue(String value) {
    return SeccionClientePuesto.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase().trim(),
      orElse: () => throw Exception(
        'Sección de cliente puesto no válida: $value',
      ),
    );
  }
}