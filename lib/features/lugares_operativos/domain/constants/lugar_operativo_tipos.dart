class LugarOperativoTipos {
  static const mercado = 'mercado';
  static const almacen = 'almacen';
  static const calle = 'calle';
  static const rampa = 'rampa';
  static const pasaje = 'pasaje';
  static const otro = 'otro';

  static const values = [
    mercado,
    almacen,
    calle,
    rampa,
    pasaje,
    otro,
  ];

  static String label(String value) {
    switch (value) {
      case mercado:
        return 'Mercado';
      case almacen:
        return 'Almacén';
      case calle:
        return 'Calle';
      case rampa:
        return 'Rampa';
      case pasaje:
        return 'Pasaje';
      case otro:
        return 'Otro';
      default:
        return value;
    }
  }
}