import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/appCircularProgress.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0064FF),
      body: Obx(
        () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 앱 로고
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset('assets/icon.png', fit: BoxFit.cover),
                ),
              ),

              const SizedBox(height: 32),

              // 앱 이름
              const Text(
                '오피스 라운지',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // 부제목
              const Text(
                '소원을 빌고 소통하세요',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),

              const SizedBox(height: 48),

              // 로딩 인디케이터
              if (controller.isLoading.value)
                const AppCircularProgress(
                  color: Colors.white,
                  backgroundColor: Colors.white30,
                  strokeWidth: 3,
                ),

              const SizedBox(height: 24),

              // 로딩 텍스트
              if (controller.isLoading.value)
                const Text(
                  '초기화 중...',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
