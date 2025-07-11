import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:office_lounge/components/appBarAction.dart';
import 'dart:async';
import 'package:office_lounge/utils/app.dart';
import 'package:intl/intl.dart';

import '../../components/appCircularProgress.dart';
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
      if (mounted) setState(() {});
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
      backgroundColor: const Color(0xFFF4F6F8), // 토스 스타일 배경
      appBar: AppBar(
        title: Text(
          "코인 경마",
          style: const TextStyle(
            color: Color(0xFF333D4B),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // 깔끔한 디자인을 위해 그림자 제거
        iconTheme: const IconThemeData(color: Color(0xFF333D4B)),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Get.toNamed('/horse-race-history'),
            tooltip: '경마 기록',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: AppCircularProgress.large());
        }

        if (controller.currentRace.value == null) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 100),
                _buildStatusCard("경마 없음", null),
                const SizedBox(height: 20),
                Text(
                  "다음 경마를 기다려주세요.",
                  style: const TextStyle(
                    color: Color(0xFF6B7684),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),
                _buildMarketCapNotice(),
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
              const SizedBox(height: 12),
              if (!race.isActive && !race.isFinished)
                if (controller.hasPlacedBet.value)
                  _buildBetPlacedSection()
                else
                  _buildBettingSection(race)
              else
                _buildRaceSection(race),
              const SizedBox(height: 20),
              _buildMarketCapNotice(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusCard(String status, HorseRace? race) {
    final remainingTime = controller.getRemainingTime();

    final String timeLabel;
    switch (status) {
      case '베팅 중':
        timeLabel = '베팅 마감까지';
        break;
      case '경주 중':
        timeLabel = '경주 종료까지';
        break;
      case '대기 중':
        timeLabel = '경주 시작까지';
        break;
      case '경마장 정리 중':
        timeLabel = '경주 시작까지';
        break;
      case '결과 처리 중':
        timeLabel = '다음 경마까지';
        break;
      default: // '경마 없음', '경주 종료' 포함
        timeLabel = '다음 경마까지';
        break;
    }

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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // 더 둥글게
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "오늘의 경마",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333D4B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: _getStatusColor(status),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (race != null) ...[
            Text(
              "∙ 베팅 시간: $bettingStart ~ $bettingEnd",
              style: TextStyle(color: Color(0xFF4E5968), fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              "∙ 경주 시간: $raceStart ~ $raceEnd",
              style: TextStyle(color: Color(0xFF4E5968), fontSize: 14),
            ),
            const SizedBox(height: 16),
          ],
          if (status == '경마장 정리 중') ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.cleaning_services, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '장내 경마장을 정리하고 있습니다',
                    style: TextStyle(
                      color: Colors.amber.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (status == '결과 처리 중') ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.analytics, color: Colors.purple, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '경주 결과를 처리하고 있습니다',
                    style: TextStyle(
                      color: Colors.purple.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              Text(
                timeLabel,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF6B7684),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                "${remainingTime.inMinutes.toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF333D4B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBettingSection(HorseRace race) {
    return Column(
      children: [
        _buildSectionContainer([
          _buildTitleValueRow(
            "보유 포인트",
            Obx(
              () => Text(
                '${ProfileController.to.currentPoint} P',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333D4B),
                ),
              ),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        _buildSectionContainer([
          _buildTitleRow("베팅 유형"),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildBetTypeButton('winner', '1등 베팅', 5.0)),
              const SizedBox(width: 8),
              Expanded(child: _buildBetTypeButton('top2', '2등 베팅', 2.0)),
              const SizedBox(width: 8),
              Expanded(child: _buildBetTypeButton('top3', '3등 베팅', 1.5)),
            ],
          ),
          const SizedBox(height: 20),
          _buildTitleRow("베팅 금액"),
          const SizedBox(height: 12),
          Row(
            children:
                controller.betAmountOptions
                    .map(
                      (amount) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _buildBetAmountButton(amount),
                        ),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 20),
          _buildTitleValueRow(
            "예상 획득 포인트",
            Obx(
              () => Text(
                "${controller.getExpectedPoints()}P",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0064FF),
                ),
              ),
            ),
          ),
        ]),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: Obx(
            () => ElevatedButton(
              onPressed:
                  controller.selectedHorseId.value.isNotEmpty &&
                          !controller.isBetting.value
                      ? controller.placeBet
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: const Color(0xFFE5E8EB),
                elevation: 0,
              ),
              child:
                  controller.isBetting.value
                      ? const AppButtonProgress(color: Colors.white, size: 24)
                      : Text(
                        "베팅하기",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildHorsesList(race.horses, true),
      ],
    );
  }

  Widget _buildSectionContainer(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildTitleRow(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF6B7684),
      ),
    );
  }

  Widget _buildTitleValueRow(String title, Widget valueWidget) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF4E5968),
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        valueWidget,
      ],
    );
  }

  Widget _buildRaceSection(HorseRace race) {
    return _buildSectionContainer([
      Text(
        "경주 현황",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333D4B),
        ),
      ),
      const SizedBox(height: 16),
      _buildHorsesList(race.horses, false),
    ]);
  }

  Widget _buildHorsesList(List<Horse> horses, bool isBetting) {
    final sortedHorses = [...horses]
      ..sort((a, b) => b.currentPosition.compareTo(a.currentPosition));
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: sortedHorses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final horse = sortedHorses[index];
        final rank = index + 1;
        return Obx(() => _buildHorseItem(horse, rank, isBetting));
      },
    );
  }

  Widget _buildHorseItem(Horse horse, int rank, bool isBetting) {
    final isSelectedForBetting =
        controller.selectedHorseId.value == horse.coinId;
    final isMyBet = controller.betOnHorseId.value == horse.coinId;
    final hasFinished = horse.currentPosition >= 1.0;

    final sliderColor =
        rank == 1
            ? const Color(0xFFFFD700)
            : rank == 2
            ? const Color(0xFFC0C0C0)
            : rank == 3
            ? const Color(0xFFCD7F32)
            : Colors.green.shade400;

    final itemBackgroundColor =
        isBetting && isSelectedForBetting
            ? Theme.of(context).primaryColor.withOpacity(0.05)
            : Colors.white;
    final itemBorderColor =
        isBetting && isSelectedForBetting
            ? Theme.of(context).primaryColor
            : (isMyBet ? Theme.of(context).primaryColor : Colors.transparent);
    final finalSliderColor =
        isBetting && isSelectedForBetting
            ? Theme.of(context).primaryColor
            : sliderColor;

    return GestureDetector(
      onTap: isBetting ? () => controller.selectHorse(horse.coinId) : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: itemBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: itemBorderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Text(
              '$rank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF6B7684),
              ),
            ),
            const SizedBox(width: 10),
            Image.network(
              horse.image,
              width: 32,
              height: 32,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 32),
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
                  LinearProgressIndicator(
                    value: horse.currentPosition.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    color: finalSliderColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            if (hasFinished)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '🏁 $rank등',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: sliderColor,
                  ),
                ),
              ),
            if (isMyBet)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '내 베팅',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
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
          color:
              isSelected
                  ? Theme.of(context).primaryColor
                  : const Color(0xFFF2F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF4E5968),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${multiplier.toStringAsFixed(1)}배",
              style: TextStyle(
                fontSize: 11,
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
          color:
              isSelected
                  ? Theme.of(context).primaryColor
                  : const Color(0xFFF2F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "${amount}P",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF4E5968),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: Theme.of(context).primaryColor,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            "베팅 완료",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333D4B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "경주 시작을 기다려주세요",
            style: const TextStyle(fontSize: 15, color: Color(0xFF6B7684)),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketCapNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '💡 각 코인의 24시간 시가총액 변동률이 경주 속도에 영향을 미칩니다',
              style: TextStyle(
                fontSize: 13,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
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
      case '경마장 정리 중':
        return Colors.amber;
      case '결과 처리 중':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
