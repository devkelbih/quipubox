enum TipoMaterialJaba {
  madera('madera', 'Madera'),
  plastico('plastico', 'Plástico'),
  carton('carton', 'Cartón');

  final String value;
  final String label;

  const TipoMaterialJaba(this.value, this.label);

  static TipoMaterialJaba fromValue(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'plastico':
      case 'plástico':
        return TipoMaterialJaba.plastico;
      case 'carton':
      case 'cartón':
        return TipoMaterialJaba.carton;
      case 'madera':
      default:
        return TipoMaterialJaba.madera;
    }
  }
}