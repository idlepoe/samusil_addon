import 'dart:convert';
import 'dart:io';

// import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:samusil_addon/models/coin_balance.dart';
import 'package:samusil_addon/models/main_comment.dart';
import 'package:samusil_addon/utils/util.dart';
import 'package:samusil_addon/utils/http_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart' hide Response;

import '../define/define.dart';
import '../define/enum.dart';
import '../models/alarm.dart';
import '../models/article.dart';
import '../models/board_info.dart';
import '../models/coin.dart';
import '../models/coin_price.dart';
import '../models/price.dart';
import '../models/profile.dart';
import '../models/wish.dart';
import '../models/point_history.dart';
import '../main.dart';

class App {
  /// Cloud Functions baseUrl 설정
  ///
  /// 사용 예시:
  /// App.setCloudFunctionsBaseUrl('https://your-region-your-project.cloudfunctions.net');
  ///
  /// 배포 후 실제 Cloud Functions URL로 설정해야 합니다.
  /// 예: https://asia-northeast3-samusil-addon.cloudfunctions.net
  static void setCloudFunctionsBaseUrl(String baseUrl) {
    HttpService().setBaseUrl(baseUrl);
  }

  static Future<Profile> getLocaleProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Profile result = Profile.init();
    String? encodeUser = prefs.getString(Define.SHARED_PROFILE);
    if (encodeUser == null) {
      result = await App.createDBProfile();
    } else {
      result = Profile.fromJson(jsonDecode(encodeUser));
    }
    return result;
  }

  static Future<void> setLocaleProfile(Profile user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Define.SHARED_PROFILE, json.encode(user));
  }

  static Profile createCommonProfile() {
    Profile user = Profile.init();
    user = user.copyWith(
      uid: "", // Firebase Auth UID로 설정될 예정
      name: "anon".tr + Utils.getRandomString(5),
    );
    return user;
  }

  static Future<Profile> createDBProfile() async {
    Profile user = createCommonProfile();
    try {
      // Firebase Auth UID 가져오기
      final fireUser = FirebaseAuth.instance.currentUser;
      if (fireUser == null) {
        throw Exception('Firebase Auth user not found');
      }

      user = user.copyWith(uid: fireUser.uid);

      final colRef = FirebaseFirestore.instance.collection(
        Define.FIRESTORE_COLLECTION_PROFILE,
      );
      await colRef
          .doc(user.uid)
          .set(user.toJson())
          .then(
            (value) async {
              await setLocaleProfile(user);
            },
            onError: (e) async {
              logger.e(e);
            },
          );
    } catch (e) {
      logger.e(e);
    }
    return user;
  }

  static Future<bool> checkDBProfile(String uid) async {
    bool result = false;
    try {
      var collection = FirebaseFirestore.instance.collection(
        Define.FIRESTORE_COLLECTION_PROFILE,
      );
      var docSnapshot = await collection.doc(uid).get();
      if (docSnapshot.exists) {
        result = true;
      }
    } catch (e) {
      logger.e(e);
    }
    return result;
  }

  static Future<Profile> getProfile() async {
    Profile result = await getLocaleProfile();
    try {
      // Firebase Auth UID 가져오기
      final fireUser = FirebaseAuth.instance.currentUser;
      if (fireUser == null) {
        throw Exception('Firebase Auth user not found');
      }

      result = result.copyWith(uid: fireUser.uid);

      var collection = FirebaseFirestore.instance.collection(
        Define.FIRESTORE_COLLECTION_PROFILE,
      );
      var docSnapshot = await collection.doc(result.uid).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        result = Profile.fromJson(data!);
      } else {
        result = await createDBProfile();
      }
    } catch (e) {
      logger.e(e);
    }
    return result;
  }

  static Future<bool> updateProfilePicture(Profile profile) async {
    bool result = true;
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_PROFILE)
        .doc(profile.uid);

    await docRef
        .update({"photo_url": profile.photo_url})
        .then(
          (value) async {
            result = true;
          },
          onError: (e) async {
            logger.e(e);
            result = false;
          },
        );
    return result;
  }

  static Future<bool> updateProfileName(Profile profile) async {
    bool result = true;
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_PROFILE)
        .doc(profile.uid);

    await docRef
        .update({"name": profile.name})
        .then(
          (value) async {
            result = true;
          },
          onError: (e) async {
            logger.e(e);
            result = false;
          },
        );
    return result;
  }

  static Future<bool> updateProfileOneComment(Profile profile) async {
    bool result = true;
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_PROFILE)
        .doc(profile.uid);
    await docRef
        .update({"one_comment": profile.one_comment})
        .then(
          (value) async {
            result = true;
          },
          onError: (e) async {
            logger.e(e);
            result = false;
          },
        );
    return result;
  }

  static Future<List<Wish>> getWishList() async {
    String sToday = Utils.getStringToday();
    logger.i(sToday);
    List<Wish> result = [];
    try {
      final docRef =
          await FirebaseFirestore.instance
              .collection(Define.FIRESTORE_COLLECTION_WISH)
              .doc(sToday)
              .get();
      int index = 1;
      for (dynamic s in docRef.get("list")) {
        Wish row = Wish.fromJson(s);
        row = row.copyWith(index: index);
        result.add(row);
        index++;
      }
    } catch (e) {
      logger.e(e);
    }
    logger.d("getWish");
    return result.toList();
  }

  static Future<int> getTotalWishCount() async {
    int result = 0;
    try {
      final docRef =
          await FirebaseFirestore.instance
              .collection(Define.FIRESTORE_COLLECTION_WISH)
              .count()
              .get();
      result = docRef.count ?? 0;
    } catch (e) {
      logger.e(e);
    }
    logger.d("getTotalWishCount");
    return result;
  }

  static Future<bool> checkAlreadyWish() async {
    List<Wish> wishList = await getWishList();
    Profile profile = await App.getProfile();
    bool result = false;
    for (int i = 0; i < wishList.length; i++) {
      if (wishList[i].uid == profile.uid) {
        result = true;
        break;
      }
    }
    return result;
  }

  static Future<void> countUpWishStreak(Profile profile) async {
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_PROFILE)
        .doc(profile.uid);
    await docRef
        .update({"wish_streak": FieldValue.increment(1)})
        .then(
          (value) async {},
          onError: (e) async {
            if (e.code == Define.FIRESTORE_ERROR_CODE_NOT_FOUND) {
              await docRef
                  .set({"countView": 1})
                  .then(
                    (value) {},
                    onError: (e) {
                      logger.e(e);
                    },
                  );
            } else {
              logger.e(e);
            }
          },
        );
  }

  static Future<List<Article>> getArticleList({
    required BoardInfo boardInfo,
    required String search,
    required int limit,
  }) async {
    List<Article> result = [];

    try {
      final httpService = HttpService();
      final params = {
        'board_name': boardInfo.board_name,
        'search': search,
        'limit': limit,
        'is_popular': boardInfo.isPopular,
        'is_notice': boardInfo.isNotice,
        'exclude_news': boardInfo.board_name == Define.BOARD_ALL,
      };

      final response = await httpService.getArticleList(params: params);

      if (response.isSuccess) {
        if (response.data != null) {
          result =
              response.data!.map((json) => Article.fromJson(json)).toList();
        } else {
          result = [];
        }
      } else {
        logger.e("getArticleList failed: ${response.error}");
      }
    } catch (e) {
      logger.e("getArticleList exception: $e");
    }

    result.sort((a, b) => b.id.compareTo(a.id));
    return result;
  }

  static Future<Article> getArticle({required String id}) async {
    Article result = Article(
      id: "",
      board_name: "",
      profile_uid: "",
      profile_name: "",
      profile_photo_url: "",
      count_view: 0,
      count_like: 0,
      count_unlike: 0,
      count_comments: 0,
      title: "",
      contents: [],
      created_at: DateTime.now(),
      is_notice: false,
    );
    try {
      final httpService = HttpService();
      final response = await httpService.getArticle(id: id);

      if (response.isSuccess) {
        result = Article.fromJson(response.data!);
      } else {
        logger.w("no article:$id");
      }
    } catch (e) {
      logger.w(e);
    }
    return result;
  }

  static Future<String?> createArticle({required Article article}) async {
    try {
      final articleData = {
        'board_name': article.board_name,
        'profile_uid': article.profile_uid,
        'profile_name': article.profile_name,
        'profile_photo_url': article.profile_photo_url,
        'count_view': article.count_view,
        'count_like': article.count_like,
        'count_unlike': article.count_unlike,
        'title': article.title,
        'contents':
            article.contents.map((content) => content.toJson()).toList(),
        'is_notice': article.is_notice,
        'thumbnail': article.thumbnail,
      };

      logger.d("createArticle articleData: $articleData");

      final httpService = HttpService();
      final response = await httpService.createArticle(
        articleData: articleData,
      );

      logger.d("createArticle response: ${response.data}");

      if (response.isSuccess) {
        // 생성된 게시글의 ID 반환
        return response.data?['id'] as String?;
      } else {
        logger.e("createArticle failed: ${response.error}");
      }
    } catch (e) {
      logger.e("createArticle exception: $e");
    }

    return null;
  }

  static Future<Map<String, dynamic>> createWish({
    required String comment,
  }) async {
    Map<String, dynamic> result = {};

    try {
      final httpService = HttpService();
      final response = await httpService.createWish(comment: comment);

      if (response.isSuccess) {
        result = response.data!;
      } else {
        result['success'] = false;
        result['error'] = response.error ?? '소원 생성에 실패했습니다.';
        logger.e("createWish failed: ${response.error}");
      }
    } catch (e) {
      result['success'] = false;
      result['error'] = '소원 생성 중 오류가 발생했습니다.';
      logger.e("createWish exception: $e");
    }

    return result;
  }

  static Future<List<MainComment>> createComment({
    required Article article,
    required MainComment comment,
  }) async {
    List<MainComment> result = [];

    try {
      final httpService = HttpService();

      // comment 객체에 profile_uid와 profile_photo_url 추가
      final commentData = {
        ...comment.toJson(),
        'profile_uid': comment.profile_uid,
        'profile_photo_url': comment.profile_photo_url,
      };

      final response = await httpService.createComment(
        articleId: article.id,
        commentData: commentData,
      );

      if (response.isSuccess) {
        // response.data는 { success: true, data: comments } 구조
        final commentsData = response.data!['data'] as List<dynamic>;
        result =
            commentsData.map((json) {
              // created_at이 Timestamp 객체인 경우 DateTime으로 변환
              if (json['created_at'] is Map<String, dynamic>) {
                final timestamp = json['created_at'] as Map<String, dynamic>;
                if (timestamp.containsKey('_seconds')) {
                  final seconds = timestamp['_seconds'] as int;
                  final nanoseconds = timestamp['_nanoseconds'] as int? ?? 0;
                  json['created_at'] =
                      DateTime.fromMillisecondsSinceEpoch(
                        seconds * 1000 + (nanoseconds / 1000000).round(),
                      ).toIso8601String();
                }
              }
              return MainComment.fromJson(json);
            }).toList();
      } else {
        logger.e("createComment failed: ${response.error}");
      }
    } catch (e) {
      logger.e("createComment exception: $e");
    }

    return result;
  }

  static Future<List<MainComment>> getComments({required String id}) async {
    List<MainComment> result = [];
    try {
      final commentsSnapshot =
          await FirebaseFirestore.instance
              .collection(Define.FIRESTORE_COLLECTION_ARTICLE)
              .doc(id)
              .collection('comments')
              .orderBy('created_at', descending: false)
              .get();

      for (var doc in commentsSnapshot.docs) {
        result.add(MainComment.fromJson({'id': doc.id, ...doc.data()}));
      }
    } catch (e) {
      logger.w("no comment: $e");
    }
    return result;
  }

  static Future<int> articleCountLikeUp({required String id}) async {
    int result = 0;
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_ARTICLE)
        .doc(id);
    await docRef
        .update({"count_like": FieldValue.increment(1)})
        .then(
          (value) async {},
          onError: (e) async {
            if (e.code == Define.FIRESTORE_ERROR_CODE_NOT_FOUND) {
              await docRef
                  .set({"count_like": 1})
                  .then(
                    (value) {},
                    onError: (e) {
                      logger.e(e);
                    },
                  );
            } else {
              logger.e(e);
            }
          },
        );
    final refGet = await docRef.get();
    result = refGet.get("count_like");
    return result;
  }

  static Future<int> articleCountUnLikeUp({required String id}) async {
    int result = 0;
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_ARTICLE)
        .doc(id);
    await docRef
        .update({"count_unlike": FieldValue.increment(1)})
        .then(
          (value) async {},
          onError: (e) async {
            if (e.code == Define.FIRESTORE_ERROR_CODE_NOT_FOUND) {
              await docRef
                  .set({"count_unlike": 1})
                  .then(
                    (value) {},
                    onError: (e) {
                      logger.e(e);
                    },
                  );
            } else {
              logger.e(e);
            }
          },
        );
    final refGet = await docRef.get();
    result = refGet.get("count_unlike");
    return result;
  }

  static Future<List<MainComment>> deleteComment({
    required String articleId,
    required MainComment comment,
  }) async {
    List<MainComment> result = [];

    try {
      final httpService = HttpService();
      final response = await httpService.deleteComment(
        articleId: articleId,
        commentId: comment.id,
      );

      if (response.isSuccess && response.data != null) {
        // response.data는 { success: true, data: comments } 구조
        final commentsData = response.data!['data'] as List<dynamic>;
        result =
            commentsData.map((json) {
              // created_at이 Timestamp 객체인 경우 DateTime으로 변환
              if (json['created_at'] is Map<String, dynamic>) {
                final timestamp = json['created_at'] as Map<String, dynamic>;
                if (timestamp.containsKey('_seconds')) {
                  final seconds = timestamp['_seconds'] as int;
                  final nanoseconds = timestamp['_nanoseconds'] as int? ?? 0;
                  json['created_at'] =
                      DateTime.fromMillisecondsSinceEpoch(
                        seconds * 1000 + (nanoseconds / 1000000).round(),
                      ).toIso8601String();
                }
              }
              return MainComment.fromJson(json);
            }).toList();
        Get.snackbar(
          '성공',
          '댓글이 삭제되었습니다.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        logger.e("deleteComment failed: ${response.error}");
        Get.snackbar(
          '오류',
          '댓글 삭제에 실패했습니다.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      logger.e("deleteComment exception: $e");
      Get.snackbar(
        '오류',
        '댓글 삭제 중 오류가 발생했습니다.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    return result;
  }

  static Future<List<MainComment>> deleteCommentByIndex({
    required String articleId,
    required int index,
  }) async {
    List<MainComment> result = [];

    try {
      // 먼저 현재 댓글 목록을 가져와서 해당 인덱스의 댓글 키를 찾습니다
      final commentsSnapshot =
          await FirebaseFirestore.instance
              .collection(Define.FIRESTORE_COLLECTION_ARTICLE)
              .doc(articleId)
              .collection('comments')
              .orderBy('created_at', descending: false)
              .get();

      if (commentsSnapshot.docs.isNotEmpty &&
          index >= 0 &&
          index < commentsSnapshot.docs.length) {
        final commentToDelete = MainComment.fromJson({
          'id': commentsSnapshot.docs[index].id,
          ...commentsSnapshot.docs[index].data(),
        });

        // Cloud Functions를 사용하여 댓글 삭제
        final httpService = HttpService();
        final response = await httpService.deleteComment(
          articleId: articleId,
          commentId: commentToDelete.id,
        );

        if (response.isSuccess && response.data != null) {
          // response.data는 { success: true, data: comments } 구조
          final commentsData = response.data!['data'] as List<dynamic>;
          result =
              commentsData.map((json) {
                // created_at이 Timestamp 객체인 경우 DateTime으로 변환
                if (json['created_at'] is Map<String, dynamic>) {
                  final timestamp = json['created_at'] as Map<String, dynamic>;
                  if (timestamp.containsKey('_seconds')) {
                    final seconds = timestamp['_seconds'] as int;
                    final nanoseconds = timestamp['_nanoseconds'] as int? ?? 0;
                    json['created_at'] =
                        DateTime.fromMillisecondsSinceEpoch(
                          seconds * 1000 + (nanoseconds / 1000000).round(),
                        ).toIso8601String();
                  }
                }
                return MainComment.fromJson(json);
              }).toList();
        } else {
          logger.e("deleteCommentByIndex failed: ${response.error}");
        }
      } else {
        logger.e("Invalid comment index: $index");
      }
    } catch (e) {
      logger.e("deleteCommentByIndex exception: $e");
    }

    return result;
  }

  static Future<void> createAlarm({
    required String profileKey,
    required Alarm alarm,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection(Define.FIRESTORE_COLLECTION_PROFILE)
          .doc(profileKey);
      await docRef
          .update({
            Define.FIRESTORE_FIELD_ALARMS: FieldValue.arrayUnion([
              alarm.toJson(),
            ]),
          })
          .then(
            (value) async {
              // 알림 생성 성공
            },
            onError: (e) async {
              if (e.code == Define.FIRESTORE_ERROR_CODE_NOT_FOUND) {
                await docRef
                    .set({
                      Define.FIRESTORE_FIELD_ALARMS: [alarm.toJson()],
                    })
                    .then(
                      (value) async {
                        // 알림 생성 성공
                      },
                      onError: (e) {
                        logger.e(e);
                      },
                    );
              } else {
                logger.e(e);
              }
            },
          );
    } catch (e) {
      logger.e(e);
    }
  }

  static Future<void> readAlarm({
    required String profileKey,
    required Alarm alarm,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection(Define.FIRESTORE_COLLECTION_PROFILE)
          .doc(profileKey);
      await docRef
          .update({
            Define.FIRESTORE_FIELD_ALARMS: FieldValue.arrayRemove([
              alarm.toJson(),
            ]),
          })
          .then(
            (value) async {
              final updatedAlarm = alarm.copyWith(is_read: true);
              await docRef.update({
                Define.FIRESTORE_FIELD_ALARMS: FieldValue.arrayUnion([
                  updatedAlarm.toJson(),
                ]),
              });
            },
            onError: (e) async {
              logger.e(e);
            },
          );
    } catch (e) {
      logger.e(e);
    }
  }

  static Future<void> deleteAlarm({
    required String profileKey,
    required Alarm alarm,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection(Define.FIRESTORE_COLLECTION_PROFILE)
          .doc(profileKey);
      await docRef
          .update({
            Define.FIRESTORE_FIELD_ALARMS: FieldValue.arrayRemove([
              alarm.toJson(),
            ]),
          })
          .then(
            (value) async {
              // 알림 삭제 성공
            },
            onError: (e) async {
              logger.e(e);
            },
          );
    } catch (e) {
      logger.e(e);
    }
  }

  static Future<Profile> checkUser() async {
    User? fireUser = FirebaseAuth.instance.currentUser;
    Profile result = Profile.init();
    if (fireUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
      result = await App.createDBProfile();
    } else {
      result = await App.getProfile();
    }
    return result;
  }

  static Future<List<Profile>> getProfileList() async {
    List<Profile> result = [];

    try {
      final collectionRef = FirebaseFirestore.instance
          .collection(Define.FIRESTORE_COLLECTION_PROFILE)
          .orderBy("point", descending: true)
          .where("point", isNotEqualTo: 0);

      QuerySnapshot querySnapshot = await collectionRef.get();

      List<Map<String, dynamic>> allData =
          querySnapshot.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();
      for (var i = 0; i < allData.length; i++) {
        Profile v = Profile.fromJson(allData[i]);
        if (v.name.isEmpty) {
          continue;
        }
        result.add(v);
      }
    } catch (e) {
      logger.e(e);
    }
    return result;
  }

  static Future<List<Coin>> getCoinListFromPaprika(BuildContext context) async {
    List<Coin> list = [];

    final response = await get(
      Uri.parse("https://api.coinpaprika.com/v1/coins"),
    );

    switch (response.statusCode) {
      case 200:
        List<dynamic> result = jsonDecode(utf8.decode(response.bodyBytes));
        for (int i = 0; i < 20; i++) {
          list.add(Coin.fromJson(result[i]));
        }
        break;
      default:
        break;
    }

    await createCoinList(context, list);

    Utils.showSnackBar(
      context,
      SnackType.info,
      "${"process_end".tr} : ${"coin_market_list_board".tr}",
    );

    return [];
  }

  static Future<void> createCoinList(
    BuildContext context,
    List<Coin> list,
  ) async {
    try {
      for (Coin row in list) {
        final docRef = FirebaseFirestore.instance
            .collection(Define.FIRESTORE_COLLECTION_COIN)
            .doc(row.id);
        await docRef
            .set(row.toJson())
            .then(
              (value) async {},
              onError: (e) async {
                logger.e(e);
              },
            );
      }
    } catch (e) {
      logger.e(e);
    }
  }

  static Future<List<Coin>> getCoinPriceFromPaprika(
    BuildContext context,
  ) async {
    Utils.showSnackBar(
      context,
      SnackType.info,
      "${"process_start".tr} : ${"point_market".tr}",
    );

    try {
      final httpService = HttpService();

      final response = await httpService.callCloudFunction(
        'updateCoinPrice',
        data: {},
      );

      if (response['success']) {
        Utils.showSnackBar(
          context,
          SnackType.success,
          "${"process_end".tr} : ${"point_market".tr}",
        );
      } else {
        Utils.showSnackBar(
          context,
          SnackType.error,
          "error_update_coin_price".tr,
        );
      }
    } catch (e) {
      Utils.showSnackBar(
        context,
        SnackType.error,
        "error_update_coin_price".tr,
      );
    }

    return [];
  }

  static Future<List<Coin>> getCoinList({withoutNoTrade = false}) async {
    List<Coin> result = [];

    try {
      final httpService = HttpService();
      final response = await httpService.getCoinList(
        params: {'withoutNoTrade': withoutNoTrade},
      );

      if (response.isSuccess) {
        result = response.data!.map((json) => Coin.fromJson(json)).toList();
      } else {
        logger.e("getCoinList failed: ${response.error}");
      }
    } catch (e) {
      logger.e("getCoinList exception: $e");
    }

    return result;
  }

  /// 코인 심볼의 첫 글자를 대문자로 바꿔서 원형 아이콘으로 표시하는 위젯을 생성합니다.
  /// [symbol] 코인 심볼 (예: "btc", "eth")
  /// [size] 아이콘 크기 (기본값: 16)
  /// [backgroundColor] 배경색 (기본값: 자동 생성)
  static Widget buildCoinIcon(
    String symbol, {
    double size = 16,
    Color? backgroundColor,
  }) {
    final firstLetter = symbol.isNotEmpty ? symbol[0].toUpperCase() : '?';
    final iconColor = backgroundColor ?? _generateColorFromString(symbol);
    final textColor = _getContrastColor(iconColor);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
      child: Center(
        child: Text(
          firstLetter,
          style: TextStyle(
            color: textColor,
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// 배경색에 대비되는 텍스트 색깔을 반환합니다.
  /// [backgroundColor] 배경색
  static Color _getContrastColor(Color backgroundColor) {
    // 밝기 계산 (YIQ 공식 사용)
    double yiq =
        ((backgroundColor.red * 299) +
            (backgroundColor.green * 587) +
            (backgroundColor.blue * 114)) /
        1000;

    // 밝기가 128보다 크면 검은색, 작으면 흰색 반환
    return yiq >= 128 ? Colors.black : Colors.white;
  }

  /// 문자열로부터 유니크한 색깔을 생성합니다.
  /// [text] 색깔을 생성할 문자열
  /// [saturation] 채도 (0.0 ~ 1.0, 기본값: 0.7)
  /// [brightness] 명도 (0.0 ~ 1.0, 기본값: 0.8)
  static Color _generateColorFromString(
    String text, {
    double saturation = 0.7,
    double brightness = 0.8,
  }) {
    // 미리 정의된 보기 좋은 색깔 팔레트
    final List<Color> colorPalette = [
      const Color(0xFF0064FF), // 파란색
      const Color(0xFF00C851), // 초록색
      const Color(0xFFFF5252), // 빨간색
      const Color(0xFFFF9800), // 주황색
      const Color(0xFF9C27B0), // 보라색
      const Color(0xFFE91E63), // 분홍색
      const Color(0xFF795548), // 갈색
      const Color(0xFF607D8B), // 회청색
      const Color(0xFF4CAF50), // 연두색
      const Color(0xFF2196F3), // 하늘색
      const Color(0xFFFF5722), // 주황빨강
      const Color(0xFF673AB7), // 진보라
      const Color(0xFF3F51B5), // 인디고
      const Color(0xFF009688), // 청록색
      const Color(0xFFFFC107), // 노란색
      const Color(0xFF8BC34A), // 연한 초록
      const Color(0xFFFFEB3B), // 밝은 노란색
      const Color(0xFF00BCD4), // 청록색
      const Color(0xFF9E9E9E), // 회색
      const Color(0xFFCDDC39), // 라임색
    ];

    // 문자열의 해시값 생성
    int hash = 0;
    for (int i = 0; i < text.length; i++) {
      hash = text.codeUnitAt(i) + ((hash << 5) - hash);
    }

    // 해시값을 팔레트 인덱스로 변환
    int index = hash.abs() % colorPalette.length;

    return colorPalette[index];
  }

  static DateTime coinStringToDateTime(String current) {
    int year = int.parse(current.substring(0, 4));
    int month = int.parse(current.substring(5, 7));
    int day = int.parse(current.substring(8, 10));
    int hh = int.parse(current.substring(11, 13));
    int mm = int.parse(current.substring(14, 16));
    DateTime currentDateTime = DateTime(year, month, day, hh, mm);
    return currentDateTime;
  }

  static Future<Profile> buyCoin(
    String profileKey,
    CoinBalance coinBalance,
  ) async {
    Profile result = Profile.init();

    logger.d("buyCoin");
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_PROFILE)
        .doc(profileKey);
    await docRef
        .update({
          Define.FIRESTORE_FIELD_COIN_BALANCE: FieldValue.arrayUnion([
            coinBalance.toJson(),
          ]),
          "point": FieldValue.increment(
            -(coinBalance.price * coinBalance.quantity),
          ),
        })
        .then(
          (value) async {
            logger.i("buyCoin success1");
            result = await App.getProfile();
          },
          onError: (e) async {
            if (e.code == Define.FIRESTORE_ERROR_CODE_NOT_FOUND) {
              await docRef
                  .set({
                    Define.FIRESTORE_FIELD_COIN_BALANCE: [coinBalance.toJson()],
                    "point": -(coinBalance.price * coinBalance.quantity),
                  })
                  .then(
                    (value) async {
                      logger.i("buyCoin success2");
                      result = await App.getProfile();
                    },
                    onError: (e) {
                      logger.e(e);
                    },
                  );
            } else {
              logger.e(e);
            }
          },
        );
    return result;
  }

  static Future<Profile> sellCoin(
    String profileKey,
    CoinBalance coinBalance,
    double currentPrice,
  ) async {
    Profile result = Profile.init();
    logger.d("sellCoin");
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_PROFILE)
        .doc(profileKey);
    await docRef
        .update({
          Define.FIRESTORE_FIELD_COIN_BALANCE: FieldValue.arrayRemove([
            coinBalance.toJson(),
          ]),
          "point": FieldValue.increment(currentPrice * coinBalance.quantity),
        })
        .then(
          (value) async {
            logger.i("sellCoin success1");
            result = await App.getProfile();
          },
          onError: (e) async {
            logger.e(e);
          },
        );
    return result;
  }

  // static Future<File> compressImageFromURL(String strURL) async {
  //   var logger = Logger();
  //   logger.i(strURL);
  //   Random random = new Random();
  //   int randomNumber = random.nextInt(1000000);
  //
  //   final Response responseData = await get(Uri.parse(strURL));
  //   Uint8List uint8list = responseData.bodyBytes;
  //   var buffer = uint8list.buffer;
  //   ByteData byteData = ByteData.view(buffer);
  //   var tempDir = await getTemporaryDirectory();
  //   File file = await File('${tempDir.path}/${randomNumber.toString()}')
  //       .writeAsBytes(
  //           buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  //
  //   ReceivePort receivePort = ReceivePort();
  //
  //   await Isolate.spawn(News.getCompressedImage, receivePort.sendPort);
  //   SendPort sendPort = await receivePort.first;
  //
  //   ReceivePort receivePort2 = ReceivePort();
  //
  //   sendPort.send([
  //     file.path,
  //     file.uri.pathSegments.last,
  //     (await getTemporaryDirectory()).path,
  //     receivePort2.sendPort,
  //   ]);
  //
  //   var msg = await receivePort2.first;
  //
  //   return new File(msg);
  // }

  static Future<bool> deleteArticle({required Article article}) async {
    bool result = false;

    try {
      final httpService = HttpService();
      final response = await httpService.deleteArticle(id: article.id);

      if (response.isSuccess) {
        result = true;
      } else {
        logger.e("deleteArticle failed: ${response.error}");
      }
    } catch (e) {
      logger.e("deleteArticle exception: $e");
    }

    return result;
  }

  static Future<String?> updateArticle({required Article article}) async {
    try {
      final articleData = {
        'board_name': article.board_name,
        'profile_uid': article.profile_uid,
        'profile_name': article.profile_name,
        'profile_photo_url': article.profile_photo_url,
        'count_view': article.count_view,
        'count_like': article.count_like,
        'count_unlike': article.count_unlike,
        'title': article.title,
        'contents':
            article.contents.map((content) => content.toJson()).toList(),
        'is_notice': article.is_notice,
        'thumbnail': article.thumbnail,
      };

      logger.d("updateArticle articleData: $articleData");

      final httpService = HttpService();
      final response = await httpService.updateArticle(
        articleData: articleData,
      );

      logger.d("updateArticle response: ${response.data}");

      if (response.isSuccess) {
        // 수정된 게시글의 ID 반환
        return response.data?['id'] as String?;
      } else {
        logger.e("updateArticle failed: ${response.error}");
      }
    } catch (e) {
      logger.e("updateArticle exception: $e");
    }

    return null;
  }

  static Future<List<Wish>> getWish() async {
    List<Wish> result = [];

    try {
      final httpService = HttpService();
      final response = await httpService.getWish();

      if (response.isSuccess) {
        final data = response.data!;
        if (data['data'] != null && data['data']['wishList'] != null) {
          List<dynamic> wishDataList = data['data']['wishList'];

          for (var wishData in wishDataList) {
            try {
              // Cloud Functions 응답 구조를 클라이언트 모델에 맞게 변환
              Map<String, dynamic> convertedWishData = {
                'index': wishData['index'] ?? 1,
                'uid': wishData['profile_uid'] ?? '',
                'comments': wishData['comment'] ?? '',
                'nick_name': wishData['profile_name'] ?? '',
                'streak': wishData['streak'] ?? 1,
                'created_at':
                    wishData['created_at'] != null
                        ? _formatTimestamp(wishData['created_at'])
                        : DateFormat("yyyy-MM-dd").format(DateTime.now()),
              };

              Wish wish = Wish.fromJson(convertedWishData);
              result.add(wish);
            } catch (e) {
              logger.e("Error converting wish data: $e");
            }
          }
        }
      } else {
        logger.e("getWish failed: ${response.error}");
      }
    } catch (e) {
      logger.e("getWish exception: $e");
    }

    return result;
  }

  // Firestore Timestamp를 문자열로 변환하는 헬퍼 메서드
  static String _formatTimestamp(dynamic timestamp) {
    try {
      if (timestamp is Map<String, dynamic> && timestamp['_seconds'] != null) {
        // Firestore Timestamp 객체인 경우
        int seconds = timestamp['_seconds'];
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
        return DateFormat("yyyy-MM-dd").format(dateTime);
      } else if (timestamp is String) {
        // 이미 문자열인 경우
        return timestamp;
      } else {
        // 기타 경우 현재 날짜 반환
        return DateFormat("yyyy-MM-dd").format(DateTime.now());
      }
    } catch (e) {
      logger.e("Error formatting timestamp: $e");
      return DateFormat("yyyy-MM-dd").format(DateTime.now());
    }
  }

  static Future<List<PointHistory>> getPointHistory() async {
    List<PointHistory> result = [];

    try {
      final fireUser = FirebaseAuth.instance.currentUser;
      if (fireUser == null) {
        throw Exception('Firebase Auth user not found');
      }

      final profileRef = FirebaseFirestore.instance
          .collection(Define.FIRESTORE_COLLECTION_PROFILE)
          .doc(fireUser.uid);

      final historySnapshot =
          await profileRef
              .collection('point_history')
              .orderBy('created_at', descending: true)
              .limit(50)
              .get();

      for (var doc in historySnapshot.docs) {
        try {
          final data = doc.data();
          // Timestamp를 문자열로 변환
          if (data['created_at'] != null) {
            data['created_at'] = _formatTimestamp(data['created_at']);
          }

          PointHistory history = PointHistory.fromJson({'id': doc.id, ...data});
          result.add(history);
        } catch (e) {
          logger.e("Error parsing point history: $e");
        }
      }
    } catch (e) {
      logger.e("getPointHistory exception: $e");
    }

    return result;
  }
}
