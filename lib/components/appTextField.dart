import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void emptyFunction() {}

Widget AppTextField(
  String title,
  TextEditingController textEditingController, {
  bool isDisable = false,
  String hint = "",
  int? maxLength,
  FocusNode? focusNode,
  TextInputType? textInputType,
  double radius = 12,
  Widget? suffixIcon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title.isNotEmpty) ...[
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF191F28),
          ),
        ),
        const SizedBox(height: 8),
      ],
      TextField(
        controller: textEditingController,
        enabled: !isDisable,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF191F28),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: isDisable ? const Color(0xFFF8F9FA) : Colors.white,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF8B95A1),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: const BorderSide(color: Color(0xFF0064FF), width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
          ),
        ),
        onChanged: (value) {},
        focusNode: focusNode,
        keyboardType: textInputType,
        inputFormatters:
            maxLength == null
                ? null
                : [LengthLimitingTextInputFormatter(maxLength)],
      ),
    ],
  );
}
