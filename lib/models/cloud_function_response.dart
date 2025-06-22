import 'package:office_lounge/main.dart';

class CloudFunctionResponse<T> {
  final bool success;
  final T? data;
  final String? error;

  CloudFunctionResponse({required this.success, this.data, this.error});

  factory CloudFunctionResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJson,
  ) {
    return CloudFunctionResponse<T>(
      success: json['success'] ?? false,
      data: json['data'] != null ? fromJson(json['data']) : null,
      error: json['error'],
    );
  }

  static CloudFunctionResponse<List<T>> fromJsonList<T>(
    Map<String, dynamic> json,
    T Function(dynamic) fromJson,
  ) {
    List<T>? dataList;
    if (json['data'] != null && json['data'] is List) {
      dataList = (json['data'] as List).map((item) => fromJson(item)).toList();
    }

    return CloudFunctionResponse<List<T>>(
      success: json['success'] ?? false,
      data: dataList,
      error: json['error'],
    );
  }

  bool get isSuccess => success && data != null;
  bool get hasError => !success || error != null;
}
