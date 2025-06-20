import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FloatingWriteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool canWrite;

  const FloatingWriteButton({
    super.key,
    required this.onPressed,
    required this.canWrite,
  });

  @override
  Widget build(BuildContext context) {
    if (!canWrite) return const SizedBox.shrink();

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xFF0064FF),
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}
