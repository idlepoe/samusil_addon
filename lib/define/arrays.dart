import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../models/board_info.dart';
import 'define.dart';

class Arrays {
  static BoardInfo getBoardInfo(String boardName) {
    switch (boardName) {
      case Define.BOARD_PROFILE:
        return BoardInfo(
          Define.BOARD_PROFILE,
          const Icon(Icons.person_outline),
          "profile",
          "profile",
          false, // 프로필은 작성 불가
        );
      case Define.BOARD_WISH:
        return BoardInfo(
          Define.BOARD_WISH,
          const Icon(LineIcons.magic),
          "wish",
          "wish_description",
          true, // 소원은 작성 가능
        );
      case Define.BOARD_ALL:
        return BoardInfo(
          Define.BOARD_ALL,
          const Icon(LineIcons.frog),
          "all_board",
          "all_board_description",
          true, // 전체게시판은 작성 가능
        );
      case Define.BOARD_IT:
        return BoardInfo(
          Define.BOARD_IT,
          const Icon(LineIcons.infinity),
          "it_board",
          "it_board_description",
          true, // IT게시판은 작성 가능
        );
      case Define.BOARD_FREE:
        return BoardInfo(
          Define.BOARD_FREE,
          const Icon(LineIcons.freebsd),
          "free_board",
          "free_board_description",
          true, // 자유게시판은 작성 가능
        );
      case Define.BOARD_IT_NEWS:
        return BoardInfo(
          Define.BOARD_IT_NEWS,
          const Icon(Icons.computer_outlined),
          "it_news_board",
          "it_news_board_description",
          false, // IT뉴스는 읽기 전용
        );
      case Define.BOARD_GAME_NEWS:
        return BoardInfo(
          Define.BOARD_GAME_NEWS,
          const Icon(LineIcons.gamepad),
          "game_news_board",
          "game_news_board_description",
          false, // 게임뉴스는 읽기 전용
        );
      case Define.BOARD_REPORT:
        return BoardInfo(
          Define.BOARD_REPORT,
          const Icon(LineIcons.bug),
          "report_suggestion_board",
          "report_suggestion_board_description",
          true, // 신고/제안게시판은 작성 가능
        );
      default:
        break;
    }

    return BoardInfo(
      Define.BOARD_PROFILE,
      const Icon(Icons.person_outline),
      "profile",
      "profile",
      false,
    );
  }

  // 하위 호환성을 위한 index 기반 함수 (점진적 마이그레이션용)
  static BoardInfo getBoardInfoByIndex(int index) {
    switch (index) {
      case Define.INDEX_PROFILE_PAGE:
        return getBoardInfo(Define.BOARD_PROFILE);
      case Define.INDEX_WISH_PAGE:
        return getBoardInfo(Define.BOARD_WISH);
      case Define.INDEX_BOARD_ALL_PAGE:
        return getBoardInfo(Define.BOARD_ALL);
      case Define.INDEX_BOARD_IT_PAGE:
        return getBoardInfo(Define.BOARD_IT);
      case Define.INDEX_BOARD_FREE_PAGE:
        return getBoardInfo(Define.BOARD_FREE);
      case Define.INDEX_BOARD_IT_NEWS_PAGE:
        return getBoardInfo(Define.BOARD_IT_NEWS);
      case Define.INDEX_BOARD_GAME_NEWS_PAGE:
        return getBoardInfo(Define.BOARD_GAME_NEWS);
      case Define.INDEX_BOARD_REPORT_PAGE:
        return getBoardInfo(Define.BOARD_REPORT);
      default:
        return getBoardInfo(Define.BOARD_PROFILE);
    }
  }
}
