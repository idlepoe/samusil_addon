import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samusil_addon/components/appBarAction.dart';
import 'dart:async';
import 'package:samusil_addon/utils/app.dart';
import 'package:intl/intl.dart';

import '../../define/define.dart';
import '../../controllers/horse_race_controller.dart';
import '../../models/horse_race.dart';
import '../../controllers/profile_controller.dart';

class HorseRaceView extends StatefulWidget {
  const HorseRaceView({super.key});

  @override
  State<HorseRaceView> createState() => _HorseRaceViewState();
}

class _HorseRaceViewState extends State<HorseRaceView> {
  final HorseRaceController controller = Get.put(HorseRaceController());
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "코인 경마",
          style: TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        ),
        backgroundColor: Define.APP_BAR_BACKGROUND_COLOR,
        iconTheme: const IconThemeData(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        elevation: 0,
        // actions: AppBarAction(context, ProfileController.to.profile.value),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.currentRace.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatusCard("경마 없음", null),
                const SizedBox(height: 20),
                const Text("다음 경마를 기다려주세요."),
              ],
            ),
          );
        }

        final raceStatus = controller.getRaceStatus();
        final race = controller.currentRace.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusCard(raceStatus, race),
              const SizedBox(height: 20),

              // isActive가 false이고 isFinished가 false일 때가 베팅 관련 화면
              if (!race.isActive && !race.isFinished)
                // 이미 베팅했는지 여부에 따라 다른 위젯 표시
                if (controller.hasPlacedBet.value)
                  _buildBetPlacedSection()
                else
                  _buildBettingSection(race)
              else
                // 경주가 시작되었거나 종료되었을 때
                _buildRaceSection(race),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusCard(String status, HorseRace? race) {
    final remainingTime = controller.getRemainingTime();
    final bettingStart = DateFormat(
      'HH:mm',
    ).format(race?.bettingStartTime ?? DateTime.now());
    final bettingEnd = DateFormat(
      'HH:mm',
    ).format(race?.bettingEndTime ?? DateTime.now());
    final raceStart = DateFormat(
      'HH:mm',
    ).format(race?.startTime ?? DateTime.now());
    final raceEnd = DateFormat('HH:mm').format(race?.endTime ?? DateTime.now());
    final timeLabel = (race == null || race.isFinished) ? "다음 경마까지" : "남은 시간";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "오늘의 경마",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (race != null) ...[
            Text(
              "베팅: $bettingStart ~ $bettingEnd",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            Text(
              "경마: $raceStart ~ $raceEnd",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            "$timeLabel: ${remainingTime.inMinutes.toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}",
          ),
        ],
      ),
    );
  }

  Widget _buildBettingSection(HorseRace race) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "베팅하기",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),

          // 소유 포인트 표시
          Row(
            children: [
              Text(
                "소유 포인트",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const Spacer(),
              Obx(
                () => Text(
                  '${ProfileController.to.currentPoint} P',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 베팅 타입 선택
          Text(
            "베팅 종류",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildBetTypeButton('winner', '1등 맞추기', 5.0)),
              const SizedBox(width: 8),
              Expanded(child: _buildBetTypeButton('top2', '2등 안에 맞추기', 2.0)),
              const SizedBox(width: 8),
              Expanded(child: _buildBetTypeButton('top3', '3등 안에 맞추기', 1.5)),
            ],
          ),
          const SizedBox(height: 16),

          // 베팅 금액 선택
          Text(
            "베팅 금액",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children:
                controller.betAmountOptions.map((amount) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _buildBetAmountButton(amount),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 16),

          // 예상 획득 포인트
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "예상 획득 포인트",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  "${controller.getExpectedPoints()}P",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0064FF),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 베팅 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  controller.selectedHorseId.value.isNotEmpty
                      ? controller.placeBet
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0064FF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "베팅하기",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24), // 베팅 버튼과 말 목록 사이의 간격 추가
          _buildHorsesList(race.horses, true),
        ],
      ),
    );
  }

  Widget _buildRaceSection(HorseRace race) {
    return Column(
      children: [
        Text(
          "경주 진행 중",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildHorsesList(race.horses, false),
      ],
    );
  }

  Widget _buildHorsesList(List<Horse> horses, bool isBetting) {
    // 순위대로 정렬
    final sortedHorses = [...horses]
      ..sort((a, b) => b.currentPosition.compareTo(a.currentPosition));

    return Column(
      children:
          sortedHorses.asMap().entries.map((entry) {
            final rank = entry.key + 1;
            final horse = entry.value;
            return _buildHorseItem(horse, rank, isBetting);
          }).toList(),
    );
  }

  Widget _buildHorseItem(Horse horse, int rank, bool isBetting) {
    final isSelected = controller.selectedHorseId.value == horse.coinId;

    // 순위에 따른 슬라이더 색상 결정
    final Color sliderColor;
    if (rank == 1) {
      sliderColor = const Color(0xFFFFD700); // 금색
    } else if (rank == 2) {
      sliderColor = const Color(0xFFC0C0C0); // 은색
    } else if (rank == 3) {
      sliderColor = const Color(0xFFCD7F32); // 동색
    } else {
      sliderColor = Colors.green.shade400; // 나머지
    }

    return GestureDetector(
      onTap: isBetting ? () => controller.selectHorse(horse.coinId) : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue.shade400 : Colors.grey.shade200,
            width: 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blue.shade100.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Row(
          children: [
            Text(
              '$rank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 10),
            Image.network(
              horse.image,
              width: 32,
              height: 32,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 32);
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    horse.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    horse.symbol,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 10,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 6.0,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 0.0,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 0.0,
                        ),
                        trackShape: const RoundedRectSliderTrackShape(),
                      ),
                      child: Slider(
                        value: horse.currentPosition.clamp(0.0, 1.0),
                        min: 0,
                        max: 1.0,
                        onChanged: null,
                        activeColor:
                            isSelected ? Colors.blue.shade400 : sliderColor,
                        inactiveColor: Colors.grey.shade200,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBetTypeButton(String type, String label, double multiplier) {
    final isSelected = controller.selectedBetType.value == type;

    return GestureDetector(
      onTap: () => controller.changeBetType(type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0064FF) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF0064FF) : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${multiplier.toStringAsFixed(1)}배",
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBetAmountButton(int amount) {
    final isSelected = controller.selectedBetAmount.value == amount;

    return GestureDetector(
      onTap: () => controller.changeBetAmount(amount),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0064FF) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF0064FF) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          "${amount}P",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildBetPlacedSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade600, size: 48),
          const SizedBox(height: 12),
          Text(
            "베팅 완료!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "경주가 시작될 때까지 기다려주세요.",
            style: TextStyle(fontSize: 14, color: Colors.green.shade600),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '베팅 중':
        return Colors.orange;
      case '경주 중':
        return Colors.green;
      case '경주 종료':
        return Colors.grey;
      case '대기 중':
        return Colors.blue;
      case '경마 없음':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
