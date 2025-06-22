import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../define/arrays.dart';
import '../../define/define.dart';
import '../../define/enum.dart';
import '../../models/article.dart';
import '../../models/coin.dart';
import '../../models/price.dart';
import '../../utils/app.dart';
import '../../utils/util.dart';
import '../wish/wish_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/horse_race_controller.dart';
import '../../main.dart';

class DashBoardController extends GetxController {
  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();

  final isCommentLoading = false.obs;
  final showInput = false.obs;

  final listMaxLength = Define.DEFAULT_BOARD_GET_LENGTH.obs;
  
  // 게시글 데이터 관리
  final RxList<Article> allArticles = <Article>[].obs;
  final RxList<Article> gameNews = <Article>[].obs;
  final RxBool isLoadingAllArticles = false.obs;
  final RxBool isLoadingGameNews = false.obs;

  // 코인 데이터 관리
  final RxList<Coin> coinList = <Coin>[].obs;
  final RxBool isLoadingCoins = false.obs;

  ViewType viewType = ViewType.normal;

  @override
  void onInit() {
    super.onInit();
    logger.i("DashBoardController onInit called");

    // WishController 바인딩
    if (!Get.isRegistered<WishController>()) {
      Get.put(WishController());
    }
    
    // HorseRaceController 바인딩
    if (!Get.isRegistered<HorseRaceController>()) {
      Get.put(HorseRaceController());
    }
  }

  @override
  void onReady() async {
    super.onReady();
    logger.i("DashBoardController onReady called");
    
    // ProfileController 초기화 확인 및 처리
    await _ensureProfileControllerInitialized();
    
    logger.i("Starting DashBoardController init...");
    await init();
    logger.i("DashBoardController init completed");
  }

  /// ProfileController가 초기화되었는지 확인하고, 필요시 초기화합니다.
  Future<void> _ensureProfileControllerInitialized() async {
    try {
      final profileController = ProfileController.to;
      
      // ProfileController가 초기화되지 않았다면 초기화
      if (!profileController.isInitialized.value) {
        logger.i("ProfileController가 초기화되지 않았습니다. 초기화를 시작합니다.");
        
        // 프로필 데이터 로드
        final profile = await App.getProfile();
        
        // ProfileController 초기화
        await profileController.initializeWithProfile(profile);
        
        logger.i("ProfileController 초기화 완료");
      } else {
        logger.i("ProfileController가 이미 초기화되어 있습니다.");
      }
    } catch (e) {
      logger.e("ProfileController 초기화 오류: $e");
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> init() async {
    logger.i("DashBoardController init started");
    
    if (kIsWeb) {
      logger.i(Uri.base.origin);
    }

    // ProfileController를 통해 프로필 데이터 새로고침
    logger.i("Refreshing profile...");
    await ProfileController.to.refreshProfile();
    
    // 게시글 데이터 로딩
    logger.i("Loading all articles...");
    await loadAllArticles();
    logger.i("Loading game news...");
    await loadGameNews();
    
    // 코인 데이터 로딩
    logger.i("Loading coin list...");
    await loadCoinList();
    
    logger.i("DashBoardController init completed successfully");
  }

  void onRefreshLite() async {
    listMaxLength.value = Define.DEFAULT_BOARD_GET_LENGTH;
  }

  void onRefresh() async {
    listMaxLength.value = Define.DEFAULT_BOARD_GET_LENGTH;
    await init();
  }

  void onLoading() async {
    listMaxLength.value = listMaxLength.value + Define.DEFAULT_BOARD_GET_LENGTH;

    await Future.delayed(const Duration(seconds: 1));
  }

  // 자유게시판 게시글 로딩
  Future<void> loadAllArticles() async {
    if (isLoadingAllArticles.value) return;
    
    isLoadingAllArticles.value = true;
    try {
      final articles = await App.getArticleList(
        boardInfo: Arrays.getBoardInfo(Define.BOARD_FREE),
        search: "",
        limit: Define.DEFAULT_DASH_BOARD_GET_LENGTH,
      );
      allArticles.value = articles;
    } catch (e) {
      logger.e("Error loading all articles: $e");
    } finally {
      isLoadingAllArticles.value = false;
    }
  }

  // 게임뉴스 로딩
  Future<void> loadGameNews() async {
    if (isLoadingGameNews.value) return;
    
    isLoadingGameNews.value = true;
    try {
      final articles = await App.getArticleList(
        boardInfo: Arrays.getBoardInfo(Define.BOARD_GAME_NEWS),
        search: "",
        limit: Define.DEFAULT_DASH_BOARD_GET_LENGTH,
      );
      gameNews.value = articles;
    } catch (e) {
      logger.e("Error loading game news: $e");
    } finally {
      isLoadingGameNews.value = false;
    }
  }

  Future<void> loadCoinList() async {
    if (isLoadingCoins.value) return;
    
    isLoadingCoins.value = true;
    try {
      final coins = await App.getCoinList(withoutNoTrade: true);
      coinList.value = coins;
    } catch (e) {
      logger.e("Error loading coin list: $e");
    } finally {
      isLoadingCoins.value = false;
    }
  }

  // 코인 데이터 새로고침
  Future<void> refreshCoins() async {
    await loadCoinList();
  }
}
