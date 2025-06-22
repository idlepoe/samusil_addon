import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../components/appButton.dart';
import '../../components/appCircularProgress.dart';
import '../../define/arrays.dart';
import '../../define/define.dart';
import 'wish_controller.dart';

class WishView extends GetView<WishController> {
  const WishView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF191F28)),
        title: Text(
          "wish".tr,
          style: const TextStyle(
            color: Color(0xFF191F28),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: controller.refresh,
          child:
              controller.isLoading.value
                  ? const Center(child: AppCircularProgress.large())
                  : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildWishHeader(),
                        const SizedBox(height: 20),
                        _buildWishStats(),
                        const SizedBox(height: 20),
                        _buildWishInput(),
                        const SizedBox(height: 20),
                        _buildWishList(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildWishHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF0064FF), const Color(0xFF0052CC)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0064FF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "소원을 빌어보세요",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "매일 기도하면 소원이 이루어질 거예요",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              "연속 기도",
              "${controller.profile.value.wish_streak}일",
              Icons.local_fire_department,
              const Color(0xFFFF6B35),
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          Expanded(
            child: _buildStatItem(
              "기도 포인트",
              "+${controller.profile.value.wish_streak * 5}",
              Icons.stars,
              const Color(0xFFFFD700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF191F28),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildWishInput() {
    return Obx(
      () =>
          controller.alreadyWished.value
              ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C851).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF00C851).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF00C851),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "오늘의 기도를 완료했습니다",
                      style: const TextStyle(
                        color: Color(0xFF00C851),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
              : Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: controller.commentController,
                      focusNode: controller.commentFocusNode,
                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      decoration: InputDecoration(
                        hintText: "오늘의 소원을 입력하세요",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        suffixIcon: _buildSendButton(),
                      ),
                      maxLength: 20,
                      textInputAction: TextInputAction.send,
                      onChanged: controller.onTextChanged,
                      onSubmitted: (value) {
                        if (controller.canCreateWish) {
                          controller.createWish(value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              controller.canCreateWish
                                  ? () => controller.createWish(
                                    controller.commentController.text,
                                  )
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                controller.canCreateWish
                                    ? const Color(0xFF0064FF)
                                    : Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "기도 올리기",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildSendButton() {
    return Obx(
      () => IconButton(
        onPressed:
            controller.canCreateWish
                ? () => controller.createWish(controller.commentController.text)
                : null,
        icon: Icon(
          Icons.send,
          color:
              controller.canCreateWish ? const Color(0xFF0064FF) : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildWishList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
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
                Text(
                  "다른 사람들의 소원",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191F28),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () =>
                controller.wishList.isEmpty
                    ? _buildEmptyWishList()
                    : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.wishList.length,
                      itemBuilder: (context, index) {
                        final wish = controller.wishList[index];
                        return _buildWishItem(wish, index);
                      },
                      separatorBuilder:
                          (context, index) =>
                              Divider(height: 1, color: Colors.grey.shade100),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishItem(dynamic wish, int index) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF0064FF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "${wish.index}",
            style: const TextStyle(
              color: Color(0xFF0064FF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      title: Text(
        wish.comments,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF191F28),
        ),
      ),
      subtitle: Text(
        "${wish.nick_name} • ${wish.streak}일째",
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF00C851).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "+${wish.streak * 5}",
          style: const TextStyle(
            color: Color(0xFF00C851),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyWishList() {
    return Container(
      height: 300,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  Icons.favorite_border,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "아직 다른 사람들의 소원이 없어요",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "첫 번째 소원을 올려보세요!",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
