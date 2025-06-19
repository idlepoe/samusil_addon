import 'package:flutter/material.dart';

void emptyFunction() {}

Widget BottomIconButton(IconData iconData, String title,
    {void Function() onTap = emptyFunction,
    Color color = Colors.black,
    disabled = false}) {
  return TextButton.icon(
    onPressed: disabled ? null : onTap,
    label: const Text(""),
    icon: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(iconData, color: disabled ? Colors.grey : color),
        Text(
          title,
          style: TextStyle(color: disabled ? Colors.grey : color),
        ),
      ],
    ),
  );
}
