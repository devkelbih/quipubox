import '../common/string_extensions.dart';
import '../exceptions/app_exception.dart';

class ErrorMessageMapper {
  const ErrorMessageMapper._();

  static String map(Object error) {
    if (error is AppException) return error.message;

    final message = error.toString().value;

    if (message.startsWith('Exception:')) {
      return message.replaceFirst('Exception:', '').value;
    }

    return message.hasText ? message : 'Ocurrió un error inesperado.';
  }
}