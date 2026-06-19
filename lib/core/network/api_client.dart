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
/// - Refrescar la sesión de Supabase antes de cada request.
/// - Agregar automáticamente el JWT vigente.
/// - Ejecutar solicitudes HTTP.
/// - Parsear respuestas JSON.
/// - Convertir errores técnicos en AppException.
///
/// Todos los módulos consumen este cliente.
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Tiempo máximo permitido para una petición.
  static const _timeout = Duration(seconds: 20);

  /// GET /recurso
  Future<dynamic> get(String path, {Map<String, String>? query}) {
    return _send('GET', path, query: query);
  }

  /// POST /recurso
  Future<dynamic> post(String path, {Map<String, dynamic>? body}) {
    return _send('POST', path, body: body);
  }

  /// PUT /recurso/id
  Future<dynamic> put(String path, {Map<String, dynamic>? body}) {
    return _send('PUT', path, body: body);
  }

  /// PATCH /recurso/id
  Future<dynamic> patch(String path, {Map<String, dynamic>? body}) {
    return _send('PATCH', path, body: body);
  }

  /// DELETE /recurso/id
  Future<dynamic> delete(String path) {
    return _send('DELETE', path);
  }

  /// Obtiene un access token válido de Supabase.
  ///
  /// Supabase maneja:
  /// - access_token: token corto que se envía al backend.
  /// - refresh_token: token usado para renovar la sesión.
  ///
  /// currentSession solo lee la sesión actual. Si el access_token expiró,
  /// puede devolver un token viejo.
  ///
  /// Por eso, antes de llamar al backend, intentamos refrescar la sesión.
  /// Si el refresh falla, se devuelve el token actual como último intento.
  Future<String?> _getValidAccessToken() async {
    final supabase = Supabase.instance.client;
    final currentSession = supabase.auth.currentSession;

    if (currentSession == null) {
      return null;
    }

    try {
      final refreshed = await supabase.auth.refreshSession();
      return refreshed.session?.accessToken ?? currentSession.accessToken;
    } catch (_) {
      return currentSession.accessToken;
    }
  }

  /// Método interno que ejecuta todas las solicitudes.
  ///
  /// Flujo:
  /// 1. Obtiene un JWT vigente desde Supabase.
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
    try {
      final token = await _getValidAccessToken();

      final uri = Uri.parse(
        '${AppConfig.baseUrl}$path',
      ).replace(queryParameters: query);

      final headers = <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final encodedBody = body == null ? null : jsonEncode(_withoutNulls(body));

      final response = await _execute(
        method,
        uri,
        headers,
        encodedBody,
      ).timeout(_timeout);

      return _parse(response);
    } on TimeoutException {
      throw const AppException(
        'La solicitud tardó demasiado. Revisa tu conexión e intenta nuevamente.',
      );
    } on AppException {
      rethrow;
    } on Object catch (error) {
      throw AppException(
        //'No se pudo conectar con el servidor. Revisa tu conexión e intenta nuevamente.',
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
        return _client.get(uri, headers: headers);

      case 'POST':
        return _client.post(uri, headers: headers, body: body);

      case 'PUT':
        return _client.put(uri, headers: headers, body: body);

      case 'PATCH':
        return _client.patch(uri, headers: headers, body: body);

      case 'DELETE':
        return _client.delete(uri, headers: headers);

      default:
        throw AppException('Método HTTP no soportado: $method');
    }
  }

  /// Interpreta la respuesta del backend.
  dynamic _parse(http.Response response) {
    final raw = response.body.trim();

    final decoded = raw.isEmpty ? null : jsonDecode(raw);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    if (decoded is Map<String, dynamic>) {
      final message = decoded['message'];

      if (message is List) {
        throw AppException(message.join('\n'), statusCode: response.statusCode);
      }

      throw AppException(
        message?.toString() ?? 'Error del servidor.',
        statusCode: response.statusCode,
      );
    }

    throw AppException(
      'Error HTTP ${response.statusCode}.',
      statusCode: response.statusCode,
    );
  }

  /// Elimina propiedades null antes de enviar JSON.
  ///
  /// Ejemplo:
  /// Entrada:
  /// {
  ///   "nombre": "Cañete",
  ///   "direccion": null
  /// }
  ///
  /// Salida:
  /// {
  ///   "nombre": "Cañete"
  /// }
  Map<String, dynamic> _withoutNulls(Map<String, dynamic> input) {
    final output = <String, dynamic>{};

    input.forEach((key, value) {
      if (value != null) {
        output[key] = value;
      }
    });

    return output;
  }
}
