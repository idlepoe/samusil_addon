import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../article_detail_controller.dart';

class DeleteButtonWidget extends GetView<ArticleDetailController> {
  const DeleteButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showDeleteDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "article_delete".tr,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text("article_delete_confirm".tr),
        content: Text("article_delete_confirm_description".tr),
        actions: [
          CupertinoDialogAction(
            onPressed: () async {
  await            controller.deleteArticle();              Get.back();

            },
            isDestructiveAction: true,
            child: Text("yes".tr),
          ),
          CupertinoDialogAction(
            onPressed: () => Get.back(),
            child: Text("no".tr),
          ),
        ],
      ),
    );
  }
}
