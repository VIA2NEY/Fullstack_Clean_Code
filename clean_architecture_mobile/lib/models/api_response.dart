class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;
  final String? token;
 
  ApiResponse({
    required this.code,
    required this.message,
    this.token,
     this.data,
  });
 
  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    if (json['data'] != null /*&& json['data']['content'] != null*/) {
      return ApiResponse<T>(
        code: json['code'],
        message: json['message'],
        token:  json['token'],
        data: fromJsonT(json['data']['content']),
      );
    } else {
      // Si 'data' ne contient pas 'content', c'est un objet simple
      return ApiResponse<T>(
        code: json['code'],
        message: json['message'],
        token:  json['token'],
        data: fromJsonT(json['data']['content']),
      );
    }
  }
}