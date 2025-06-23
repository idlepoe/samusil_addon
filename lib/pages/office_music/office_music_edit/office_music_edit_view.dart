import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../../components/appCircularProgress.dart';
import '../../../define/define.dart';
import 'office_music_edit_controller.dart';

class OfficeMusicEditView extends GetView<OfficeMusicEditController> {
  const OfficeMusicEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(child: _buildBody()),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Obx(
        () => Text(
          controller.isEditMode.value ? '플레이리스트 수정' : '플레이리스트 만들기',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        Obx(
          () => TextButton(
            onPressed:
                controller.isPressed.value ? null : controller.savePlaylist,
            child: Text(
              controller.isEditMode.value ? '수정' : '완료',
              style: TextStyle(
                color: controller.isPressed.value ? Colors.grey : Colors.purple,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.isPressed.value) {
        return Container(
          height: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppCircularProgress.large(color: Colors.purple),
                SizedBox(height: 16),
                Obx(
                  () => Text(
                    controller.isEditMode.value
                        ? '플레이리스트를 수정하고 있습니다...'
                        : '플레이리스트를 생성하고 있습니다...',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Column(
        children: [
          _buildTitleSection(),
          _buildDivider(),
          _buildDescriptionSection(),
          _buildDivider(),
          _buildTrackSection(),
        ],
      );
    });
  }

  Widget _buildTitleSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LineIcons.music, color: Colors.purple, size: 20),
              const SizedBox(width: 8),
              const Text(
                '플레이리스트 제목',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller.titleController,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            decoration: const InputDecoration(
              hintText: '예: 집중력 향상 재즈 플레이리스트',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            inputFormatters: [LengthLimitingTextInputFormatter(50)],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LineIcons.fileAlt, color: Colors.purple, size: 20),
              const SizedBox(width: 8),
              const Text(
                '플레이리스트 설명',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller.descriptionController,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            decoration: const InputDecoration(
              hintText: '이 플레이리스트에 대한 설명을 작성해주세요...',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            maxLines: 4,
            inputFormatters: [LengthLimitingTextInputFormatter(200)],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackSection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LineIcons.list, color: Colors.purple, size: 20),
                const SizedBox(width: 8),
                Obx(
                  () => Text(
                    '음악 목록 (${controller.tracks.length}곡)',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: controller.addMusic,
                  icon: const Icon(LineIcons.plus, size: 16),
                  label: const Text('음악 추가'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.tracks.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LineIcons.music,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '아직 추가된 음악이 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\"음악 추가\" 버튼을 눌러서\n유튜브에서 음악을 검색해보세요!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: controller.tracks.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final track = controller.tracks[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // 썸네일
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                image:
                                    track.thumbnail.isNotEmpty
                                        ? DecorationImage(
                                          image: NetworkImage(track.thumbnail),
                                          fit: BoxFit.cover,
                                        )
                                        : null,
                                color:
                                    track.thumbnail.isEmpty
                                        ? Colors.grey[300]
                                        : null,
                              ),
                              child:
                                  track.thumbnail.isEmpty
                                      ? const Icon(
                                        LineIcons.music,
                                        color: Colors.grey,
                                        size: 20,
                                      )
                                      : null,
                            ),
                            const SizedBox(width: 12),
                            // 제목과 설명
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    track.title,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (track.description.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      track.description,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            // 삭제 버튼
                            IconButton(
                              onPressed: () => controller.removeTrack(index),
                              icon: const Icon(
                                LineIcons.times,
                                color: Colors.grey,
                                size: 20,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: const Color(0xFFF0F0F0));
  }
}
