import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../models/board_info.dart';
import 'define.dart';

class Arrays {
  static BoardInfo getBoardInfo(int index) {
    switch (index) {
      case 0:
        return BoardInfo(
          Define.INDEX_PROFILE_PAGE,
          const Icon(Icons.person_outline),
          "profile",
          "profile",
          false,
        );
      case 1:
        return BoardInfo(
            1, const Icon(LineIcons.magic), "wish", "wish_description", false);
      case 2:
        return BoardInfo(Define.INDEX_BOARD_ALL_PAGE, const Icon(LineIcons.frog), "all_board",
            "all_board_description", true);
      case 3:
        return BoardInfo(Define.INDEX_BOARD_IT_PAGE, const Icon(LineIcons.infinity), "it_board",
            "it_board_description", true);
      case 4:
        return BoardInfo(Define.INDEX_BOARD_FREE_PAGE, const Icon(LineIcons.freebsd), "free_board",
            "free_board_description", true);
      case 5:
        return BoardInfo(Define.INDEX_BOARD_IT_NEWS_PAGE, const Icon(Icons.computer_outlined), "it_news_board",
            "it_news_board_description", false);
      case 6:
        return BoardInfo(Define.INDEX_BOARD_GAME_NEWS_PAGE, const Icon(LineIcons.gamepad), "game_news_board",
            "game_news_board_description", false);
      case 7:
        return BoardInfo(Define.INDEX_BOARD_REPORT_PAGE, const Icon(LineIcons.bug), "report_suggestion_board",
            "report_suggestion_board_description", true);
      default:
        break;
    }

    return BoardInfo(
      Define.INDEX_PROFILE_PAGE,
      const Icon(Icons.person_outline),
      "profile",
      "profile",
      false,
    );
  }
}
