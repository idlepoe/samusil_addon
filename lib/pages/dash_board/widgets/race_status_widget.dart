import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:logger/logger.dart';
import 'dart:async';

import '../../../utils/app.dart';
import '../../../main.dart';
import '../dash_board_controller.dart';
import '../../../controllers/horse_race_controller.dart';

class RaceStatusWidget extends StatefulWidget {
  const RaceStatusWidget({super.key});

  @override
  State<RaceStatusWidget> createState() => _RaceStatusWidgetState();
}

class _RaceStatusWidgetState extends State<RaceStatusWidget>
    with TickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // 1초마다 시간 업데이트
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // HorseRaceController를 안전하게 찾기
      HorseRaceController? horseRaceController;
      try {
        horseRaceController = Get.find<HorseRaceController>();
      } catch (e) {
        // HorseRaceController가 아직 초기화되지 않은 경우
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            height: 40,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                '경마 정보 로딩 중...',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
        );
      }

      // 경주 중일 때 애니메이션 시작
      final raceStatus = horseRaceController!.getRaceStatus();
      if (raceStatus == '경주 중') {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.reset();
      }

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          height: 40,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: () async {
              Get.toNamed('/horse-race');
            },
            child: Row(
              children: [
                // 경마 상태 표시
                _buildRaceStatusWidget(horseRaceController),
                const SizedBox(width: 16),
                // 경마 설명 텍스트
                Expanded(
                  child: Text(
                    '코인 경마 게임 - 탭하여 참여하세요!',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildRaceStatusWidget(HorseRaceController horseRaceController) {
    final raceStatus = horseRaceController.getRaceStatus();
    final remainingTime = horseRaceController.getRemainingTime();

    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (raceStatus) {
      case '베팅 중':
        statusColor = Colors.orange;
        statusIcon = Icons.sports_soccer;
        statusText = '베팅 중';
        break;
      case '경주 중':
        statusColor = Colors.green;
        statusIcon = Icons.directions_run;
        statusText = '경주 중';
        break;
      case '경주 종료':
        statusColor = Colors.grey;
        statusIcon = Icons.flag;
        statusText = '경주 종료';
        break;
      default:
        statusColor = Colors.blue;
        statusIcon = Icons.schedule;
        statusText = '다음 경마 대기';
        break;
    }

    Widget statusWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 14, color: statusColor),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (raceStatus != '경주 종료' && raceStatus != '다음 경마 대기') ...[
            const SizedBox(width: 4),
            Text(
              '${remainingTime.inMinutes.toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );

    // 경주 중일 때 애니메이션 효과 추가
    if (raceStatus == '경주 중') {
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(scale: _animation.value, child: statusWidget);
        },
      );
    }

    return statusWidget;
  }
}
