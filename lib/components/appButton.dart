import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../define/define.dart';

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
    child: ElevatedButton(
      onPressed: disable ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: disable ? Colors.grey : backgroundColor,
      ),
      child: AutoSizeText(
        title,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: disable ? Colors.white : textColor,
        ),
        maxLines: 2,
      ),
    ),
  );
}
