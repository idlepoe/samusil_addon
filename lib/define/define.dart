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
  static const double COIN_BUY_FEE_PERCENT = 0;

  static const String MASTER_USER_KEY = "00000000000000000";
  static const String APP_VERSION = "1.0.0";

  static const String FIRESTORE_COLLECTION_PROFILE = "profile";
  static const String FIRESTORE_COLLECTION_WISH = "wish";
  static const String FIRESTORE_COLLECTION_ARTICLE = "article";
  static const String FIRESTORE_COLLECTION_COIN = "coin";
  static String FIRESTORE_FIELD_COMMETS = "comments";
  static String FIRESTORE_FIELD_ALARMS = "alarms";
  static String FIRESTORE_FIELD_PRICE_HISTORY = "price_history";
  static String FIRESTORE_FIELD_COIN_BALANCE = "coin_balance";

  static const int DEFAULT_BOARD_PAGE_LENGTH = 15;
  static const int DEFAULT_DASH_BOARD_GET_LENGTH = 5;
  static const int DEFAULT_BOARD_GET_LENGTH = 30;
  static const double BOTTOM_SHEET_HEIGHT = 65;

  static const Widget APP_DIVIDER = Divider(height: 1);

  static const int INDEX_PROFILE_PAGE = 0;
  static const int INDEX_WISH_PAGE = 1;
  static const int INDEX_BOARD_ALL_PAGE = 2;
  static const int INDEX_BOARD_IT_PAGE = 3;
  static const int INDEX_BOARD_FREE_PAGE = 4;
  static const int INDEX_BOARD_IT_NEWS_PAGE = 5;
  static const int INDEX_BOARD_GAME_NEWS_PAGE = 6;
  static const int INDEX_BOARD_REPORT_PAGE = 7;

  static const String DEV_AD_MOB_BANNER =
      "ca-app-pub-3940256099942544/6300978111";
  static const String PRD_AD_MOB_BANNER =
      "ca-app-pub-3847525926087017/2786411757";
}
