import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/profile_controller.dart';
import '../../models/artwork.dart';
import '../../utils/http_service.dart';
import '../../utils/util.dart';
import '../../components/appSnackbar.dart';
import '../../main.dart';

class ArtworkController extends GetxController {
  final artworks = <Artwork>[].obs;
  final ownedIds = <String>{}.obs;

  final isLoading = false.obs;

  static const _cacheKey = 'cached_artworks';
  static const _cacheTimeKey = 'artworks_last_updated';

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    await Future.wait([loadArtworksFromLocalOrServer(), fetchOwnedIds()]);
  }

  final showUnowned = false.obs;

  List<Artwork> get filteredArtworks {
    if (showUnowned.value) return artworks;
    return artworks.where((a) => isOwned(a.id)).toList();
  }

  Future<void> loadArtworksFromLocalOrServer() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      final lastUpdatedStr = prefs.getString(_cacheTimeKey);
      final lastUpdated =
          lastUpdatedStr != null ? DateTime.tryParse(lastUpdatedStr) : null;

      // ✅ 7일 이내 캐시가 있다면 로컬 데이터 사용
      if (lastUpdated != null &&
          now.difference(lastUpdated) < const Duration(days: 7)) {
        final cachedJson = prefs.getString(_cacheKey);
        if (cachedJson != null) {
          final List decoded = json.decode(cachedJson);
          artworks.assignAll(decoded.map((e) => Artwork.fromJson(e)).toList());
          return;
        }
      }

      // ✅ 서버에서 전체 로딩
      final snapshot =
          await FirebaseFirestore.instance.collection('artworks').get();

      final newList =
          snapshot.docs.map((doc) {
            final data = doc.data();
            return Artwork.fromJson({...data, 'id': doc.id});
          }).toList();

      artworks.assignAll(newList);

      // ✅ SharedPreferences에 저장
      await prefs.setString(
        _cacheKey,
        json.encode(newList.map((e) => e.toJson()).toList()),
      );
      await prefs.setString(_cacheTimeKey, now.toIso8601String());
    } catch (e) {
      logger.e('Error loading artworks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 현재 유저의 소유 작품 ID 불러오기
  Future<void> fetchOwnedIds() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      final snapshot =
          await _firestore
              .collection('profile')
              .doc(uid)
              .collection('artworks')
              .get();

      final ids = snapshot.docs.map((doc) => doc.id).toList();
      ownedIds.addAll(ids);

      logger.i("✅ 소장 작품 ID: $ownedIds");
    } catch (e) {
      logger.e("Error fetching owned artwork IDs: $e");
    }
  }

  bool isOwned(String id) => ownedIds.contains(id);

  Future<void> drawGacha() async {
    // ✅ 포인트 확인
    final profileController = Get.find<ProfileController>();
    final currentPoints = profileController.currentPointInt;

    if (currentPoints < 500) {
      AppSnackbar.warning('가챠를 하기 위해서는 최소 500포인트가 필요해요.');
      return;
    }

    isLoading.value = true;
    try {
      final response = await HttpService().purchaseRandomArtwork();
      if (response.success && response.data != null) {
        final artworkId = response.data['artworkId'];
        final artworkName = response.data['artworkName'];
        ownedIds.add(artworkId);
        AppSnackbar.success('🎁 $artworkName 획득!');
        // 프로필 컨트롤러 새로고침
        final profileController = Get.find<ProfileController>();
        await profileController.refreshProfile();
      } else {
        AppSnackbar.error(response.error ?? '가챠 중 오류 발생');
      }
    } catch (e) {
      logger.e(e);
      AppSnackbar.error('가챠 중 오류 발생');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> purchaseArtwork(Artwork artwork) async {
    isLoading.value = true;
    try {
      final response = await HttpService().purchaseArtwork(
        artworkId: artwork.id,
      );
      if (response.success) {
        ownedIds.add(artwork.id);
        AppSnackbar.success('🎉 ${artwork.nameKr}를 소장했습니다!');
        // 프로필 컨트롤러 새로고침
        final profileController = Get.find<ProfileController>();
        await profileController.refreshProfile();
      } else {
        AppSnackbar.error(response.error ?? '작품 구매 중 오류 발생');
      }
    } catch (e) {
      AppSnackbar.error('작품 구매 중 오류 발생');
    } finally {
      isLoading.value = false;
    }
  }
}
