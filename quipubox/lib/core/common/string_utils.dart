/// Clase utilitaria de métodos estáticos para operaciones comunes sobre texto.
/// 
/// **¿Por qué existe si ya hay extensiones?** 
/// Es útil cuando necesitas pasar una función como referencia o cuando prefieres 
/// un enfoque de métodos tradicionales en lugar de extensiones sintácticas.
abstract final class StringUtils {
  const StringUtils._();

  /// Valida si un texto opcional está en blanco (es nulo, vacío o puros espacios).
  /// 
  /// **Útil para:** Validaciones rápidas en lógica de negocio o helpers.
  /// 
  /// Ejemplo:
  /// ```dart
  /// StringUtils.isBlank(miTexto) // true si es null o "" o "   "
  /// ```
  static bool isBlank(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// Limpia el texto con `trim()` y, si queda vacío o es nulo, devuelve `null`.
  /// 
  /// **Útil para:** Armar JSONs y filtrar campos opcionales que no deben enviarse vacíos.
  /// Es exactamente el equivalente funcional al getter `String?.value`.
  /// 
  /// Ejemplo:
  /// ```dart
  /// StringUtils.emptyToNull("   ") // null
  /// StringUtils.emptyToNull(" Juan ") // "Juan"
  /// ```
  static String? emptyToNull(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}