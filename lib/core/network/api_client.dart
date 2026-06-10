import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../exceptions/app_exception.dart';

/// Cliente HTTP centralizado de la aplicación.
///
/// Responsabilidades:
/// - Construir URLs.
/// - Agregar headers comunes.
/// - Agregar automáticamente el JWT de Supabase.
/// - Ejecutar solicitudes HTTP.
/// - Parsear respuestas JSON.
/// - Manejar errores.
/// - Convertir errores técnicos en AppException.
///
/// Todos los módulos consumen este cliente.
class ApiClient {
  ApiClient({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  /// Tiempo máximo permitido para una petición.
  static const _timeout = Duration(seconds: 20);

  /// GET /recurso
  Future<dynamic> get(
    String path, {
    Map<String, String>? query,
  }) => _send(
    'GET',
    path,
    query: query,
  );

  /// POST /recurso
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
  }) => _send(
    'POST',
    path,
    body: body,
  );

  /// PUT /recurso/id
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
  }) => _send(
    'PUT',
    path,
    body: body,
  );

  /// PATCH /recurso/id
  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? body,
  }) => _send(
    'PATCH',
    path,
    body: body,
  );

  /// DELETE /recurso/id
  Future<dynamic> delete(String path) => _send(
    'DELETE',
    path,
  );

  /// Método interno que ejecuta todas las solicitudes.
  ///
  /// Flujo:
  /// 1. Obtiene JWT de Supabase.
  /// 2. Construye URL completa.
  /// 3. Construye headers.
  /// 4. Convierte body a JSON.
  /// 5. Ejecuta petición.
  /// 6. Procesa respuesta.
  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Map<String, dynamic>? body,
  }) async {

    /// JWT actual del usuario autenticado.
    ///
    /// Este token es enviado automáticamente
    /// al backend mediante Authorization Bearer.
    final token =
        Supabase.instance.client.auth.currentSession?.accessToken;

    /// Construcción de URL.
    ///
    /// Ejemplo:
    ///
    /// baseUrl:
    /// https://quipubox-api.vercel.app
    ///
    /// path:
    /// /sedes
    ///
    /// Resultado:
    /// https://quipubox-api.vercel.app/sedes
    final uri = Uri.parse(
      '${AppConfig.baseUrl}$path',
    ).replace(
      queryParameters: query,
    );

    /// Headers comunes para toda la aplicación.
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',

      /// Si existe sesión, agrega JWT.
      if (token != null && token.isNotEmpty)
        'Authorization': 'Bearer $token',
    };

    try {

      /// Convierte Map -> JSON.
      ///
      /// También elimina valores null.
      final encoded =
          body == null
              ? null
              : jsonEncode(
                  _withoutNulls(body),
                );

      /// Ejecuta la solicitud.
      final response = await _execute(
        method,
        uri,
        headers,
        encoded,
      ).timeout(_timeout);

      /// Procesa respuesta.
      return _parse(response);

    } on TimeoutException {

      /// Error por tiempo excedido.
      throw const AppException(
        'La solicitud tardó demasiado. Revisa tu conexión e intenta nuevamente.',
      );

    } on AppException {

      /// Si ya es AppException, se reenvía.
      rethrow;

    } on Object catch (error) {

      /// Error inesperado.
      throw AppException(
        'No se pudo conectar con el servidor. $error',
      );
    }
  }

  /// Ejecuta físicamente la petición HTTP.
  Future<http.Response> _execute(
    String method,
    Uri uri,
    Map<String, String> headers,
    String? body,
  ) {

    switch (method) {

      case 'GET':
        return _client.get(
          uri,
          headers: headers,
        );

      case 'POST':
        return _client.post(
          uri,
          headers: headers,
          body: body,
        );

      case 'PUT':
        return _client.put(
          uri,
          headers: headers,
          body: body,
        );

      case 'PATCH':
        return _client.patch(
          uri,
          headers: headers,
          body: body,
        );

      case 'DELETE':
        return _client.delete(
          uri,
          headers: headers,
        );

      default:
        throw AppException(
          'Método HTTP no soportado: $method',
        );
    }
  }

  /// Interpreta la respuesta del backend.
  dynamic _parse(http.Response response) {

    /// Body crudo.
    final raw = response.body.trim();

    /// JSON convertido a objeto Dart.
    final decoded =
        raw.isEmpty
            ? null
            : jsonDecode(raw);

    /// Respuesta exitosa.
    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return decoded;
    }

    /// Manejo de errores enviados por NestJS.
    ///
    /// Ejemplo:
    ///
    /// {
    ///   "message": "Usuario no encontrado"
    /// }
    if (decoded is Map<String, dynamic>) {

      final message = decoded['message'];

      /// Errores de validación.
      ///
      /// {
      ///   "message": [
      ///      "nombre no puede estar vacío",
      ///      "email inválido"
      ///   ]
      /// }
      if (message is List) {
        throw AppException(
          message.join('\n'),
          statusCode: response.statusCode,
        );
      }

      throw AppException(
        message?.toString() ??
            'Error del servidor.',
        statusCode: response.statusCode,
      );
    }

    /// Error genérico.
    throw AppException(
      'Error HTTP ${response.statusCode}.',
      statusCode: response.statusCode,
    );
  }

  /// Elimina propiedades null antes de enviar JSON.
  ///
  /// Ejemplo:
  ///
  /// {
  ///   nombre: "Cañete",
  ///   direccion: null
  /// }
  ///
  /// Resultado:
  ///
  /// {
  ///   nombre: "Cañete"
  /// }
  Map<String, dynamic> _withoutNulls(
    Map<String, dynamic> input,
  ) {
    final output = <String, dynamic>{};

    input.forEach((key, value) {
      if (value != null) {
        output[key] = value;
      }
    });

    return output;
  }
}