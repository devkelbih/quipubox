abstract final class StringUtils {
  const StringUtils._();

  static bool isBlank(String? value) {
    return value == null || value.trim().isEmpty;
  }

  static String? emptyToNull(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}