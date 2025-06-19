import 'package:flutter/material.dart';

class BoardInfo {
  String board_name;
  Icon icon;
  String title;
  String description;
  bool? isPopular;
  bool? isNotice;
  bool isCanWrite;

  BoardInfo(
    this.board_name,
    this.icon,
    this.title,
    this.description,
    this.isCanWrite,
  );

  BoardInfo.init() : this("", const Icon(Icons.icecream), "", "", true);

  @override
  String toString() {
    return 'BoardInfo{board_name: $board_name, icon: $icon, title: $title, description: $description, isPopular: $isPopular, isNotice: $isNotice, isCanWrite: $isCanWrite}';
  }
}
