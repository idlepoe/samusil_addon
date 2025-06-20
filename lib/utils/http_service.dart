import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:samusil_addon/main.dart';
import '../models/cloud_function_response.dart';

class HttpService {
  static final HttpService _instance = HttpService._internal();
  factory HttpService() => _instance;
  HttpService._internal();

  late Dio _dio;
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
        onRequest: (options, handler) async {
          // Firebase Auth 토큰 추가
          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final token = await user.getIdToken();
              options.headers['Authorization'] = 'Bearer $token';
            }
          } catch (e) {
            logger.e('Failed to get auth token: $e');
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          final duration =
              response.requestOptions.extra['startTime'] != null
                  ? DateTime.now().difference(
                    response.requestOptions.extra['startTime'],
                  )
                  : Duration.zero;

          logger.i(
            '✅ HTTP Response:\n'
            '  statusCode: ${response.statusCode}\n'
            '  method: ${response.requestOptions.method}\n'
            '  url: ${response.requestOptions.uri.toString()}\n'
            '  path: ${response.requestOptions.path}\n'
            '  data: ${response.data}\n'
            '  duration: ${duration.inMilliseconds}ms',
          );

          handler.next(response);
        },
        onError: (error, handler) {
          final duration =
              error.requestOptions.extra['startTime'] != null
                  ? DateTime.now().difference(
                    error.requestOptions.extra['startTime'],
                  )
                  : Duration.zero;

          logger.e(
            '❌ HTTP Error:\n'
            '  statusCode: ${error.response?.statusCode}\n'
            '  method: ${error.requestOptions.method}\n'
            '  url: ${error.requestOptions.uri.toString()}\n'
            '  path: ${error.requestOptions.path}\n'
            '  errorData: ${error.response?.data}\n'
            '  duration: ${duration.inMilliseconds}ms',
          );

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

      // Firebase Functions는 이미 {success: true, data: ...} 형태로 응답하므로
      // response.data를 그대로 반환
      return response.data as Map<String, dynamic>;
    } catch (e) {
      logger.e('Cloud Function call failed: $e');
      return {'success': false, 'error': e.toString(), 'data': null};
    }
  }

  /// Cloud Functions 응답을 공통 모델로 변환 (단일 객체)
  Future<CloudFunctionResponse<T>> callCloudFunctionWithResponse<T>(
    String functionName, {
    Map<String, dynamic>? data,
    String method = 'POST',
    required T Function(dynamic) fromJson,
  }) async {
    final response = await callCloudFunction(
      functionName,
      data: data,
      method: method,
    );
    return CloudFunctionResponse.fromJson(response, fromJson);
  }

  /// Cloud Functions 응답을 공통 모델로 변환 (리스트)
  Future<CloudFunctionResponse<List<T>>> callCloudFunctionWithListResponse<T>(
    String functionName, {
    Map<String, dynamic>? data,
    String method = 'POST',
    required T Function(dynamic) fromJson,
  }) async {
    final response = await callCloudFunction(
      functionName,
      data: data,
      method: method,
    );
    return CloudFunctionResponse.fromJsonList(response, fromJson);
  }

  // ===== Cloud Function 전용 메서드들 =====

  /// 게시글 목록 조회
  Future<CloudFunctionResponse<List<Map<String, dynamic>>>> getArticleList({
    required Map<String, dynamic> params,
  }) async {
    final response =
        await callCloudFunctionWithListResponse<Map<String, dynamic>>(
          'getArticleList',
          data: params,
          method: 'GET',
          fromJson: (json) => json as Map<String, dynamic>,
        );

    logger.d(
      "getArticleList response: $response\n"
      "getArticleList response.isSuccess: ${response.isSuccess}\n"
      "getArticleList response.data: ${response.data}",
    );

    return response;
  }

  /// 게시글 상세 조회
  Future<CloudFunctionResponse<Map<String, dynamic>>> getArticle({
    required String key,
  }) async {
    return await callCloudFunctionWithResponse<Map<String, dynamic>>(
      'getArticle',
      data: {'key': key},
      method: 'GET',
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// 게시글 작성
  Future<CloudFunctionResponse<void>> createArticle({
    required Map<String, dynamic> articleData,
  }) async {
    final response = await callCloudFunction(
      'createArticle',
      data: articleData,
    );
    return CloudFunctionResponse<void>(
      success: response['success'] ?? false,
      data: null,
      error: response['error'],
    );
  }

  /// 댓글 작성
  Future<CloudFunctionResponse<List<Map<String, dynamic>>>> createComment({
    required String articleKey,
    required Map<String, dynamic> commentData,
  }) async {
    return await callCloudFunctionWithListResponse<Map<String, dynamic>>(
      'createComment',
      data: {'article_key': articleKey, 'comment': commentData},
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// 포인트 업데이트
  Future<CloudFunctionResponse<Map<String, dynamic>>> updatePoint({
    required String profileKey,
    required double point,
  }) async {
    return await callCloudFunctionWithResponse<Map<String, dynamic>>(
      'updatePoint',
      data: {'profile_key': profileKey, 'point': point},
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Wish 생성
  Future<CloudFunctionResponse<Map<String, dynamic>>> createWish({
    required String comment,
  }) async {
    return await callCloudFunctionWithResponse<Map<String, dynamic>>(
      'createWish',
      data: {'comment': comment},
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// 코인 목록 조회
  Future<CloudFunctionResponse<List<Map<String, dynamic>>>> getCoinList({
    Map<String, dynamic>? params,
  }) async {
    return await callCloudFunctionWithListResponse<Map<String, dynamic>>(
      'getCoinList',
      data: params,
      method: 'GET',
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// 코인 구매
  Future<CloudFunctionResponse<Map<String, dynamic>>> buyCoin({
    required String profileKey,
    required Map<String, dynamic> coinBalanceData,
  }) async {
    return await callCloudFunctionWithResponse<Map<String, dynamic>>(
      'buyCoin',
      data: {'profile_key': profileKey, 'coin_balance': coinBalanceData},
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// 코인 판매
  Future<CloudFunctionResponse<Map<String, dynamic>>> sellCoin({
    required String profileKey,
    required Map<String, dynamic> coinBalanceData,
    required double currentPrice,
  }) async {
    return await callCloudFunctionWithResponse<Map<String, dynamic>>(
      'sellCoin',
      data: {
        'profile_key': profileKey,
        'coin_balance': coinBalanceData,
        'current_price': currentPrice,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// 게시글 삭제
  Future<CloudFunctionResponse<void>> deleteArticle({
    required String key,
  }) async {
    final response = await callCloudFunction(
      'deleteArticle',
      data: {'key': key},
      method: 'DELETE',
    );
    return CloudFunctionResponse<void>(
      success: response['success'] ?? false,
      data: null,
      error: response['error'],
    );
  }

  /// 댓글 삭제
  Future<CloudFunctionResponse<List<Map<String, dynamic>>>> deleteComment({
    required String articleKey,
    required String commentKey,
  }) async {
    return await callCloudFunctionWithListResponse<Map<String, dynamic>>(
      'deleteComment',
      data: {'article_key': articleKey, 'comment_key': commentKey},
      method: 'DELETE',
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }
}
