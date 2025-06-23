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
          "프로필",
          "profile",
          false, // 프로필은 작성 불가
        );
      case Define.BOARD_WISH:
        return BoardInfo(
          Define.BOARD_WISH,
          const Icon(LineIcons.magic),
          "소원",
          "wish_description",
          true, // 소원은 작성 가능
        );
      case Define.BOARD_ALL:
        return BoardInfo(
          Define.BOARD_ALL,
          const Icon(LineIcons.frog),
          "전체 게시판",
          "all_board_description",
          true, // 전체게시판은 작성 가능
        );
      case Define.BOARD_FREE:
        return BoardInfo(
          Define.BOARD_FREE,
          const Icon(LineIcons.freebsd),
          "잡담 게시판",
          "free_board_description",
          true, // 자유게시판은 작성 가능
        );
      case Define.BOARD_GAME_NEWS:
        return BoardInfo(
          Define.BOARD_GAME_NEWS,
          const Icon(LineIcons.gamepad),
          "게임 뉴스",
          "game_news_board_description",
          false, // 게임뉴스는 읽기 전용
        );
      case Define.BOARD_ENTERTAINMENT_NEWS:
        return BoardInfo(
          Define.BOARD_ENTERTAINMENT_NEWS,
          const Icon(LineIcons.heart),
          "연예 뉴스",
          "entertainment_news_board_description",
          false, // 연예뉴스는 읽기 전용
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
}
