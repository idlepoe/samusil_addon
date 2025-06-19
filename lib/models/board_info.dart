import 'package:flutter/material.dart';

class BoardInfo{
  int index;
  Icon icon;
  String title;
  String description;
  bool? isPopular;
  bool? isNotice;
  bool isCanWrite;

  BoardInfo(this.index,this.icon, this.title, this.description,this.isCanWrite);

  BoardInfo.init():this(1,const Icon(Icons.icecream), "", "",true);

  @override
  String toString() {
    return 'BoardInfo{index: $index, icon: $icon, title: $title, description: $description, isPopular: $isPopular, isNotice: $isNotice, isCanWrite: $isCanWrite}';
  }
}