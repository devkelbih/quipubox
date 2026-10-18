// Extensiones utilitarias para trabajar con cadenas de texto (`String` y `String?`).
// Su propósito es simplificar la validación, limpieza y transformación de texto
// en todo el proyecto (Formularios, Entidades, Modelos JSON), evitando código repetitivo.

import 'string_utils.dart';

export 'string_utils.dart';

/// Extensiones para trabajar con `String` obligatorios (no nulos).
extension StringExtension on String {
  /// Indica si el texto contiene caracteres reales (ignora espacios vacíos).
  /// 
  /// **Útil para:** Validar campos requeridos en formularios o entidades.
  /// 
  /// Ejemplo:
  /// ```dart
  /// 'Hola'.hasText // true
  /// '   '.hasText  // false
  /// ```
  bool get hasText => trim().isNotEmpty;

  /// Devuelve el texto aplicando un `trim()` automático (sin espacios a los lados).
  /// 
  /// **Útil para:** Limpiar textos antes de asignarlos o mostrarlos.
  /// 
  /// Ejemplo:
  /// ```dart
  /// '  Hola  '.value // 'Hola'
  /// ```
  String get value => trim();
}

/// Extensiones para trabajar con `String?` opcionales (que pueden ser nulos).
extension NullableStringExtension on String? {
  /// Indica si el texto no es nulo y contiene caracteres reales (ignora espacios).
  /// 
  /// **Útil para:** Validaciones seguras sin necesidad de escribir 
  /// `if (texto != null && texto!.trim().isNotEmpty)`.
  /// 
  /// Ejemplo:
  /// ```dart
  /// String? nombre;
  /// nombre.hasText // false
  /// ```
  bool get hasText => !StringUtils.isBlank(this);

  /// Limpia los espacios (`trim`) y maneja la nulidad de forma inteligente.
  /// 
  /// **Útil para:** Modelos y Request Models (DTOs). Si el texto queda vacío o es nulo, 
  /// devuelve `null` automáticamente para evitar enviar strings vacíos `""` a la API o BD.
  /// 
  /// Ejemplo:
  /// ```dart
  /// '  Hola '.value // 'Hola'
  /// '     '.value // null
  /// null.value    // null
  /// ```
  String? get value {
    return StringUtils.emptyToNull(this);
  }

  /// Devuelve el texto limpio, o una cadena vacía `''` si es nulo o vacío.
  /// 
  /// **Útil para:** Pintar textos en la interfaz de usuario (Widgets de Flutter) 
  /// donde no puedes permitir valores `null`.
  /// 
  /// Ejemplo:
  /// ```dart
  /// descripcion.orEmpty // Devuelve el texto o '' si era null
  /// ```
  String get orEmpty => value ?? '';
}
