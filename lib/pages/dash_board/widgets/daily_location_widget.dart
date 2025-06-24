import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/fish.dart';

class DailyLocationWidget extends StatelessWidget {
  const DailyLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final todayLocation = Fish.getTodayLocation();
    final todayDescription = Fish.getTodayLocationDescription();
    final todayFishCount = Fish.getTodayAvailableFish().length;

    // 요일별 이모지 매핑
    final locationEmojis = {
      '강': '🏞️',
      '연못': '🪷',
      '하구': '🌊',
      '절벽 위': '⛰️',
      '바다': '🌊',
      '부둣가': '🛥️',
      '바다(잠수)': '🤿',
    };

    // 요일별 색상 매핑
    final locationColors = {
      '강': const Color(0xFF2196F3), // 파란색
      '연못': const Color(0xFF4CAF50), // 초록색
      '하구': const Color(0xFF00BCD4), // 청록색
      '절벽 위': const Color(0xFF795548), // 갈색
      '바다': const Color(0xFF3F51B5), // 남색
      '부둣가': const Color(0xFF607D8B), // 청회색
      '바다(잠수)': const Color(0xFF9C27B0), // 보라색
    };

    final locationColor =
        locationColors[todayLocation] ?? const Color(0xFF2196F3);
    final locationEmoji = locationEmojis[todayLocation] ?? '🎣';

    return InkWell(
      onTap: () {
        // 낚시 게임 화면으로 이동
        Get.toNamed('/fishing-game');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              locationColor.withOpacity(0.1),
              locationColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: locationColor.withOpacity(0.2), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 아이콘 컨테이너
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: locationColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    locationEmoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 텍스트 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '오늘의 낚시터',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: locationColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${todayFishCount}종',
                            style: TextStyle(
                              fontSize: 10,
                              color: locationColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Fish.getLocationDisplayName(todayLocation),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: locationColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      todayDescription.split(' - ')[1], // "월요일 - " 부분 제거
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
