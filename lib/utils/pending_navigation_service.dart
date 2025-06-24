import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class PendingNavigationService {
  static final PendingNavigationService _instance =
      PendingNavigationService._internal();
  factory PendingNavigationService() => _instance;
  PendingNavigationService._internal();

  final Logger _logger = Logger();
  static const String _pendingRouteKey = 'pending_navigation_route';
  static const String _pendingDataKey = 'pending_navigation_data';

  /// 지연된 네비게이션 정보를 저장합니다
  Future<void> setPendingNavigation({
    required String route,
    Map<String, dynamic>? data,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_pendingRouteKey, route);

      if (data != null) {
        // 간단한 데이터만 저장 (JSON 직렬화 없이)
        for (final entry in data.entries) {
          await prefs.setString(
            '${_pendingDataKey}_${entry.key}',
            entry.value.toString(),
          );
        }
      }

      _logger.i('🚀 지연된 네비게이션 저장: $route, 데이터: $data');
    } catch (e) {
      _logger.e('지연된 네비게이션 저장 오류: $e');
    }
  }

  /// 저장된 지연된 네비게이션 정보를 가져옵니다
  Future<Map<String, dynamic>?> getPendingNavigation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final route = prefs.getString(_pendingRouteKey);

      if (route == null) return null;

      // 저장된 데이터 복원
      final Map<String, dynamic> data = {};
      final keys = prefs.getKeys().where(
        (key) => key.startsWith(_pendingDataKey),
      );
      for (final key in keys) {
        final dataKey = key.replaceFirst('${_pendingDataKey}_', '');
        final value = prefs.getString(key);
        if (value != null) {
          data[dataKey] = value;
        }
      }

      _logger.i('🚀 지연된 네비게이션 복원: $route, 데이터: $data');
      return {'route': route, 'data': data};
    } catch (e) {
      _logger.e('지연된 네비게이션 복원 오류: $e');
      return null;
    }
  }

  /// 지연된 네비게이션 정보를 삭제합니다
  Future<void> clearPendingNavigation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pendingRouteKey);

      // 모든 데이터 키 삭제
      final keys = prefs.getKeys().where(
        (key) => key.startsWith(_pendingDataKey),
      );
      for (final key in keys) {
        await prefs.remove(key);
      }

      _logger.i('🚀 지연된 네비게이션 정보 삭제 완료');
    } catch (e) {
      _logger.e('지연된 네비게이션 삭제 오류: $e');
    }
  }

  /// 지연된 네비게이션이 있는지 확인합니다
  Future<bool> hasPendingNavigation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_pendingRouteKey);
    } catch (e) {
      _logger.e('지연된 네비게이션 확인 오류: $e');
      return false;
    }
  }
}
