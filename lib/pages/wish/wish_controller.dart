import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

      if (result.isNotEmpty) {
        // 성공 시 로컬 상태 업데이트
        await Utils.setAlreadyWish(Utils.getStringToday());
        alreadyWished.value = true;

        // 프로필 새로고침
        profile.value = await App.getProfile();

        // 입력 필드 초기화
        commentController.clear();
      }
    } catch (e) {
      logger.e("Error creating wish: $e");
    } finally {
      isPressed.value = false;
    }
  }

  bool get canCreateWish =>
      !alreadyWished.value &&
      commentController.text.isNotEmpty &&
      !isPressed.value;
}
