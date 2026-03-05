import 'dart:convert';

import 'package:catalog_app/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse(
      '${AppConstants.baseUrl}$path',
    ).replace(queryParameters: query);

    final response = await _client.get(uri);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }

    throw ApiException('Request failed (${response.statusCode}) for $path');
  }
}

class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
