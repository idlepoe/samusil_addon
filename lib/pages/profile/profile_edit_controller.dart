import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../controllers/profile_controller.dart';
import '../../components/profile_avatar_widget.dart';
import '../../components/appSnackbar.dart';
import '../../models/profile.dart';
import '../../utils/http_service.dart';
import '../../utils/app.dart';

class ProfileEditController extends GetxController {
  final logger = Logger();

  // 텍스트 컨트롤러
  final TextEditingController nameController = TextEditingController();
  final TextEditingController oneCommentController = TextEditingController();

  // 상태 관리
  final RxBool isLoading = false.obs;
  final RxString selectedAvatarUrl = ''.obs;
  final RxBool isNameChanged = false.obs;
  final RxBool isAvatarChanged = false.obs;
  final RxBool isCommentChanged = false.obs;

  // 아바타 구매 관련
  final RxList<AvatarItem> availableAvatars = <AvatarItem>[].obs;
  final RxList<AvatarItem> purchasedAvatars = <AvatarItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    _loadAvatars();
  }

  @override
  void onClose() {
    nameController.dispose();
    oneCommentController.dispose();
    super.onClose();
  }

  /// 초기 데이터 설정
  void _initializeData() {
    final profile = ProfileController.to.profile.value;

    nameController.text = profile.name;
    oneCommentController.text = profile.one_comment;
    selectedAvatarUrl.value = profile.photo_url;

    // 텍스트 변경 감지
    nameController.addListener(() {
      isNameChanged.value = nameController.text != profile.name;
    });

    oneCommentController.addListener(() {
      isCommentChanged.value = oneCommentController.text != profile.one_comment;
    });
  }

  /// 아바타 목록 로드
  void _loadAvatars() async {
    // 기본 아바타 (무료)
    final defaultAvatar = AvatarItem(
      id: 'default',
      name: '기본',
      imageUrl: '',
      price: 0,
      isPurchased: true,
      category: '기본',
    );

    availableAvatars.add(defaultAvatar);
    purchasedAvatars.add(defaultAvatar); // 기본 아바타는 항상 구매한 것으로 처리

    // 프리미엄 아바타 (유료)
    final premiumAvatars = [
      // 동물 테마
      AvatarItem(
        id: 'cat',
        name: '고양이',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/samusil-addon.firebasestorage.app/o/avatars%2Fcat.jpg?alt=media&token=6c3b07e4-e9ce-4836-800e-9ee3f48c128a',
        price: 100,
        category: '동물',
      ),
      AvatarItem(
        id: 'dog',
        name: '강아지',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/samusil-addon.firebasestorage.app/o/avatars%2Fdog.jpg?alt=media&token=1dbb885d-4043-424a-a4c2-60ca23562d54',
        price: 100,
        category: '동물',
      ),
      AvatarItem(
        id: 'rabbit',
        name: '토끼',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/samusil-addon.firebasestorage.app/o/avatars%2Frabbit.jpg?alt=media&token=8fb31772-001e-4cfb-90f2-4b55d0ee35eb',
        price: 100,
        category: '동물',
      ),
      AvatarItem(
        id: 'panda',
        name: '팬더',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/samusil-addon.firebasestorage.app/o/avatars%2Fpanda.jpg?alt=media&token=56d254f6-7bba-4d96-aeb9-cc4ec2d591c1',
        price: 150,
        category: '동물',
      ),
      AvatarItem(
        id: 'penguin',
        name: '펭귄',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/samusil-addon.firebasestorage.app/o/avatars%2Fpenguin.jpg?alt=media&token=6cd77c34-56cc-48d1-b632-3341f460e36f',
        price: 150,
        category: '동물',
      ),

      // 직업 테마
      AvatarItem(
        id: 'doctor',
        name: '의사',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/samusil-addon.firebasestorage.app/o/avatars%2Fdoctor.jpg?alt=media&token=db04e6f7-e0a1-415d-ace8-7c681ae29f4e',
        price: 200,
        category: '직업',
      ),
      AvatarItem(
        id: 'police',
        name: '경찰',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/samusil-addon.firebasestorage.app/o/avatars%2Fpolice.jpg?alt=media&token=68ccbb59-cc78-462d-9d2a-dc0027104ea0',
        price: 200,
        category: '직업',
      ),
      AvatarItem(
        id: 'firefighter',
        name: '소방관',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/samusil-addon.firebasestorage.app/o/avatars%2Ffirefighter.jpg?alt=media&token=8d00fd89-c77a-4ca9-8f75-c099fc3055a4',
        price: 200,
        category: '직업',
      ),
      AvatarItem(
        id: 'chef',
        name: '요리사',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/samusil-addon.firebasestorage.app/o/avatars%2Fchef.jpg?alt=media&token=ed7c8d0f-d4cc-4140-bedf-4d0d6906ed31',
        price: 200,
        category: '직업',
      ),
      AvatarItem(
        id: 'programmer',
        name: '프로그래머',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/samusil-addon.firebasestorage.app/o/avatars%2Fprogrammer.jpg?alt=media&token=a82f0a97-15d9-402e-a40f-2598e3c2e211',
        price: 200,
        category: '직업',
      ),

      // 취미 테마
      AvatarItem(
        id: 'soccer',
        name: '축구',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/samusil-addon.firebasestorage.app/o/avatars%2Fsoccer.jpg?alt=media&token=f024b7a8-e343-406b-88bc-a9228487c129',
        price: 120,
        category: '취미',
      ),
      AvatarItem(
        id: 'basketball',
        name: '농구',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/samusil-addon.firebasestorage.app/o/avatars%2Fbasketball.jpg?alt=media&token=12e32eda-aa54-4228-aab2-fe51dadb78c3',
        price: 120,
        category: '취미',
      ),
      AvatarItem(
        id: 'music',
        name: '음악',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/samusil-addon.firebasestorage.app/o/avatars%2Fmusic.jpg?alt=media&token=1598e4fa-454b-4c2b-8121-339e98a01352',
        price: 120,
        category: '취미',
      ),
      AvatarItem(
        id: 'book',
        name: '독서',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/samusil-addon.firebasestorage.app/o/avatars%2Fbook.jpg?alt=media&token=08578f46-ed28-49fd-8fd4-4631e54a4fd0',
        price: 120,
        category: '취미',
      ),
      AvatarItem(
        id: 'game',
        name: '게임',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/samusil-addon.firebasestorage.app/o/avatars%2Fgame.jpg?alt=media&token=5bc028e2-5f6c-4d55-bf71-3444f00d18db',
        price: 120,
        category: '취미',
      ),
    ];

    availableAvatars.addAll(premiumAvatars);

    // Firestore에서 구매한 아바타 목록 조회
    await _loadPurchasedAvatars();
  }

  /// Firestore에서 구매한 아바타 목록 조회
  Future<void> _loadPurchasedAvatars() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        logger.w('User not authenticated');
        return;
      }

      final avatarsSnapshot =
          await FirebaseFirestore.instance
              .collection('profile')
              .doc(user.uid)
              .collection('avatars')
              .get();

      final purchasedAvatarIds =
          avatarsSnapshot.docs.map((doc) => doc.id).toSet();

      // availableAvatars에서 구매한 아바타들을 찾아서 isPurchased = true로 설정
      for (final avatar in availableAvatars) {
        if (purchasedAvatarIds.contains(avatar.id) || avatar.id == 'default') {
          avatar.isPurchased = true;
          if (!purchasedAvatars.any((item) => item.id == avatar.id)) {
            purchasedAvatars.add(avatar);
          }
        }
      }

      logger.i('구매한 아바타 ${purchasedAvatarIds.length}개 로드 완료');
    } catch (e) {
      logger.e('구매한 아바타 목록 로드 실패: $e');
    }
  }

  /// 아바타 선택
  void selectAvatar(String avatarUrl) {
    selectedAvatarUrl.value = avatarUrl;
    isAvatarChanged.value =
        selectedAvatarUrl.value != ProfileController.to.profileImageUrl;
  }

  /// 구매한 아바타인지 확인
  bool isAvatarPurchased(String avatarId) {
    return purchasedAvatars.any((avatar) => avatar.id == avatarId);
  }

  /// 아바타 구매
  Future<bool> purchaseAvatar(AvatarItem avatar) async {
    try {
      final currentPoint = ProfileController.to.currentPoint;

      if (currentPoint < avatar.price) {
        AppSnackbar.warning('아바타 구매에 필요한 포인트가 부족합니다.');
        return false;
      }

      // Cloud Functions 호출 (httpService 메소드 사용)
      final result = await HttpService().postCreateAvatarPurchase(
        avatarId: avatar.id,
        avatarUrl: avatar.imageUrl,
        avatarName: avatar.name,
        price: avatar.price,
      );

      if (result.success) {
        // 구매한 아바타 목록 새로고침
        await _loadPurchasedAvatars();

        AppSnackbar.success('${avatar.name} 아바타를 구매했습니다!');
        await ProfileController.to.refreshProfile();
        return true;
      } else {
        AppSnackbar.error(result.error ?? '알 수 없는 오류');
        return false;
      }
    } catch (e) {
      logger.e('아바타 구매 오류: $e');
      AppSnackbar.error('구매 중 오류가 발생했습니다.');
      return false;
    }
  }

  /// 프로필 저장
  Future<bool> saveProfile() async {
    try {
      isLoading.value = true;

      bool success = true;

      // 이름 변경
      if (isNameChanged.value) {
        success = await ProfileController.to.updateProfileName(
          nameController.text,
        );
      }

      // 아바타 변경
      if (isAvatarChanged.value && success) {
        success = await ProfileController.to.updateProfileImage(
          selectedAvatarUrl.value,
        );
      }

      // 한줄평 변경
      if (isCommentChanged.value && success) {
        success = await ProfileController.to.updateProfileOneComment(
          oneCommentController.text,
        );
      }

      if (success) {
        Get.back();
        AppSnackbar.success('프로필이 성공적으로 저장되었습니다.');
      } else {
        AppSnackbar.error('프로필 저장 중 오류가 발생했습니다.');
      }

      return success;
    } catch (e) {
      logger.e('프로필 저장 오류: $e');
      AppSnackbar.error('프로필 저장 중 오류가 발생했습니다.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 변경사항이 있는지 확인
  bool get hasChanges =>
      isNameChanged.value || isAvatarChanged.value || isCommentChanged.value;

  /// 아바타 구매 BottomSheet 표시 (Toss 스타일)
  void showPurchaseDialog(AvatarItem avatar) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 24,
                offset: Offset(0, -8),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // 아바타 미리보기
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF0064FF),
                      width: 2,
                    ),
                  ),
                  child: ProfileAvatarWidget(
                    photoUrl: avatar.imageUrl,
                    name: avatar.name,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${avatar.name} 아바타',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF191F28),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${avatar.price}포인트',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFF6B35),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '이 아바타를 구매하시겠습니까?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF191F28),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '구매 후 언제든지 프로필에서 사용할 수 있습니다.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8B95A1),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '현재 포인트',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8B95A1),
                        ),
                      ),
                      Text(
                        '${ProfileController.to.currentPointRounded}P',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0064FF),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF8B95A1),
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await purchaseAvatar(avatar);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0064FF),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          '구매하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 아바타 아이템 모델
class AvatarItem {
  final String id;
  final String name;
  final String imageUrl;
  final int price;
  final String category;
  bool isPurchased;

  AvatarItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    this.isPurchased = false,
  });
}
