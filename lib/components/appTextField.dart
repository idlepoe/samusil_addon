import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void emptyFunction() {}

Widget AppTextField(String title, TextEditingController textEditingController,
    {bool isDisable = false,
    String hint = "",
    int? maxLength,
    FocusNode? focusNode,
    TextInputType? textInputType,
    double radius = 10, Widget? suffixIcon}) {
  return TextField(
    controller: textEditingController,
    decoration: InputDecoration(
      fillColor: isDisable ? Colors.grey : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      hintText: hint,
      suffixIcon: suffixIcon,
    ),
    onChanged: (value) {},
    focusNode: focusNode,
    keyboardType: textInputType,
    inputFormatters: maxLength == null
        ? null
        : [
            LengthLimitingTextInputFormatter(maxLength),
          ],
  );
}
