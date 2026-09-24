import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:logitrack/core/constants/app_constants.dart';
import 'package:logitrack/core/services/storage_service.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _uri(String path, [Map<String, String>? query]) {
    final base = Uri.parse('${AppConstants.apiBaseUrl}$path');
    return base.replace(queryParameters: query);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = false,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (authenticated && StorageService.accessToken != null) {
      headers['Authorization'] = 'Bearer ${StorageService.accessToken}';
    }
    final response = await _client.post(
      _uri(path),
      headers: headers,
      body: jsonEncode(body ?? <String, dynamic>{}),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? query,
    bool authenticated = true,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (authenticated && StorageService.accessToken != null) {
      headers['Authorization'] = 'Bearer ${StorageService.accessToken}';
    }
    final response = await _client.get(_uri(path, query), headers: headers);
    return _decode(response);
  }

  Map<String, dynamic> _decode(http.Response response) {
    Map<String, dynamic> payload;
    try {
      payload = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException(
        'The server returned an invalid response.',
        statusCode: response.statusCode,
      );
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = payload['error'];
      final message =
          error is Map<String, dynamic> ? error['message']?.toString() : null;
      throw ApiException(
        message ?? 'Request failed.',
        statusCode: response.statusCode,
      );
    }
    return payload;
  }
}
