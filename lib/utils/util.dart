import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

import '../define/define.dart';
import '../define/enum.dart';

class Utils {
  static Future<ImageProvider<Object>> xFileToImage(XFile xFile) async {
    final Uint8List bytes = await xFile.readAsBytes();
    return Image.memory(bytes).image;
  }

  static Future<String> uploadFileToStorage(
    XFile? xFile,
    String fileName,
  ) async {
    var logger = Logger();

    if (xFile == null) {
      return "";
    }

    String result = "";
    try {
      Reference reference = FirebaseStorage.instance.ref().child(
        'images/${basename(xFile.path)}$fileName',
      );
      await reference.putData(await xFile.readAsBytes());
      result = await reference.getDownloadURL();
      logger.i(result);
    } catch (e) {
      logger.e(e.toString());
      return "";
    }

    return result;
  }

  /// 이미지를 Firebase Storage에 업로드하고 다운로드 URL을 반환합니다.
  /// [xFile] 업로드할 이미지 파일
  /// [folder] 저장할 폴더명 (기본값: 'images')
  /// [fileName] 파일명 (기본값: 현재 시간 기반 고유명)
  static Future<String> uploadImageToStorage(
    XFile? xFile, {
    String folder = 'images',
    String? fileName,
  }) async {
    var logger = Logger();

    if (xFile == null) {
      logger.w('업로드할 이미지 파일이 없습니다.');
      return "";
    }

    try {
      // 파일명이 없으면 현재 시간 기반으로 생성
      final String finalFileName =
          fileName ??
          '${Utils.getDateTimeKey()}_${Utils.getRandomString(8)}.jpg';

      Reference reference = FirebaseStorage.instance.ref().child(
        '$folder/$finalFileName',
      );

      // 이미지 압축 및 업로드
      final Uint8List imageBytes = await xFile.readAsBytes();
      await reference.putData(imageBytes);

      final String downloadUrl = await reference.getDownloadURL();
      logger.i('이미지 업로드 성공: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      logger.e('이미지 업로드 실패: ${e.toString()}');
      return "";
    }
  }

  /// Firebase Storage에서 이미지를 삭제합니다.
  /// [imageUrl] 삭제할 이미지의 다운로드 URL
  static Future<bool> deleteImageFromStorage(String imageUrl) async {
    var logger = Logger();

    if (imageUrl.isEmpty) {
      logger.w('삭제할 이미지 URL이 없습니다.');
      return false;
    }

    try {
      // URL에서 참조 생성
      Reference reference = FirebaseStorage.instance.refFromURL(imageUrl);
      await reference.delete();

      logger.i('이미지 삭제 성공: $imageUrl');
      return true;
    } catch (e) {
      logger.e('이미지 삭제 실패: ${e.toString()}');
      return false;
    }
  }

  /// 여러 이미지를 Firebase Storage에서 삭제합니다.
  /// [imageUrls] 삭제할 이미지들의 다운로드 URL 리스트
  static Future<bool> deleteMultipleImagesFromStorage(
    List<String> imageUrls,
  ) async {
    var logger = Logger();

    if (imageUrls.isEmpty) {
      logger.w('삭제할 이미지 URL이 없습니다.');
      return true;
    }

    try {
      for (String imageUrl in imageUrls) {
        if (imageUrl.isNotEmpty) {
          await deleteImageFromStorage(imageUrl);
        }
      }

      logger.i('${imageUrls.length}개 이미지 삭제 완료');
      return true;
    } catch (e) {
      logger.e('다중 이미지 삭제 실패: ${e.toString()}');
      return false;
    }
  }

  static String toConvertFireDateToCommentTime(
    String value, {
    bool bYear = false,
  }) {
    if (value.isEmpty) {
      return "";
    }

    String year = value.substring(0, 4);
    if (year == "0000") {
      return "developer".tr;
    }
    String month = value.substring(4, 6);
    String day = value.substring(6, 8);
    String hh = value.substring(8, 10);
    String mm = value.substring(10, 12);

    return "${bYear ? ("$year/") : ""}$month/$day $hh:$mm";
  }

  static String getStringToday() {
    DateTime today = DateTime.now();
    DateFormat df = DateFormat("yyyy-MM-dd");
    return df.format(today);
  }

  static String getDateTimeKey() {
    DateTime today = DateTime.now();
    DateFormat df = DateFormat('yyyyMMddHHmmssSSS');
    return df.format(today);
  }

  static String getRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    String result = '';
    for (int i = 0; i < length; i++) {
      result += chars[random.nextInt(chars.length)];
    }
    return result;
  }

