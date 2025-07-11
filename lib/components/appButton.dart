import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../define/define.dart';
import 'appCircularProgress.dart';

void emptyFunction() {}

Widget AppButton(
  context,
  String title, {
  void Function() onTap = emptyFunction,
  bool disable = false,
  double pBtnWidth = 0.40,
  double pBtnHeight = 45,
  Color backgroundColor = Define.APP_MAIN_COLOR,
  Color textColor = Colors.white,
  isUnLimitHeight = false,
  isSizeFix = false,
  bool isLoading = false,
  Widget? icon,
}) {
  double width = MediaQuery.of(context).size.width;
  double btnWidth = width * pBtnWidth;
  return SizedBox(
    width: btnWidth,
    height:
        isSizeFix
            ? pBtnHeight
            : isUnLimitHeight
            ? null
            : pBtnHeight,
    child: GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color:
              isLoading
                  ? Colors.grey.shade300
                  : disable
                  ? Colors.grey
                  : backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child:
              isLoading
                  ? const AppButtonProgress(size: 20)
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[icon!, const SizedBox(width: 8)],
                      AutoSizeText(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color:
                              isLoading
                                  ? Colors.grey.shade500
                                  : disable
                                  ? Colors.white
                                  : textColor,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
        ),
      ),
    ),
  );
}

// AppLoadingIndicator는 이제 appCircularProgress.dart의 AppButtonProgress로 대체됨
