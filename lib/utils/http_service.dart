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
import '../define/define.dart';

class HttpService {
  static final HttpService _instance = HttpService._internal();
  factory HttpService() => _instance;
  HttpService._internal();

  Dio? _dio;
  String _baseUrl = '';
  bool _isInitialized = false;

  /// Dio 인스턴스 초기화
  void initialize({String? baseUrl}) {
    if (_isInitialized) return;

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
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // logger.i("🚀 [REQUEST] ${options.method} ${options.uri}");
          // if (options.data != null) logger.d("Data: ${options.data}");

          // startTime이 이미 설정되어 있지 않으면 현재 시간으로 설정
          if (options.extra['startTime'] == null) {
            options.extra['startTime'] = DateTime.now();
          }

          try {
            final user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              final idToken = await user.getIdToken(true);

              if (idToken != null && idToken.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $idToken';
              } else {
                logger.w("⚠️ Firebase ID Token is empty");
              }
            } else {
              logger.w("⚠️ Firebase Auth user is null");
            }
          } catch (e) {
            logger.e("❌ Firebase Auth error: $e");
          }

          handler.next(options);
        },
        onResponse: (response, handler) async {
          final startTime =
              response.requestOptions.extra['startTime'] as DateTime?;
          final duration =
              startTime != null
                  ? DateTime.now().difference(startTime)
                  : Duration.zero;

          logger.i(
            '✅ HTTP Response:\n'
            '  statusCode: ${response.statusCode}\n'
            '  method: ${response.requestOptions.method}\n'
            '  url: ${response.requestOptions.uri.toString()}\n'
            '  duration: ${duration.inMilliseconds}ms',
          );

          handler.next(response);
        },
        onError: (error, handler) async {
          final startTime =
              error.requestOptions.extra['startTime'] as DateTime?;
          final duration =
              startTime != null
                  ? DateTime.now().difference(startTime)
                  : Duration.zero;

          logger.e(
            '❌ HTTP Error:\n'
            '  statusCode: ${error.response?.statusCode}\n'
            '  method: ${error.requestOptions.method}\n'
            '  url: ${error.requestOptions.uri.toString()}\n'
            '  path: ${error.requestOptions.path}\n'
            '  errorType: ${error.type}\n'
            '  errorMessage: ${error.message}\n'
            '  errorData: ${error.response?.data}\n'
            '  duration: ${duration.inMilliseconds}ms',
          );

          handler.next(error);
        },
      ),
    );

    _isInitialized = true;
  }

  /// Dio 인스턴스가 초기화되었는지 확인하고, 필요시 초기화
  Dio _getDio() {
    if (!_isInitialized || _dio == null) {
      initialize();
    }
    return _dio!;
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
    _getDio().options.baseUrl = baseUrl;
  }

  // ===== Cloud Function 전용 메서드들 =====

  /// 게시글 목록 조회
  Future<CloudFunctionResponse<List<Map<String, dynamic>>>> getArticleList({
    required Map<String, dynamic> params,
  }) async {
    try {
      _getDio().options.baseUrl =
          'https://getarticlelist-moqfvmeufa-uc.a.run.app';
      final response = await _getDio().get('', queryParameters: params);

      List<Map<String, dynamic>>? dataList;
      if (response.data['data'] != null && response.data['data'] is List) {
        dataList =
            (response.data['data'] as List)
                .map((item) => item as Map<String, dynamic>)
                .toList();
      }

      return CloudFunctionResponse<List<Map<String, dynamic>>>(
        success: response.data['success'] ?? false,
        data: dataList,
        error: response.data['error'],
      );
    } catch (e) {
      logger.e('getArticleList error: $e');
      return CloudFunctionResponse<List<Map<String, dynamic>>>(
        success: false,
        data: null,
        error: e.toString(),
      );
    }
  }

  /// 게시글 상세 조회
  Future<CloudFunctionResponse> getArticle({required String id}) async {
    try {
      _getDio().options.baseUrl =
          'https://getarticledetail-moqfvmeufa-uc.a.run.app';
      final response = await _getDio().get('', queryParameters: {'key': id});
      return CloudFunctionResponse(success: true, data: response.data);
    } catch (e) {
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  /// 게시글 작성
  Future<CloudFunctionResponse<Map<String, dynamic>>> createArticle({
    required Map<String, dynamic> articleData,
  }) async {
    try {
      _getDio().options.baseUrl =
          'https://createarticle-moqfvmeufa-uc.a.run.app';

      final response = await _getDio().post(
        '',
        data: {'articleData': articleData},
      );

      return CloudFunctionResponse<Map<String, dynamic>>(
        success: response.data['success'] ?? false,
        data: response.data['data'] as Map<String, dynamic>?,
        error: response.data['error'],
      );
    } catch (e) {
      logger.e('createArticle error: $e');
      return CloudFunctionResponse<Map<String, dynamic>>(
        success: false,
        data: null,
        error: e.toString(),
      );
    }
  }

  /// 게시글 수정
  Future<CloudFunctionResponse<Map<String, dynamic>>> updateArticle({
    required Map<String, dynamic> articleData,
  }) async {
    try {
      logger.i('🔧 updateArticle 호출 - PUT 메서드 사용');
      _getDio().options.baseUrl =
          'https://updatearticle-moqfvmeufa-du.a.run.app';

      final response = await _getDio().put('', data: articleData);

      return CloudFunctionResponse<Map<String, dynamic>>(
        success: response.data['success'] ?? false,
        data: response.data['data'] as Map<String, dynamic>?,
        error: response.data['error'],
      );
    } catch (e) {
      logger.e('updateArticle error: $e');
      return CloudFunctionResponse<Map<String, dynamic>>(
        success: false,
        data: null,
        error: e.toString(),
      );
    }
  }

  /// 댓글 작성
  Future<CloudFunctionResponse> createComment({
    required String articleId,
    required Map<String, dynamic> commentData,
  }) async {
    try {
      _getDio().options.baseUrl =
          'https://createcomment-moqfvmeufa-du.a.run.app';
      final response = await _getDio().post(
        '',
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
      _getDio().options.baseUrl = 'https://createwish-moqfvmeufa-uc.a.run.app';
      final response = await _getDio().post('', data: {'comment': comment});
      return CloudFunctionResponse(success: true, data: response.data);
    } catch (e) {
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  /// 소원 목록 조회
  Future<CloudFunctionResponse> getWish() async {
    try {
      _getDio().options.baseUrl = 'https://getwish-moqfvmeufa-uc.a.run.app';
      final response = await _getDio().get('');
      return CloudFunctionResponse(success: true, data: response.data);
    } catch (e) {
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  /// 게시글 삭제
  Future<CloudFunctionResponse> deleteArticle({required String id}) async {
    try {
      _getDio().options.baseUrl =
          'https://deletearticle-moqfvmeufa-du.a.run.app';
      final response = await _getDio().delete('', data: {'id': id});
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
      _getDio().options.baseUrl =
          'https://deletecomment-moqfvmeufa-du.a.run.app';
      final response = await _getDio().delete(
        '',
        data: {'articleId': articleId, 'commentId': commentId},
      );
      return CloudFunctionResponse(success: true, data: response.data);
    } catch (e) {
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  /// Cloud Functions: 아바타 구매
  Future<CloudFunctionResponse<void>> postCreateAvatarPurchase({
    required String avatarId,
    required String avatarUrl,
    required String avatarName,
    required int price,
  }) async {
    try {
      _getDio().options.baseUrl =
          'https://createavatarpurchase-moqfvmeufa-uc.a.run.app';
      final response = await _getDio().post(
        '',
        data: {
          'avatarId': avatarId,
          'avatarUrl': avatarUrl,
          'avatarName': avatarName,
          'price': price,
        },
      );
      return CloudFunctionResponse<void>(
        success: response.data['success'] ?? false,
        data: null,
        error: response.data['error'],
      );
    } catch (e) {
      return CloudFunctionResponse<void>(
        success: false,
        data: null,
        error: e.toString(),
      );
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
      final response = await _getDio().post(
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
      // 직접 올바른 URL 설정
      _getDio().options.baseUrl =
          'https://gettrackarticlelist-moqfvmeufa-du.a.run.app';

      final response = await _getDio().post(
        '',
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
      _getDio().options.baseUrl =
          'https://gettrackarticledetail-moqfvmeufa-du.a.run.app';
      final response = await _getDio().post(
        '',
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
      _getDio().options.baseUrl =
          'https://updatetrackarticle-moqfvmeufa-du.a.run.app';
      final Map<String, dynamic> data = {'id': id};

      if (title != null) data['title'] = title;
      if (tracks != null)
        data['tracks'] = tracks.map((track) => track.toJson()).toList();
      if (description != null) data['description'] = description;

      final response = await _getDio().post('', data: data);

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
      _getDio().options.baseUrl =
          'https://deletetrackarticle-moqfvmeufa-du.a.run.app';
      final response = await _getDio().post('', data: {'id': id});

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
      _getDio().options.baseUrl = 'https://togglelike-moqfvmeufa-du.a.run.app';
      final response = await _getDio().post('', data: {'articleId': articleId});

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
      _getDio().options.baseUrl =
          'https://toggletrackarticlelike-moqfvmeufa-du.a.run.app';
      final response = await _getDio().post('', data: {'id': id});

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

  // ===== 물고기 관련 기능 =====

  // ===== 포인트 관리 공통 기능 =====

  /// 포인트 증감 공통 처리 (point_history 기록 포함)
  Future<CloudFunctionResponse> updatePoints({
    required double pointsChange, // 양수: 증가, 음수: 감소
    required String
    actionType, // 'fishing_fee', 'fishing_reward', 'wish', 'article', etc.
    String? description, // 선택적 설명
    Map<String, dynamic>? metadata, // 추가 메타데이터
  }) async {
    try {
      _getDio().options.baseUrl =
          'https://updatepoints-moqfvmeufa-du.a.run.app';
      final response = await _getDio().post(
        '',
        data: {
          'pointsChange': pointsChange,
          'actionType': actionType,
          if (description != null) 'description': description,
          if (metadata != null) 'metadata': metadata,
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
      logger.e('updatePoints error: $e');
      if (e is DioException && e.response != null) {
        final errorData = e.response!.data;
        return CloudFunctionResponse(
          success: false,
          error:
              errorData['error'] ?? errorData['message'] ?? '포인트 업데이트에 실패했습니다.',
        );
      }
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  /// 낚시 게임 참여비 차감 (공통 포인트 API 사용)
  Future<CloudFunctionResponse> payFishingFee({required int feeAmount}) async {
    return await updatePoints(
      pointsChange: -feeAmount.toDouble(),
      actionType: '낚시 참여비',
      description: '낚시 게임 참여비',
      metadata: {'gameType': 'fishing', 'feeAmount': feeAmount},
    );
  }

  // ===== 칭호 관련 기능 =====

  /// 칭호 해금
  Future<CloudFunctionResponse> unlockTitle({
    required String titleId,
    required String titleName,
    String? description,
  }) async {
    try {
      _getDio().options.baseUrl = 'https://unlocktitle-moqfvmeufa-uc.a.run.app';
      final response = await _getDio().post(
        '',
        data: {
          'titleId': titleId,
          'titleName': titleName,
          if (description != null) 'description': description,
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
      logger.e('unlockTitle error: $e');
      if (e is DioException && e.response != null) {
        final errorData = e.response!.data;
        return CloudFunctionResponse(
          success: false,
          error: errorData['error'] ?? errorData['message'] ?? '칭호 해금에 실패했습니다.',
        );
      }
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  /// 대표 칭호 설정
  Future<CloudFunctionResponse> setSelectedTitle({
    String? titleId, // null이면 칭호 해제
  }) async {
    try {
      _getDio().options.baseUrl =
          'https://setselectedtitle-moqfvmeufa-uc.a.run.app';
      final response = await _getDio().post('', data: {'titleId': titleId});

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
      logger.e('setSelectedTitle error: $e');
      if (e is DioException && e.response != null) {
        final errorData = e.response!.data;
        return CloudFunctionResponse(
          success: false,
          error:
              errorData['error'] ?? errorData['message'] ?? '대표 칭호 설정에 실패했습니다.',
        );
      }
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  // ===== 아트워크 관련 기능 =====

  /// 아트워크 구입
  Future<CloudFunctionResponse> purchaseArtwork({
    required String artworkId,
  }) async {
    try {
      _getDio().options.baseUrl =
          'https://createartworkpurchase-moqfvmeufa-uc.a.run.app';
      final response = await _getDio().post('', data: {'artworkId': artworkId});

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
      logger.e('purchaseArtwork error: $e');
      if (e is DioException && e.response != null) {
        final errorData = e.response!.data;
        return CloudFunctionResponse(
          success: false,
          error:
              errorData['error'] ?? errorData['message'] ?? '아트워크 구입에 실패했습니다.',
        );
      }
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  /// 랜덤 아트워크 구입
  Future<CloudFunctionResponse> purchaseRandomArtwork() async {
    try {
      _getDio().options.baseUrl =
          'https://createrandomartworkpurchase-moqfvmeufa-uc.a.run.app';
      final response = await _getDio().post('');

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
      logger.e('purchaseRandomArtwork error: $e');
      if (e is DioException && e.response != null) {
        final errorData = e.response!.data;
        return CloudFunctionResponse(
          success: false,
          error:
              errorData['error'] ??
              errorData['message'] ??
              '랜덤 아트워크 구입에 실패했습니다.',
        );
      }
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }

  // ===== 경마 관련 기능 =====

  /// 경마 베팅
  Future<CloudFunctionResponse> placeBet({
    required String raceId,
    required String horseId,
    required String betType,
    required int amount,
  }) async {
    try {
      _getDio().options.baseUrl = 'https://placebet-moqfvmeufa-uc.a.run.app';
      final response = await _getDio().post(
        '',
        data: {
          'raceId': raceId,
          'horseId': horseId,
          'betType': betType,
          'amount': amount,
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
      logger.e('placeBet error: $e');
      if (e is DioException && e.response != null) {
        final errorData = e.response!.data;
        return CloudFunctionResponse(
          success: false,
          error: errorData['error'] ?? errorData['message'] ?? '베팅에 실패했습니다.',
        );
      }
      return CloudFunctionResponse(success: false, error: e.toString());
    }
  }
}
