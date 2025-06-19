import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../dash_board_controller.dart';

class WishInputBottomSheet extends StatelessWidget {
  final DashBoardController controller;

  const WishInputBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.showInput.value
              ? ListTile(
                tileColor: Colors.white.withOpacity(0.2),
                contentPadding: const EdgeInsets.only(left: 3, right: 3),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      enabled: !controller.isCommentLoading.value,
                      controller: controller.commentController,
                      focusNode: controller.commentFocusNode,
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: "",
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        suffixIcon:
                            controller.isCommentLoading.value
                                ? Transform.scale(
                                  scale: 0.5,
                                  child: const CircularProgressIndicator(),
                                )
                                : IconButton(
                                  icon: Icon(
                                    LineIcons.magic,
                                    color:
                                        controller
                                                .commentController
                                                .text
                                                .isEmpty
                                            ? Colors.grey
                                            : Colors.lightBlue,
                                  ),
                                  onPressed:
                                      controller.commentController.text.isEmpty
                                          ? null
                                          : () async {
                                            await controller.createWish(
                                              controller.commentController.text,
                                            );
                                          },
                                ),
                      ),
                      onChanged: (s) {
                        controller.update();
                      },
                      onFieldSubmitted:
                          controller.commentController.text.isEmpty
                              ? null
                              : (s) async {
                                await controller.createWish(
                                  controller.commentController.text,
                                );
                              },
                    ),
                  ],
                ),
              )
              : const SizedBox.shrink(),
    );
  }
}
