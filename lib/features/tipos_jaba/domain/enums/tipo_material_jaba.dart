enum TipoMaterialJaba {
  madera,
  plastico;

  String get value {
    switch (this) {
      case TipoMaterialJaba.madera:
        return 'madera';
      case TipoMaterialJaba.plastico:
        return 'plastico';
    }
  }

  String get label {
    switch (this) {
      case TipoMaterialJaba.madera:
        return 'Madera';
      case TipoMaterialJaba.plastico:
        return 'Plástico';
    }
  }

  static TipoMaterialJaba fromValue(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'plastico':
      case 'plástico':
        return TipoMaterialJaba.plastico;
      case 'madera':
      default:
        return TipoMaterialJaba.madera;
    }
  }
}