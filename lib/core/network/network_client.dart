import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dun_diary_app/core/network/model/api_error_msg.dart';
import 'package:dun_diary_app/core/network/network_config.dart';
import 'package:http/http.dart' as http;
import '../error/network/exceptions.dart';

class NetworkClient {
  static const String _baseUrl = ClientConfig.BASE_URL;
  static const Duration _timeout = ClientConfig.TIMEOUT;

  // ==================== HTTP METHODS ====================
  /// GET
  Future<dynamic> get(String path, {Map<String, String>? headers}) async {
    return _safeApiCall(() async {
      return await http
          .get(Uri.parse('$_baseUrl$path'), headers: _mergeHeaders(headers))
          .timeout(_timeout);
    });
  }

  /// POST
  Future<dynamic> post(
    String path, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    return _safeApiCall(() async {
      return await http
          .post(
            Uri.parse('$_baseUrl$path'),
            headers: _mergeHeaders(headers),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeout);
    });
  }

  /// PUT
  Future<dynamic> put(
    String path, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    return _safeApiCall(() async {
      return await http
          .put(
            Uri.parse('$_baseUrl$path'),
            headers: _mergeHeaders(headers),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeout);
    });
  }

  /// DELETE
  Future<dynamic> delete(String path, {Map<String, String>? headers}) async {
    return _safeApiCall(() async {
      return await http
          .delete(Uri.parse('$_baseUrl$path'), headers: _mergeHeaders(headers))
          .timeout(_timeout);
    });
  }

  // ==================== INTERNAL HELPER ====================

  /// Header Merger
  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    // final defaultHeaders = ClientConfig.DEFAULT_HEADER;
    final Map<String, String> defaultHeaders= Map.from(ClientConfig.DEFAULT_HEADER);

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }
    return defaultHeaders;
  }

  Future<dynamic> _safeApiCall(Future<http.Response> Function() apiCall) async {
    try {
      final response = await apiCall();
      return _processResponse(response);
    } on SocketException {
      throw NetworkException();
    } on http.ClientException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException("Request Timeout");
    } catch (e) {
      print("Unknown Error in NetworkClient: $e");
      rethrow;
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      print("❌ API Error: ${response.request?.method} ${response.request?.url}");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return json.decode(response.body);
      } catch (e) {
        throw DataParsingException();
      }
    } else {
      try {
        final errorJson = json.decode(response.body);
        throw ServerException(ApiErrorResponse.fromJson(errorJson));
      } catch (_) {
        throw ServerException(
          ApiErrorResponse(
            code: 'ERR_${response.statusCode}',
            message: 'Server Error: ${response.statusCode}',
          ),
        );
      }
    }
  }
}
