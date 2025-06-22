import 'package:flutter/material.dart';

class ProfileBadgeWidget extends StatelessWidget {
  final int point;
  final int? fontSize;
  final EdgeInsets? margin;

  const ProfileBadgeWidget({
    super.key,
    required this.point,
    this.fontSize = 10,
    this.margin = const EdgeInsets.only(left: 4),
  });

  @override
  Widget build(BuildContext context) {
    final badgeInfo = _getBadgeInfo(point);
    
    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: badgeInfo.backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        badgeInfo.title,
        style: TextStyle(
          color: badgeInfo.textColor,
          fontSize: fontSize?.toDouble(),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  BadgeInfo _getBadgeInfo(int point) {
    if (point >= 1000) {
      return BadgeInfo(
        title: 'CEO',
        backgroundColor: Colors.purple.shade100,
        textColor: Colors.purple.shade800,
      );
    } else if (point >= 800) {
      return BadgeInfo(
        title: '부장',
        backgroundColor: Colors.red.shade100,
        textColor: Colors.red.shade800,
      );
    } else if (point >= 600) {
      return BadgeInfo(
        title: '과장',
        backgroundColor: Colors.orange.shade100,
        textColor: Colors.orange.shade800,
      );
    } else if (point >= 400) {
      return BadgeInfo(
        title: '대리',
        backgroundColor: Colors.blue.shade100,
        textColor: Colors.blue.shade800,
      );
    } else if (point >= 200) {
      return BadgeInfo(
        title: '주임',
        backgroundColor: Colors.green.shade100,
        textColor: Colors.green.shade800,
      );
    } else if (point >= 100) {
      return BadgeInfo(
        title: '사원',
        backgroundColor: Colors.amber.shade100,
        textColor: Colors.amber.shade800,
      );
    } else if (point >= 50) {
      return BadgeInfo(
        title: '인턴',
        backgroundColor: Colors.grey.shade100,
        textColor: Colors.grey.shade800,
      );
    } else {
      return BadgeInfo(
        title: '신입',
        backgroundColor: Colors.cyan.shade100,
        textColor: Colors.cyan.shade800,
      );
    }
  }
}

class BadgeInfo {
  final String title;
  final Color backgroundColor;
  final Color textColor;

  BadgeInfo({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
  });
} 