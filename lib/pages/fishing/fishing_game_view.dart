import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'fishing_game_controller.dart';
import '../../models/fish.dart';
import 'widgets/fishing_game_tab.dart';
import 'widgets/fish_collection_tab.dart';

class FishingGameView extends GetView<FishingGameController> {
  const FishingGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF87CEEB), // 하색 배경
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🎣 출근길 낚시왕',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                Fish.getTodayLocationDescription(),
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF4682B4),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          toolbarHeight: 80,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.videogame_asset), text: '낚시 게임'),
              Tab(icon: Icon(Icons.book), text: '물고기 도감'),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(), // 드래그로 탭 이동 비활성화
          children: [FishingGameTab(), FishCollectionTab()],
        ),
      ),
    );
  }
}
