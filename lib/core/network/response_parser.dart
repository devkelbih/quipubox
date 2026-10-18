import 'package:quipubox/core/exceptions/app_exception.dart';

class ResponseParser {
  const ResponseParser._();

  static List<Map<String, dynamic>> extractList(dynamic response) {
    if (response is List) {
      return response.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }

    if (response is Map<String, dynamic> && response['data'] is List) {
      return (response['data'] as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }

    throw AppException(
      'Se esperaba una lista y se recibió '
      '${response.runtimeType}',
    );
  }

  static Map<String, dynamic> extractObject(dynamic response) {
    if (response is Map<String, dynamic>) {
      if (response['data'] is Map<String, dynamic>) {
        return response['data'];
      }

      return response;
    }

    throw AppException(
      'Se esperaba un objeto y se recibió '
      '${response.runtimeType}',
    );
  }
}
