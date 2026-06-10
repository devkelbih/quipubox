import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../exceptions/app_exception.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;
  static const _timeout = Duration(seconds: 20);

  Future<dynamic> get(String path, {Map<String, String>? query}) => _send('GET', path, query: query);
  Future<dynamic> post(String path, {Map<String, dynamic>? body}) => _send('POST', path, body: body);
  Future<dynamic> put(String path, {Map<String, dynamic>? body}) => _send('PUT', path, body: body);
  Future<dynamic> patch(String path, {Map<String, dynamic>? body}) => _send('PATCH', path, body: body);
  Future<dynamic> delete(String path) => _send('DELETE', path);

  Future<dynamic> _send(String method, String path, {Map<String, String>? query, Map<String, dynamic>? body}) async {
    final token = Supabase.instance.client.auth.currentSession?.accessToken;
    final uri = Uri.parse('${AppConfig.baseUrl}$path').replace(queryParameters: query);
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    try {
      final encoded = body == null ? null : jsonEncode(_withoutNulls(body));
      final response = await _execute(method, uri, headers, encoded).timeout(_timeout);
      return _parse(response);
    } on TimeoutException {
      throw const AppException('La solicitud tardó demasiado. Revisa tu conexión e intenta nuevamente.');
    } on AppException {
      rethrow;
    } on Object catch (error) {
      throw AppException('No se pudo conectar con el servidor. $error');
    }
  }

  Future<http.Response> _execute(String method, Uri uri, Map<String, String> headers, String? body) {
    switch (method) {
      case 'GET': return _client.get(uri, headers: headers);
      case 'POST': return _client.post(uri, headers: headers, body: body);
      case 'PUT': return _client.put(uri, headers: headers, body: body);
      case 'PATCH': return _client.patch(uri, headers: headers, body: body);
      case 'DELETE': return _client.delete(uri, headers: headers);
      default: throw AppException('Método HTTP no soportado: $method');
    }
  }

  dynamic _parse(http.Response response) {
    final raw = response.body.trim();
    final decoded = raw.isEmpty ? null : jsonDecode(raw);
    if (response.statusCode >= 200 && response.statusCode < 300) return decoded;

    if (decoded is Map<String, dynamic>) {
      final message = decoded['message'];
      if (message is List) throw AppException(message.join('\n'), statusCode: response.statusCode);
      throw AppException(message?.toString() ?? 'Error del servidor.', statusCode: response.statusCode);
    }
    throw AppException('Error HTTP ${response.statusCode}.', statusCode: response.statusCode);
  }

  Map<String, dynamic> _withoutNulls(Map<String, dynamic> input) {
    final output = <String, dynamic>{};
    input.forEach((key, value) { if (value != null) output[key] = value; });
    return output;
  }
}
