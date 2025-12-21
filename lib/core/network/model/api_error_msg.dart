class ApiErrorResponse {
  final String code;
  final String message;

  ApiErrorResponse({required this.code, required this.message});

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      code: json['code'] ?? 'UNKNOWN',
      message: json['message'] ?? 'SUPER UNKNOWN ERROR',
    );
  }
}