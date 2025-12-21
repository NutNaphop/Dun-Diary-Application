import 'package:dun_diary_app/core/network/model/api_error_msg.dart';

class ServerException implements Exception {
  final ApiErrorResponse error;
  ServerException(this.error);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = "No Internet Connection"]);
}

class DataParsingException implements Exception {
  final String message;
  DataParsingException([this.message = "Data Parsing Error"]);
}