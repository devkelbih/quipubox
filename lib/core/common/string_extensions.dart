/// Extensiones para trabajar con String no nulos.
///
/// Su objetivo es facilitar el consumo de texto ya existente,
/// mejorando la legibilidad del código sin modificar el valor original.
extension StringExtension on String {
  /// Indica si el texto contiene caracteres distintos de espacios.
  ///
  /// Ejemplo:
  /// ```dart
  /// 'Hola'.hasText // true
  /// '   '.hasText  // false
  /// ```
  bool get hasText => trim().isNotEmpty;

  /// Devuelve el texto sin espacios al inicio ni al final.
  ///
  /// Ejemplo:
  /// ```dart
  /// '  Hola  '.value // 'Hola'
  /// ```
  String get value => trim();
}

/// Extensiones para trabajar con String que pueden ser nulos.
///
/// Permiten consumir datos provenientes de la API o la base de datos
/// de forma segura y consistente.
extension NullableStringExtension on String? {
  /// Indica si el texto existe y contiene caracteres distintos de espacios.
  ///
  /// Ejemplo:
  /// ```dart
  /// nombre.hasText
  /// ```
  bool get hasText => this != null && this!.trim().isNotEmpty;

  /// Devuelve el texto limpio (trim).
  ///
  /// Si el valor es `null` o queda vacío después del `trim`,
  /// devuelve `null`.
  ///
  /// Ejemplo:
  /// ```dart
  /// '  Hola '.value // 'Hola'
  /// '   '.value     // null
  /// null.value      // null
  /// ```
  String? get value {
    final text = this?.trim();

    if (text == null || text.isEmpty) {
      return null;
    }

    return text;
  }

  /// Devuelve el texto limpio o una cadena vacía si no existe.
  ///
  /// Ejemplo:
  /// ```dart
  /// descripcion.orEmpty
  /// ```
  String get orEmpty => value ?? '';
}