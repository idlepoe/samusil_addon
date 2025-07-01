import 'package:flutter/material.dart';

class Define {
  static const Color APP_MAIN_COLOR = Colors.lightBlue;
  static const String FIRESTORE_ERROR_CODE_NOT_FOUND = "not-found";
  static const Color APP_BAR_BACKGROUND_COLOR = Colors.white;
  static const Color APP_BAR_TITLE_TEXT_COLOR = Colors.black;
  static const Color APP_TITLE_TEXT_COLOR = Colors.black;
  static const Color APP_TITLE_DRAW_BUTTON_TEXT_COLOR = Colors.white;

  static const String SHARED_PROFILE = "shared_profile";
  static const String SHARED_WISH = "shared_wish";
  static const String SHARED_SEARCH = "shared_search";
  static const String SHARED_FONT_SIZE = "shared_font_size";
  static const String SHARED_LANGUAGE = "shared_language";

  static const double POINT_WISH = 5;
  static const double POINT_WRITE_ARTICLE = 3;
  static const double POINT_WRITE_COMMENT = 1;
  static const double POINT_RECEIVE_LIKE = 2;
  static const double POINT_LIKE = 1;

  static const String FIRESTORE_COLLECTION_PROFILE = "profile";
  static const String FIRESTORE_COLLECTION_WISH = "wish";
  static const String FIRESTORE_COLLECTION_ARTICLE = "article";
  static const String FIRESTORE_COLLECTION_TRACK_ARTICLE = "track_articles";
  static const String FIRESTORE_COLLECTION_HORSE_RACE = "horse_races";
  static String FIRESTORE_FIELD_COMMETS = "comments";
  static String FIRESTORE_FIELD_ALARMS = "alarms";

  static const int DEFAULT_BOARD_PAGE_LENGTH = 15;
  static const int DEFAULT_DASH_BOARD_GET_LENGTH = 5;
  static const int DEFAULT_BOARD_GET_LENGTH = 30;
  static const double BOTTOM_SHEET_HEIGHT = 65;

  static const Widget APP_DIVIDER = Divider(height: 1);

  // Board names (문자열 기반)
  static const String BOARD_PROFILE = "profile";
  static const String BOARD_WISH = "wish";
  static const String BOARD_ALL = "all";
  static const String BOARD_FREE = "free";
  static const String BOARD_GAME_NEWS = "game_news";
  static const String BOARD_ENTERTAINMENT_NEWS = "entertainment_news";
  static const String BOARD_REPORT = "report_suggestion";

  // Cloud Functions URL 설정 (Cloud Run Functions 형식)
  // 각 함수별로 완전한 URL 정의
  static const String CLOUD_FUNCTIONS_BASE_URL =
      'https://moqfvmeufa-du.a.run.app';

  // 함수별 URL 매핑
  static const Map<String, String> FUNCTION_URLS = {
    // us-central1 리전 함수들
    'manualSeoulMuseumSync':
        'https://manualseoulmuseumsync-moqfvmeufa-uc.a.run.app',
    'getWish': 'https://getwish-moqfvmeufa-uc.a.run.app',
    'createWish': 'https://createwish-moqfvmeufa-uc.a.run.app',
    'createAvatarPurchase':
        'https://createavatarpurchase-moqfvmeufa-uc.a.run.app',
    'getArticleList': 'https://getarticlelist-moqfvmeufa-uc.a.run.app',
    'createArtworkPurchase':
        'https://createartworkpurchase-moqfvmeufa-uc.a.run.app',
    'createArticle': 'https://createarticle-moqfvmeufa-uc.a.run.app',
    'unlockTitle': 'https://unlocktitle-moqfvmeufa-uc.a.run.app',
    'getArticleDetail': 'https://getarticledetail-moqfvmeufa-uc.a.run.app',
    'createRandomArtworkPurchase':
        'https://createrandomartworkpurchase-moqfvmeufa-uc.a.run.app',
    'setSelectedTitle': 'https://setselectedtitle-moqfvmeufa-uc.a.run.app',
    'placeBet': 'https://placebet-moqfvmeufa-uc.a.run.app',

    // asia-northeast3 리전 함수들
    'deleteComment': 'https://deletecomment-moqfvmeufa-du.a.run.app',
    'toggleLike': 'https://togglelike-moqfvmeufa-du.a.run.app',
    'deleteArticle': 'https://deletearticle-moqfvmeufa-du.a.run.app',
    'getTrackArticleDetail':
        'https://gettrackarticledetail-moqfvmeufa-du.a.run.app',
    'getTrackArticleList':
        'https://gettrackarticlelist-moqfvmeufa-du.a.run.app',
    'updateArticle': 'https://updatearticle-moqfvmeufa-du.a.run.app',
    'deleteTrackArticle': 'https://deletetrackarticle-moqfvmeufa-du.a.run.app',
    'toggleTrackArticleLike':
        'https://toggletrackarticlelike-moqfvmeufa-du.a.run.app',
    'updatePoints': 'https://updatepoints-moqfvmeufa-du.a.run.app',
    'updateTrackArticle': 'https://updatetrackarticle-moqfvmeufa-du.a.run.app',
    'manualNewsCollection':
        'https://manualnewscollection-moqfvmeufa-du.a.run.app',
    'createComment': 'https://createcomment-moqfvmeufa-du.a.run.app',
    'manualEntertainmentNewsCollection':
        'https://manualentertainmentnewscollection-moqfvmeufa-du.a.run.app',
    'createTrackArticle': 'https://createtrackarticle-moqfvmeufa-du.a.run.app',
  };
}
