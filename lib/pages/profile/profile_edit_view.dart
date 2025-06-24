import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/profile_avatar_widget.dart';
import '../../components/appTextField.dart';
import '../../components/appButton.dart';
import '../../controllers/profile_controller.dart';
import 'profile_edit_controller.dart';

class ProfileEditView extends GetView<ProfileEditController> {
  const ProfileEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF191F28)),
        title: const Text(
          '프로필 수정',
          style: TextStyle(
            color: Color(0xFF191F28),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(
            () => TextButton(
              onPressed:
                  controller.hasChanges && !controller.isLoading.value
                      ? controller.saveProfile
                      : null,
              child: Text(
                '저장',
                style: TextStyle(
                  color:
                      controller.hasChanges && !controller.isLoading.value
                          ? const Color(0xFF0064FF)
                          : const Color(0xFFCCCCCC),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF8F9FA)],
          ),
        ),
        child: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 현재 프로필 정보
                _buildCurrentProfileSection(),
                const SizedBox(height: 24),

                // 닉네임 수정
                _buildNameEditSection(context),
                const SizedBox(height: 24),

                // 아바타 선택
                _buildAvatarSelectionSection(),
                const SizedBox(height: 24),

                // 한줄평 수정
                _buildOneCommentSection(context),
                const SizedBox(height: 32),

                // 저장 버튼
                _buildSaveButton(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 현재 프로필 정보 섹션
  Widget _buildCurrentProfileSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ProfileAvatarWidget(
              photoUrl: ProfileController.to.profileImageUrl,
              name: ProfileController.to.userName,
              size: 64,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ProfileController.to.userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF191F28),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0064FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${ProfileController.to.currentPointRounded}P',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0064FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (ProfileController.to.oneComment.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    ProfileController.to.oneComment,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8B95A1),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 닉네임 수정 섹션
  Widget _buildNameEditSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF0064FF),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '닉네임',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF191F28),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppTextField(
            '',
            controller.nameController,
            hint: '닉네임을 입력하세요',
            maxLength: 20,
          ),
        ],
      ),
    );
  }

  /// 아바타 선택 섹션
  Widget _buildAvatarSelectionSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF0064FF),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '프로필 사진',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF191F28),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0064FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${ProfileController.to.currentPointRounded}P',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0064FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 선택된 아바타 미리보기
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF0064FF), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0064FF).withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ProfileAvatarWidget(
                photoUrl: controller.selectedAvatarUrl.value,
                name:
                    controller.nameController.text.isNotEmpty
                        ? controller.nameController.text
                        : ProfileController.to.userName,
                size: 80,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 아바타 목록
          _buildAvatarGrid(),
        ],
      ),
    );
  }

  /// 아바타 그리드
  Widget _buildAvatarGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '아바타 선택',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF191F28),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: controller.availableAvatars.length,
          itemBuilder: (context, index) {
            final avatar = controller.availableAvatars[index];
            final isSelected =
                controller.selectedAvatarUrl.value == avatar.imageUrl;
            final isPurchased = controller.purchasedAvatars.any(
              (item) => item.id == avatar.id,
            );

            return GestureDetector(
              onTap: () {
                if (isPurchased || avatar.id == 'default') {
                  controller.selectAvatar(avatar.imageUrl);
                } else {
                  controller.showPurchaseDialog(avatar);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0064FF) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      isSelected
                          ? Border.all(color: const Color(0xFF0064FF), width: 2)
                          : Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 1,
                          ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isSelected
                              ? const Color(0xFF0064FF).withOpacity(0.2)
                              : Colors.black.withOpacity(0.04),
                      blurRadius: isSelected ? 12 : 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: ProfileAvatarWidget(
                        photoUrl: avatar.imageUrl,
                        name: avatar.name,
                        size: 44,
                      ),
                    ),
                    if (!isPurchased)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6B35).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            '${avatar.price}P',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// 한줄평 수정 섹션
  Widget _buildOneCommentSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF0064FF),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '한줄평',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF191F28),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppTextField(
            '',
            controller.oneCommentController,
            hint: '자신을 한 줄로 표현해보세요',
            maxLength: 50,
          ),
        ],
      ),
    );
  }

  /// 저장 버튼
  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed:
            controller.hasChanges && !controller.isLoading.value
                ? () => controller.saveProfile()
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              controller.hasChanges && !controller.isLoading.value
                  ? const Color(0xFF0064FF)
                  : const Color(0xFFE5E7EB),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child:
            controller.isLoading.value
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : const Text(
                  '저장하기',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
      ),
    );
  }
}
