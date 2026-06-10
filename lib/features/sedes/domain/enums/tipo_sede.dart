enum TipoSede {
  origen,
  destino,
  ambos,
}

extension TipoSedeX on TipoSede {
  String get value {
    switch (this) {
      case TipoSede.origen:
        return 'origen';
      case TipoSede.destino:
        return 'destino';
      case TipoSede.ambos:
        return 'ambos';
    }
  }

  String get label {
    switch (this) {
      case TipoSede.origen:
        return 'Origen';
      case TipoSede.destino:
        return 'Destino';
      case TipoSede.ambos:
        return 'Ambos';
    }
  }

  static TipoSede fromValue(String value) {
    switch (value.toLowerCase().trim()) {
      case 'origen':
        return TipoSede.origen;
      case 'destino':
        return TipoSede.destino;
      case 'ambos':
        return TipoSede.ambos;
      default:
        throw Exception('Tipo de sede no válido: $value');
    }
  }
}