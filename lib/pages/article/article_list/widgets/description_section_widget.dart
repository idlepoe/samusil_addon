import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DescriptionSectionWidget extends StatelessWidget {
  final String description;

  const DescriptionSectionWidget({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Text(
        description.tr,
        style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
