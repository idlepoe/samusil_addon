import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
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
          logger.i("🚀 [REQUEST] ${options.method} ${options.uri}");
          if (options.data != null) logger.d("Data: ${options.data}");

          try {
            final user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              final idToken = await user.getIdToken(true);

              if (idToken != null && idToken.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $idToken';
              } else {
                logger.w("⚠️ Firebase ID Token is empty");
              }

              handler.next(options); // 유저 + 토큰 정상 → 계속 진행
            } else {
              logger.w("❌ 로그인 안 된 사용자 요청 차단");
              _redirectToLogin();
              handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'User not authenticated',
                  type: DioExceptionType.cancel,
                ),
              );
            }
          } catch (e) {
            logger.e("❌ Firebase 인증 처리 중 오류: $e");
            _redirectToLogin();
            handler.reject(
              DioException(
                requestOptions: options,
                error: 'Firebase auth token error',
                type: DioExceptionType.cancel,
              ),
            );
          }
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

  /// 로그인 페이지로 리다이렉트
  void _redirectToLogin() {
    // Firebase Auth의 익명 로그인을 시도하거나 로그인 페이지로 이동
    try {
      FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      logger.e('Anonymous sign in failed: $e');
    }
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

    // logger.d(
    //   "getArticleList response: $response\n"
    //   "getArticleList response.isSuccess: ${response.isSuccess}\n"
    //   "getArticleList response.data: ${response.data}",
    // );

    return response;
  }

  /// 게시글 상세 조회
  Future<CloudFunctionResponse> getArticle({required String id}) async {
    try {
      final response = await _dio.get(
        '/getArticleDetail',
        queryParameters: {'key': id},
      );
      return CloudFunctionResponse(success: true, data: response.data);
    } catch (e) {
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  /// 게시글 작성
  Future<CloudFunctionResponse<Map<String, dynamic>>> createArticle({
    required Map<String, dynamic> articleData,
  }) async {
    final response = await callCloudFunction(
      'createArticle',
      data: {'articleData': articleData},
    );
    return CloudFunctionResponse<Map<String, dynamic>>(
      success: response['success'] ?? false,
      data: response['data'] as Map<String, dynamic>?,
      error: response['error'],
    );
  }

  /// 게시글 수정
  Future<CloudFunctionResponse<Map<String, dynamic>>> updateArticle({
    required Map<String, dynamic> articleData,
  }) async {
    final response = await callCloudFunction(
      'updateArticle',
      data: {'articleData': articleData},
    );
    return CloudFunctionResponse<Map<String, dynamic>>(
      success: response['success'] ?? false,
      data: response['data'] as Map<String, dynamic>?,
      error: response['error'],
    );
  }

  /// 댓글 작성
  Future<CloudFunctionResponse> createComment({
    required String articleId,
    required Map<String, dynamic> commentData,
  }) async {
    try {
      final response = await _dio.post(
        '/createComment',
        data: {'articleId': articleId, 'commentData': commentData},
      );
      return CloudFunctionResponse(success: true, data: response.data);
    } catch (e) {
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  /// 소원 생성
  Future<CloudFunctionResponse> createWish({required String comment}) async {
    try {
      final response = await _dio.post(
        '/createWish',
        data: {'comment': comment},
      );
      return CloudFunctionResponse(success: true, data: response.data);
    } catch (e) {
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  /// 소원 목록 조회
  Future<CloudFunctionResponse> getWish() async {
    try {
      final response = await _dio.get('/getWish');
      return CloudFunctionResponse(success: true, data: response.data);
    } catch (e) {
      return CloudFunctionResponse(success: false, error: e.toString());
    }
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
  Future<CloudFunctionResponse> deleteArticle({required String id}) async {
    try {
      final response = await _dio.post('/deleteArticle', data: {'id': id});
      return CloudFunctionResponse(success: true, data: response.data);
    } catch (e) {
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  /// 댓글 삭제
  Future<CloudFunctionResponse> deleteComment({
    required String articleId,
    required String commentId,
  }) async {
    try {
      final response = await _dio.post(
        '/deleteComment',
        data: {'articleId': articleId, 'commentId': commentId},
      );
      return CloudFunctionResponse(success: true, data: response.data);
    } catch (e) {
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }
}
