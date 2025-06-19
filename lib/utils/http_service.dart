import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class HttpService {
  static final HttpService _instance = HttpService._internal();
  factory HttpService() => _instance;
  HttpService._internal();

  late Dio _dio;
  final Logger _logger = Logger();
  String? _baseUrl;

  /// Dio 인스턴스 초기화
  void initialize({String? baseUrl}) {
    _baseUrl = baseUrl;

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? '',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 요청 인터셉터
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.i('🌐 HTTP Request: ${options.method} ${options.path}');
          _logger.i('📤 Params: ${options.queryParameters}');
          _logger.i('📤 Data: ${options.data}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          final duration =
              response.requestOptions.extra['startTime'] != null
                  ? DateTime.now().difference(
                    response.requestOptions.extra['startTime'],
                  )
                  : Duration.zero;

          _logger.i(
            '✅ HTTP Response: ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}',
          );
          _logger.i('📥 Data: ${response.data}');
          _logger.i('⏱️ Duration: ${duration.inMilliseconds}ms');

          handler.next(response);
        },
        onError: (error, handler) {
          final duration =
              error.requestOptions.extra['startTime'] != null
                  ? DateTime.now().difference(
                    error.requestOptions.extra['startTime'],
                  )
                  : Duration.zero;

          _logger.e(
            '❌ HTTP Error: ${error.response?.statusCode} ${error.requestOptions.method} ${error.requestOptions.path}',
          );
          _logger.e('📥 Error Data: ${error.response?.data}');
          _logger.e('⏱️ Duration: ${duration.inMilliseconds}ms');

          handler.next(error);
        },
      ),
    );
  }

  /// baseUrl 설정
  void setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
    _dio.options.baseUrl = baseUrl;
  }

  /// GET 요청
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final startTime = DateTime.now();
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options:
          options?.copyWith(extra: {'startTime': startTime}) ??
          Options(extra: {'startTime': startTime}),
    );
  }

  /// POST 요청
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final startTime = DateTime.now();
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options:
          options?.copyWith(extra: {'startTime': startTime}) ??
          Options(extra: {'startTime': startTime}),
    );
  }

  /// PUT 요청
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final startTime = DateTime.now();
    return await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options:
          options?.copyWith(extra: {'startTime': startTime}) ??
          Options(extra: {'startTime': startTime}),
    );
  }

  /// DELETE 요청
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final startTime = DateTime.now();
    return await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options:
          options?.copyWith(extra: {'startTime': startTime}) ??
          Options(extra: {'startTime': startTime}),
    );
  }

  /// Cloud Functions 호출을 위한 공통 메서드
  Future<Map<String, dynamic>> callCloudFunction(
    String functionName, {
    Map<String, dynamic>? data,
    String method = 'POST',
  }) async {
    try {
      final path = '/$functionName';
      Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await get(path, queryParameters: data);
          break;
        case 'PUT':
          response = await put(path, data: data);
          break;
        case 'DELETE':
          response = await delete(path, data: data);
          break;
        default:
          response = await post(path, data: data);
      }

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'error': 'HTTP ${response.statusCode}',
          'data': response.data,
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      _logger.e('Cloud Function 호출 실패: $functionName - $e');
      return {'success': false, 'error': e.toString(), 'statusCode': null};
    }
  }
}
