import '../exceptions/app_exception.dart';

class ErrorMessageMapper {
  const ErrorMessageMapper._();

  static String map(Object error) {
    if (error is AppException) return error.message;

    final message = error.toString().trim();

    if (message.startsWith('Exception:')) {
      return message.replaceFirst('Exception:', '').trim();
    }

    return message.isEmpty
        ? 'Ocurrió un error inesperado.'
        : message;
  }
}