import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../define/define.dart';
import '../../models/profile.dart';
import '../../models/wish.dart';
import '../../utils/app.dart';
import '../../utils/util.dart';

class WishController extends GetxController {
  var logger = Logger();

  // 상태 변수들
  final profile = Profile.init().obs;
  final wishList = <Wish>[].obs;
  final alreadyWished = true.obs;
  final isPressed = false.obs;
  final isLoading = false.obs;

  // 텍스트 컨트롤러
  final TextEditingController commentController = TextEditingController();

  // Wish 스트림 구독을 위한 변수
  StreamSubscription<QuerySnapshot>? _wishStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    init();
    _initWishStream();
  }

  @override
  void onClose() {
    _wishStreamSubscription?.cancel();
    commentController.dispose();
    super.onClose();
  }

  // Wish 스트림 초기화
  void _initWishStream() {
    try {
      final collectionRef = FirebaseFirestore.instance.collection(
        Define.FIRESTORE_COLLECTION_WISH,
      );

      _wishStreamSubscription = collectionRef
          .orderBy('created_at', descending: true)
          .snapshots()
          .listen(
            (QuerySnapshot snapshot) async {
              List<Wish> wishes = [];

              for (var doc in snapshot.docs) {
                try {
                  Wish wish = Wish.fromJson(doc.data() as Map<String, dynamic>);
                  wishes.add(wish);
                } catch (e) {
                  logger.e("Error parsing wish data: $e");
                }
              }

              wishList.value = wishes;
            },
            onError: (error) {
              logger.e("Wish stream error: $error");
            },
          );
    } catch (e) {
      logger.e("Error initializing wish stream: $e");
    }
  }

  Future<void> init() async {
    isLoading.value = true;

    try {
      await App.checkUser();
      profile.value = await App.getProfile();
      alreadyWished.value = await Utils.getAlreadyWish();
    } catch (e) {
      logger.e("Error in init: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    isLoading.value = true;

    try {
      profile.value = await App.getProfile();
      alreadyWished.value = await Utils.getAlreadyWish();
    } catch (e) {
      logger.e("Error in refresh: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createWish(String wish) async {
    if (wish.isEmpty || isPressed.value) {
      return;
    }

    isPressed.value = true;

    try {
      // Cloud Function을 통해 Wish 생성
      final result = await App.createWish(comment: wish);

      if (result.isNotEmpty && result['success'] == true) {
        // 성공 시 로컬 상태 업데이트
        await Utils.setAlreadyWish(Utils.getStringToday());
        alreadyWished.value = true;

        // Cloud Function 응답에서 프로필 업데이트
        if (result['data'] != null && result['data']['profile'] != null) {
          profile.value = Profile.fromJson(result['data']['profile']);
        } else {
          // 프로필 새로고침
          profile.value = await App.getProfile();
        }

        // Cloud Function 응답에서 wishList 업데이트
        if (result['data'] != null && result['data']['wishList'] != null) {
          List<Wish> newWishList = [];
          List<dynamic> wishDataList = result['data']['wishList'];

          for (var wishData in wishDataList) {
            try {
              // Cloud Functions 응답 구조를 클라이언트 모델에 맞게 변환
              Map<String, dynamic> convertedWishData = {
                'index': wishData['index'] ?? 1,
                'uid': wishData['profile_uid'] ?? '',
                'comments': wishData['comment'] ?? '',
                'nick_name': wishData['profile_name'] ?? '',
                'streak': wishData['streak'] ?? 1,
                'created_at':
                    wishData['created_at'] != null
                        ? _formatTimestamp(wishData['created_at'])
                        : DateFormat("yyyy-MM-dd").format(DateTime.now()),
              };

              Wish wish = Wish.fromJson(convertedWishData);
              newWishList.add(wish);
            } catch (e) {
              logger.e("Error converting wish data: $e");
            }
          }

          wishList.value = newWishList;
        }

        // 입력 필드 초기화
        commentController.clear();

        // 성공 메시지 표시
        Get.snackbar(
          '성공',
          '소원이 생성되었습니다! +${result['data']?['pointsEarned'] ?? 0}포인트',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // 에러 메시지 표시
        String errorMessage = result['error'] ?? '소원 생성에 실패했습니다.';
        Get.snackbar(
          '오류',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      logger.e("Error creating wish: $e");
      Get.snackbar(
        '오류',
        '소원 생성 중 오류가 발생했습니다.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isPressed.value = false;
    }
  }

  bool get canCreateWish =>
      !alreadyWished.value &&
      commentController.text.isNotEmpty &&
      !isPressed.value;

  // Firestore Timestamp를 문자열로 변환하는 헬퍼 메서드
  String _formatTimestamp(dynamic timestamp) {
    try {
      if (timestamp is Map<String, dynamic> && timestamp['_seconds'] != null) {
        // Firestore Timestamp 객체인 경우
        int seconds = timestamp['_seconds'];
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
        return DateFormat("yyyy-MM-dd").format(dateTime);
      } else if (timestamp is String) {
        // 이미 문자열인 경우
        return timestamp;
      } else {
        // 기타 경우 현재 날짜 반환
        return DateFormat("yyyy-MM-dd").format(DateTime.now());
      }
    } catch (e) {
      logger.e("Error formatting timestamp: $e");
      return DateFormat("yyyy-MM-dd").format(DateTime.now());
    }
  }
}
