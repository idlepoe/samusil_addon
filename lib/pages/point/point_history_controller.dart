import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:office_lounge/define/define.dart';

import '../../models/point_history.dart';
import '../../controllers/profile_controller.dart';
import '../../components/appSnackbar.dart';

class PointHistoryController extends GetxController {
  final logger = Logger();

  final RxList<PointHistory> pointHistory = <PointHistory>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasMore = true.obs;

  DocumentSnapshot? lastDocument;
  final int pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    loadPointHistory();
  }

  /// 포인트 히스토리 로드
  Future<void> loadPointHistory({bool isRefresh = false}) async {
    if (isRefresh) {
      pointHistory.clear();
      lastDocument = null;
      hasMore.value = true;
    }

    if (!hasMore.value) return;

    try {
      isLoading.value = true;

      final uid = ProfileController.to.uid;
      if (uid.isEmpty) {
        logger.w('사용자 UID가 없습니다.');
        return;
      }

      Query query = FirebaseFirestore.instance
          .collection(Define.FIRESTORE_COLLECTION_PROFILE)
          .doc(uid)
          .collection('point_history')
          .orderBy('created_at', descending: true)
          .limit(pageSize);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        hasMore.value = false;
        return;
      }

      final newPointHistory =
          snapshot.docs
              .map(
                (doc) => PointHistory.fromJson({
                  'id': doc.id,
                  ...doc.data() as Map<String, dynamic>,
                }),
              )
              .toList();

      pointHistory.addAll(newPointHistory);
      lastDocument = snapshot.docs.last;

      if (snapshot.docs.length < pageSize) {
        hasMore.value = false;
      }
    } catch (e) {
      logger.e('포인트 히스토리 로드 오류: $e');
      AppSnackbar.error('포인트 내역을 불러오는 중 오류가 발생했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  /// 새로고침
  Future<void> onRefresh() async {
    await loadPointHistory(isRefresh: true);
  }

  /// 더 불러오기
  Future<void> loadMore() async {
    if (!isLoading.value && hasMore.value) {
      await loadPointHistory();
    }
  }

  /// 포인트 타입별 아이콘 및 색상 반환
  Map<String, dynamic> getPointTypeInfo(String type) {
    switch (type) {
      case '게시글 작성':
        return {'icon': 'edit', 'color': 0xFF4DABF7, 'isPositive': true};
      case '댓글 작성':
        return {'icon': 'comment', 'color': 0xFF51CF66, 'isPositive': true};
      case '좋아요 받음':
        return {'icon': 'favorite', 'color': 0xFFFF6B6B, 'isPositive': true};
      case '좋아요':
        return {'icon': 'thumb_up', 'color': 0xFFFF8CC8, 'isPositive': true};
      case '소원 작성':
        return {'icon': 'star', 'color': 0xFFFFD93D, 'isPositive': true};
      case '코인 경마 우승':
        return {'icon': 'trophy', 'color': 0xFFFFB84D, 'isPositive': true};
      case '코인 경마 베팅':
        return {
          'icon': 'sports_soccer',
          'color': 0xFFFF5722,
          'isPositive': false,
        };
      case '출석 보너스':
        return {'icon': 'calendar', 'color': 0xFF9775FA, 'isPositive': true};
      case '낚시 참여비':
        return {'icon': 'fishing', 'color': 0xFFE91E63, 'isPositive': false};
      case '물고기 판매':
        return {
          'icon': 'monetization_on',
          'color': 0xFF00BCD4,
          'isPositive': true,
        };
      default:
        return {'icon': 'point', 'color': 0xFF9C9C9C, 'isPositive': true};
    }
  }

  /// 총 포인트 계산
  double get totalPoints {
    return pointHistory.fold(
      0.0,
      (sum, item) => sum + item.points_earned.toDouble(),
    );
  }

  /// 이번 달 포인트 계산
  double get thisMonthPoints {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month, 1);

    return pointHistory
        .where((item) => item.created_at.isAfter(thisMonth))
        .fold(0.0, (sum, item) => sum + item.points_earned.toDouble());
  }
}