  static String formatDateTime(DateTime dateTime) {
    DateFormat df = DateFormat('MM/dd HH:mm');
    return df.format(dateTime);
  }

  static Future<void> setLanguage(int language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(Define.SHARED_LANGUAGE, language);
  }

  static Future<int> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String systemLocale = Platform.localeName;
    int systemLanguage = -1;
    if (systemLocale.contains("en")) {
      systemLanguage = 0;
    } else if (systemLocale.contains("ja")) {
      systemLanguage = 2;
    } else {
      systemLanguage = 1;
    }
    int result = prefs.getInt(Define.SHARED_LANGUAGE) ?? systemLanguage;
    return result;
  }

  static Future<List<String>> setAlreadyVote(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> result = prefs.getStringList("vote") ?? [];
    result.add(key);
    await prefs.setStringList("vote", result);
    return result;
  }

  static Future<List<String>> getVote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> result = prefs.getStringList("vote") ?? [];
    return result;
  }

  static Future<bool> checkAlreadyVote(String key) async {
    List<String> list = await getVote();
    String? result = list.firstWhereOrNull((s) => s == key);
    return result != null;
  }

  static String convertMillisecondsSinceEpoch(int text) {
    String result = "";
    try {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(text);
      result = DateFormat('M월dd일H시mm분').format(date);
    } catch (e) {}
    return result;
  }

  static Future<void> sharedPrefClear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<List<String>> setAlreadyWish(String date) async {
    var logger = Logger();
    logger.i("setAlreadyWish");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> result = prefs.getStringList(Define.SHARED_WISH) ?? [];
    result.add(date);
    await prefs.setStringList(Define.SHARED_WISH, result);
    return result;
  }

  static Future<bool> getAlreadyWish() async {
    var logger = Logger();
    // logger.i("checkAlreadyWish");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(Define.SHARED_WISH) ?? [];
    bool result = false;
    for (int i = 0; i < list.length; i++) {
      if (list[i] == Utils.getStringToday()) {
        result = true;
        break;
      }
    }
    return result;
  }

  static void showSnackBar(
    BuildContext context,
    SnackType type,
    String content,
  ) {
    Color snackColor = Colors.green.shade800;
    Color textColor = Colors.white;

    switch (type) {
      case SnackType.info:
        snackColor = Colors.blue;
        textColor = Colors.white;
        break;
      case SnackType.waring:
        snackColor = Colors.orange;
        textColor = Colors.black;
        break;
      case SnackType.error:
        snackColor = Colors.red;
        textColor = Colors.white;
        break;
      case SnackType.success:
        snackColor = Colors.green.shade800;
        textColor = Colors.white;
        break;
      default:
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: snackColor,
        content: Text(content, style: TextStyle(color: textColor)),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  static Future<List<String>> setSearchWord(String search) async {
    var logger = Logger();
    logger.i("saveSearchWord");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> result = prefs.getStringList(Define.SHARED_SEARCH) ?? [];
    result.add(search);
    await prefs.setStringList(Define.SHARED_WISH, result);
    return result;
  }

  static bool isValidateBool(bool? s) {
    return s is bool ? s : false;
  }

  static Future<bool> saveNetworkImage(List<String> list) async {
    bool result = false;
    try {
      for (String row in list) {
        final response = await Dio().get(
          row,
          options: Options(responseType: ResponseType.bytes),
        );
        if (response.statusCode == 200) {
          final saveResult = await ImageGallerySaverPlus.saveImage(
            Uint8List.fromList(response.data),
            name: "app_name".tr,
          );
          if (saveResult['isSuccess'] == true) {
            result = true;
          }
        }
      }
    } catch (e) {
      result = false;
    }
    return result;
  }

  static Future<void> setFontSize(int data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(Define.SHARED_FONT_SIZE, data);
  }

  static Future<int> getFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int result = prefs.getInt(Define.SHARED_FONT_SIZE) ?? 15;
    return result;
  }

  static Color randomColor() {
    List color = [
      Colors.red,
      Colors.orange,
      Colors.amber,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ];
    return (color.toList()..shuffle()).first;
  }

  static String numberFormat(int s) {
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    return myFormat.format(s);
  }

  static bool isValidNilEmptyStr(String? s) {
    return s != null && (s.isNotEmpty);
  }

  static bool isValidNilEmptyDouble(double? s) {
    return s != null;
  }

  static String weekDayString(int index) {
    switch (index) {
      case 1:
        return "monday".tr;
      case 2:
        return "tuesday".tr;
      case 3:
        return "wednesday".tr;
      case 4:
        return "thursday".tr;
      case 5:
        return "friday".tr;
      case 6:
        return "saturday".tr;
    }
    return "sunday".tr;
  }

  static Color weekDayColor(int index) {
    switch (index) {
      case 6:
        return Colors.blue;
      case 7:
        return Colors.red;
    }
    return Colors.black.withOpacity(0.8);
  }

  static double diffPercentage(double i1, double i2) {
    return (i1 - i2) / ((i1 + i2) / 2) * 100;
  }

  static bool containFromArray(String target, List<String> list) {
    bool isExist = false;
    for (String s in list) {
      if (target.toLowerCase().contains(s.toLowerCase())) {
        isExist = true;
      }
    }
    return isExist;
  }

  static List<String> multiSplit(String s, Iterable<String> delimeters) {
    return delimeters.isEmpty
        ? [s]
        : s.split(RegExp(delimeters.map(RegExp.escape).join('|')));
  }

  static String toConvertFireDateToCommentTimeToday(String value) {
    DateTime today = DateTime.now();
    DateFormat todayDf = DateFormat("yyyyMMdd");
    String todayYmd = todayDf.format(today);

    bool isToday = true;

    String year = value.substring(0, 4);
    String month = value.substring(4, 6);
    String day = value.substring(6, 8);
    String hh = value.substring(8, 10);
    String mm = value.substring(10, 12);
    if (year == "0000") {
      return "developer".tr;
    }

    if (int.parse(year + month + day) < int.parse(todayYmd)) {
      isToday = false;
    }

    return isToday ? "$hh:$mm" : "$month/$day";
  }

  static int convertTime(String duration) {
    RegExp regex = new RegExp(r'(\d+)');
    List<String> a =
        regex.allMatches(duration).map((e) => e.group(0)!).toList();

    if (duration.indexOf('M') >= 0 &&
        duration.indexOf('H') == -1 &&
        duration.indexOf('S') == -1) {
      a = ["0", a[0], "0"];
    }

    if (duration.indexOf('H') >= 0 && duration.indexOf('M') == -1) {
      a = [a[0], "0", a[1]];
    }
    if (duration.indexOf('H') >= 0 &&
        duration.indexOf('M') == -1 &&
        duration.indexOf('S') == -1) {
      a = [a[0], "0", "0"];
    }

    int seconds = 0;

    if (a.length == 3) {
      seconds = seconds + int.parse(a[0]) * 3600;
      seconds = seconds + int.parse(a[1]) * 60;
      seconds = seconds + int.parse(a[2]);
    }

    if (a.length == 2) {
      seconds = seconds + int.parse(a[0]) * 60;
      seconds = seconds + int.parse(a[1]);
    }

    if (a.length == 1) {
      seconds = seconds + int.parse(a[0]);
    }
    return seconds;
  }
}
