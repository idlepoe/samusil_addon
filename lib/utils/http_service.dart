import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:html_unescape/html_unescape.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:office_lounge/main.dart';
import '../models/cloud_function_response.dart';
import '../models/youtube/track.dart';
import '../utils/util.dart';

class HttpService {
  static final HttpService _instance = HttpService._internal();
  factory HttpService() => _instance;
  HttpService._internal();

  late Dio _dio;

  /// Dio 인스턴스 초기화
  void initialize({String? baseUrl}) {
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
          // logger.i("🚀 [REQUEST] ${options.method} ${options.uri}");
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

  // ===== Cloud Function 전용 메서드들 =====

  /// 게시글 목록 조회
  Future<CloudFunctionResponse<List<Map<String, dynamic>>>> getArticleList({
    required Map<String, dynamic> params,
  }) async {
    final response = await callCloudFunction(
      'getArticleList',
      data: params,
      method: 'GET',
    );

    List<Map<String, dynamic>>? dataList;
    if (response['data'] != null && response['data'] is List) {
      dataList =
          (response['data'] as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();
    }

    return CloudFunctionResponse<List<Map<String, dynamic>>>(
      success: response['success'] ?? false,
      data: dataList,
      error: response['error'],
    );
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
      data: articleData,
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

  // ===== YouTube 관련 기능 =====

  /// YouTube 검색
  static Future<List<Track>> youtubeSearch({required String search}) async {
    try {
      if (search.trim().isEmpty) {
        throw Exception('검색어를 입력해주세요.');
      }

      final response = await Dio().get(
        'https://www.googleapis.com/youtube/v3/search',
        queryParameters: {
          "q": search,
          "part": "snippet",
          "maxResults": "50",
          "key": "AIzaSyBOQ5nPMt4OmIF788zYHbhPz3gL7EnjNRk",
          "order": "relevance",
        },
      );

      final List<Track> results = [];

      for (final item in response.data["items"]) {
        final videoId = item["id"]?["videoId"];
        final snippet = item["snippet"];

        if (videoId != null && snippet != null) {
          results.add(
            Track(
              id: videoId,
              videoId: videoId,
              title:
                  snippet["title"] == null
                      ? ""
                      : HtmlUnescape().convert(snippet["title"]),
              description:
                  snippet["description"] == null
                      ? ""
                      : HtmlUnescape().convert(snippet["description"]),
              thumbnail: snippet["thumbnails"]?["medium"]?["url"] ?? '',
              duration: 0, // ▶️ 추후 getYoutubeLength로 갱신
            ),
          );
        }
      }

      return results;
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;

        logger.e('Status Code: $statusCode');
        logger.e('Response Data: $data');

        String message = '알 수 없는 오류가 발생했습니다.';

        final errorReason = data?['error']?['errors']?[0]?['reason'];
        if (errorReason == 'quotaExceeded') {
          message = 'YouTube API 사용 한도를 초과했습니다.\n잠시 후 다시 시도해주세요.';
        } else if (data?['error']?['message'] != null) {
          message = data['error']['message'];
        }

        Get.snackbar('오류', message);
      } else {
        Get.snackbar('오류', '네트워크 오류 또는 서버에 연결할 수 없습니다.');
      }
    } catch (e) {
      logger.e(e);
      Get.snackbar('오류', e.toString());
    }

    return [];
  }

  /// YouTube 영상 길이 가져오기
  static Future<int?> getYoutubeLength({required String videoId}) async {
    try {
      final response = await Dio().get(
        'https://youtube.googleapis.com/youtube/v3/videos',
        queryParameters: {
          "part": "contentDetails",
          "id": videoId,
          "fields": "items(contentDetails(duration))",
          "key": "AIzaSyBOQ5nPMt4OmIF788zYHbhPz3gL7EnjNRk",
        },
      );

      final items = response.data['items'] as List?;
      if (items != null && items.isNotEmpty) {
        final isoDuration = items[0]['contentDetails']['duration'];
        return Utils.convertTime(isoDuration); // ISO 8601 → 초 단위
      }
      return null;
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  // ===== YouTube 즐겨찾기 관련 기능 =====

  static const _key = 'favorite_youtube_ids';

  /// 즐겨찾기 목록 불러오기
  static Future<Set<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key)?.toSet() ?? {};
  }

  /// 즐겨찾기 목록 저장하기
  static Future<void> saveFavorites(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids.toList());
  }

  // ===== TrackArticle 관련 기능 =====

  /// 플레이리스트 생성
  Future<CloudFunctionResponse> createTrackArticle({
    required String title,
    required List<Track> tracks,
    String? description,
  }) async {
    try {
      final response = await _dio.post(
        '/createTrackArticle',
        data: {
          'title': title,
          'tracks': tracks.map((track) => track.toJson()).toList(),
          'description': description ?? '',
        },
      );

      // onRequest 방식의 응답 구조에 맞게 처리
      if (response.data['success'] == true) {
        return CloudFunctionResponse(
          success: true,
          data: response.data['data'],
        );
      } else {
        return CloudFunctionResponse(
          success: false,
          error: response.data['error'] ?? response.data['message'],
        );
      }
    } catch (e) {
      logger.e('createTrackArticle error: $e');
      if (e is DioException && e.response != null) {
        final errorData = e.response!.data;
        return CloudFunctionResponse(
          success: false,
          error:
              errorData['error'] ??
              errorData['message'] ??
              '플레이리스트 생성에 실패했습니다.',
        );
      }
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  /// 플레이리스트 목록 조회
  Future<CloudFunctionResponse> getTrackArticleList({
    String? lastDocumentId,
    int limit = 20,
    String orderBy = 'created_at',
    String orderDirection = 'desc',
  }) async {
    try {
      final response = await _dio.post(
        '/getTrackArticleList',
        data: {
          'lastDocumentId': lastDocumentId,
          'limit': limit,
          'orderBy': orderBy,
          'orderDirection': orderDirection,
        },
      );

      if (response.data['success'] == true) {
        return CloudFunctionResponse(
          success: true,
          data: response.data['data'],
        );
      } else {
        return CloudFunctionResponse(
          success: false,
          error: response.data['error'] ?? response.data['message'],
        );
      }
    } catch (e) {
      logger.e('getTrackArticleList error: $e');
      if (e is DioException && e.response != null) {
        final errorData = e.response!.data;
        return CloudFunctionResponse(
          success: false,
          error:
              errorData['error'] ??
              errorData['message'] ??
              '플레이리스트 목록 조회에 실패했습니다.',
        );
      }
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  /// 플레이리스트 상세 조회
  Future<CloudFunctionResponse> getTrackArticleDetail({
    required String id,
    bool incrementView = true,
  }) async {
    try {
      final response = await _dio.post(
        '/getTrackArticleDetail',
        data: {'id': id, 'incrementView': incrementView},
      );

      if (response.data['success'] == true) {
        return CloudFunctionResponse(
          success: true,
          data: response.data['data'],
        );
      } else {
        return CloudFunctionResponse(
          success: false,
          error: response.data['error'] ?? response.data['message'],
        );
      }
    } catch (e) {
      logger.e('getTrackArticleDetail error: $e');
      if (e is DioException && e.response != null) {
        final errorData = e.response!.data;
        return CloudFunctionResponse(
          success: false,
          error:
              errorData['error'] ??
              errorData['message'] ??
              '플레이리스트 조회에 실패했습니다.',
        );
      }
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  /// 플레이리스트 수정
  Future<CloudFunctionResponse> updateTrackArticle({
    required String id,
    String? title,
    List<Track>? tracks,
    String? description,
  }) async {
    try {
      final Map<String, dynamic> data = {'id': id};

      if (title != null) data['title'] = title;
      if (tracks != null)
        data['tracks'] = tracks.map((track) => track.toJson()).toList();
      if (description != null) data['description'] = description;

      final response = await _dio.post('/updateTrackArticle', data: data);

      if (response.data['success'] == true) {
        return CloudFunctionResponse(
          success: true,
          data: response.data['data'],
        );
      } else {
        return CloudFunctionResponse(
          success: false,
          error: response.data['error'] ?? response.data['message'],
        );
      }
    } catch (e) {
      logger.e('updateTrackArticle error: $e');
      if (e is DioException && e.response != null) {
        final errorData = e.response!.data;
        return CloudFunctionResponse(
          success: false,
          error:
              errorData['error'] ??
              errorData['message'] ??
              '플레이리스트 수정에 실패했습니다.',
        );
      }
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  /// 플레이리스트 삭제
  Future<CloudFunctionResponse> deleteTrackArticle({required String id}) async {
    try {
      final response = await _dio.post('/deleteTrackArticle', data: {'id': id});

      if (response.data['success'] == true) {
        return CloudFunctionResponse(
          success: true,
          data: response.data['data'],
        );
      } else {
        return CloudFunctionResponse(
          success: false,
          error: response.data['error'] ?? response.data['message'],
        );
      }
    } catch (e) {
      logger.e('deleteTrackArticle error: $e');
      if (e is DioException && e.response != null) {
        final errorData = e.response!.data;
        return CloudFunctionResponse(
          success: false,
          error:
              errorData['error'] ??
              errorData['message'] ??
              '플레이리스트 삭제에 실패했습니다.',
        );
      }
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  /// 게시글 좋아요 토글
  Future<CloudFunctionResponse> toggleLike({required String articleId}) async {
    try {
      final response = await _dio.post(
        '/toggleLike',
        data: {'articleId': articleId},
      );

      if (response.data['success'] == true) {
        return CloudFunctionResponse(
          success: true,
          data: response.data['data'],
        );
      } else {
        return CloudFunctionResponse(
          success: false,
          error: response.data['error'] ?? response.data['message'],
        );
      }
    } catch (e) {
      logger.e('toggleLike error: $e');
      if (e is DioException && e.response != null) {
        final errorData = e.response!.data;
        return CloudFunctionResponse(
          success: false,
          error:
              errorData['error'] ?? errorData['message'] ?? '좋아요 처리에 실패했습니다.',
        );
      }
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  /// 플레이리스트 좋아요 토글
  Future<CloudFunctionResponse> toggleTrackArticleLike({
    required String id,
  }) async {
    try {
      final response = await _dio.post(
        '/toggleTrackArticleLike',
        data: {'id': id},
      );

      if (response.data['success'] == true) {
        return CloudFunctionResponse(
          success: true,
          data: response.data['data'],
        );
      } else {
        return CloudFunctionResponse(
          success: false,
          error: response.data['error'] ?? response.data['message'],
        );
      }
    } catch (e) {
      logger.e('toggleTrackArticleLike error: $e');
      if (e is DioException && e.response != null) {
        final errorData = e.response!.data;
        return CloudFunctionResponse(
          success: false,
          error:
              errorData['error'] ?? errorData['message'] ?? '좋아요 처리에 실패했습니다.',
        );
      }
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }
}
