import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samusil_addon/components/appBarAction.dart';
import 'dart:async';
import 'package:samusil_addon/utils/app.dart';

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
        title: const Text("코인 경마", style: TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR)),
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
          return const Center(child: Text("다음 경마를 기다려주세요."));
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
              
              if (raceStatus == '베팅 중')
                _buildBettingSection(race)
              else
                _buildRaceSection(race),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusCard(String status, HorseRace race) {
    final remainingTime = controller.getRemainingTime();
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          Text(
            "베팅: 00:00 ~ 01:00",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            "경마: 01:00 ~ 04:00",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Text("남은 시간: ${remainingTime.inMinutes.toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}"),
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
              Expanded(
                child: _buildBetTypeButton('winner', '1등 예측', 5.0),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBetTypeButton('top2', '1-2등 예측', 2.0),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBetTypeButton('top3', '3등 예측', 1.5),
              ),
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
            children: controller.betAmountOptions.map((amount) {
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
              onPressed: controller.selectedHorseId.value.isNotEmpty
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
          _buildHorsesList(race.horses, true),
        ],
      ),
    );
  }

  Widget _buildRaceSection(HorseRace race) {
    return Column(
      children: [
        Text("경주 진행 중", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildHorsesList(race.horses, false),
      ],
    );
  }

  Widget _buildHorsesList(List<Horse> horses, bool isBetting) {
    // 순위대로 정렬
    final sortedHorses = [...horses]..sort((a, b) => b.currentPosition.compareTo(a.currentPosition));
    
    return Column(
      children: sortedHorses.asMap().entries.map((entry) {
        final rank = entry.key + 1;
        final horse = entry.value;
        return _buildHorseItem(horse, rank, isBetting);
      }).toList(),
    );
  }

  Widget _buildHorseItem(Horse horse, int rank, bool isBetting) {
    final isSelected = controller.selectedHorseId.value == horse.coinId;
    final maxPosition = controller.currentRace.value!.horses.map((h) => h.currentPosition).reduce((a, b) => a > b ? a : b);

    return GestureDetector(
      onTap: isBetting ? () => controller.selectHorse(horse.coinId) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade200, width: 2),
        ),
        child: Column(
          children: [
            Row(
              children: [
                App.buildCoinIcon(horse.symbol, size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(horse.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(horse.symbol),
                  ],
                ),
                const Spacer(),
                Text("순위: $rank", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            // 슬라이더로 진행 상황 표시
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.0),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
              ),
              child: Slider(
                value: horse.currentPosition,
                min: 0,
                max: maxPosition > 10 ? maxPosition : 10, // 최소 max 값 보장
                onChanged: null,
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

  Color _getStatusColor(String status) {
    switch (status) {
      case '베팅 중':
        return Colors.orange;
      case '경마 진행 중':
        return Colors.green;
      case '경마 종료':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
} 