enum AlarmTargetKeyType {
  article,
  comment;

  int get intValue => index + 1;
}

enum SnackType {
  info,
  waring,
  error,
  success,
}

enum ViewType { normal, notice, popular }

enum PopupItem { itemOne, itemTwo, itemThree }
