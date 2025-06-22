import 'package:flutter/material.dart';

class AppCircularProgress extends StatelessWidget {
  final double? value;
  final Color? color;
  final Color? backgroundColor;
  final double strokeWidth;
  final double size;
  final String? semanticsLabel;
  final String? semanticsValue;

  const AppCircularProgress({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 3.0,
    this.size = 24.0,
    this.semanticsLabel,
    this.semanticsValue,
  });

  // 작은 사이즈 (16x16)
  const AppCircularProgress.small({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 2.5,
    this.size = 16.0,
    this.semanticsLabel,
    this.semanticsValue,
  });

  // 중간 사이즈 (24x24) - 기본값
  const AppCircularProgress.medium({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 3.0,
    this.size = 24.0,
    this.semanticsLabel,
    this.semanticsValue,
  });

  // 큰 사이즈 (32x32)
  const AppCircularProgress.large({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 4.0,
    this.size = 32.0,
    this.semanticsLabel,
    this.semanticsValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Toss 스타일 색상 설정
    final progressColor = color ?? theme.primaryColor;
    final bgColor = backgroundColor ?? progressColor.withOpacity(0.15);

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth,
        strokeCap: StrokeCap.round, // 둥근 끝 모양
        color: progressColor,
        backgroundColor: bgColor,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
      ),
    );
  }
}

// 로딩 오버레이 위젯
class AppLoadingOverlay extends StatelessWidget {
  final String? message;
  final bool isVisible;
  final Widget? child;

  const AppLoadingOverlay({
    super.key,
    this.message,
    this.isVisible = true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return child ?? const SizedBox.shrink();
    }

    return Stack(
      children: [
        if (child != null) child!,
        Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppCircularProgress.large(),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      message!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333D4B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 버튼 내부 로딩 인디케이터
class AppButtonProgress extends StatelessWidget {
  final Color? color;
  final double size;

  const AppButtonProgress({super.key, this.color, this.size = 20.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        strokeCap: StrokeCap.round,
        color: color ?? Colors.white,
        backgroundColor: (color ?? Colors.white).withOpacity(0.3),
      ),
    );
  }
}
