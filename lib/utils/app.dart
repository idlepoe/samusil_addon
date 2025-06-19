import 'dart:convert';
import 'dart:io';

// import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

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
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

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
import '../main.dart';

class App {
  static Future<Profile> getLocaleProfile() async {
    // logger.i("getLocaleProfile");
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
    logger.i("setLocaleProfile");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Define.SHARED_PROFILE, json.encode(user));
  }

  static Profile createCommonProfile() {
    logger.i("createInitProfile");
    DateTime now = DateTime.now();
    DateFormat outputFormat = DateFormat('yyyyMMddHHmmssSSS');
    String stringNow = outputFormat.format(now);
    Profile user = Profile.init();
    user = user.copyWith(
      key: stringNow,
      name: "anon".tr + Utils.getRandomString(5),
    );
    return user;
  }

  static Profile createMasterProfile() {
    logger.i("createMasterProfile");
    Profile user = Profile.init();
    user = user.copyWith(key: "00000000000000000", name: "master");
    return user;
  }

  static Future<Profile> createDBProfile() async {
    logger.i("createDBProfile");
    // Profile user = createMasterProfile();
    Profile user = createCommonProfile();
    try {
      final colRef = FirebaseFirestore.instance.collection(
        Define.FIRESTORE_COLLECTION_PROFILE,
      );
      await colRef
          .doc(user.key)
          .set(user.toJson())
          .then(
            (value) async {
              logger.i("createDBProfile success");
              await setLocaleProfile(user);
            },
            onError: (e) async {
              logger.e(e);
            },
          );
    } catch (e) {
      logger.w(e);
    }
    return user;
  }

  static Future<Profile> createDBMasterProfile() async {
    logger.i("createDBMasterProfile");
    Profile user = createMasterProfile();
    try {
      final colRef = FirebaseFirestore.instance.collection(
        Define.FIRESTORE_COLLECTION_PROFILE,
      );
      await colRef
          .doc(user.key)
          .set(user.toJson())
          .then(
            (value) async {
              logger.i("createDBMasterProfile success");
              await setLocaleProfile(user);
            },
            onError: (e) async {
              logger.e(e);
            },
          );
    } catch (e) {
      logger.w(e);
    }
    return user;
  }

  static Future<bool> checkDBProfile(String key) async {
    bool result = false;
    logger.i("getProfile");
    try {
      var collection = FirebaseFirestore.instance.collection(
        Define.FIRESTORE_COLLECTION_PROFILE,
      );
      var docSnapshot = await collection.doc(key).get();
      if (docSnapshot.exists) {
        result = true;
      }
    } catch (e) {
      logger.w(e);
    }
    return result;
  }

  static Future<Profile> getProfile() async {
    Profile result = await getLocaleProfile();
    try {
      var collection = FirebaseFirestore.instance.collection(
        Define.FIRESTORE_COLLECTION_PROFILE,
      );
      var docSnapshot = await collection.doc(result.key).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        result = Profile.fromJson(data!);
      } else {
        result = await createDBProfile();
      }
    } catch (e) {
      logger.w(e);
    }
    logger.i(result.toString());
    result = result.copyWith(alarms: result.alarms.reversed.toList());
    return result;
  }

  static Future<bool> updateProfilePicture(Profile profile) async {
    bool result = true;
    logger.i("updateProfilePicture");
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_PROFILE)
        .doc(profile.key);

    await docRef
        .update({"profile_image_url": profile.profile_image_url})
        .then(
          (value) async {
            logger.i("updateProfilePicture Success");
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
    logger.i("updateProfileName");
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_PROFILE)
        .doc(profile.key);

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
    logger.i("updateProfileOneComment");
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_PROFILE)
        .doc(profile.key);
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
      if (wishList[i].key == profile.key) {
        result = true;
        break;
      }
    }
    return result;
  }

  static Future<void> countUpWishStreak(Profile profile) async {
    logger.d("countUpWishStreak");
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_PROFILE)
        .doc(profile.key);
    await docRef
        .update({"wish_streak": FieldValue.increment(1)})
        .then(
          (value) async {
            logger.i("countUpWishStreak success1");
          },
          onError: (e) async {
            if (e.code == Define.FIRESTORE_ERROR_CODE_NOT_FOUND) {
              await docRef
                  .set({"countView": 1})
                  .then(
                    (value) {
                      logger.i("countUpWishStreak success2");
                    },
                    onError: (e) {
                      print(e);
                    },
                  );
            } else {
              print(e);
            }
          },
        );
  }

  static Future<List<Wish>> updateWish(Profile profile, String comment) async {
    logger.i("updateWish");

    List<Wish> result = [];
    // Profile profile = await getProfile();

    DateTime today = DateTime.now();
    DateFormat df = DateFormat("yyyy-MM-dd");
    DateFormat df1 = DateFormat('yyyyMMddHHmmssSSS');
    String sToday = df.format(today);
    String sCreatedAt = df1.format(today);

    Wish wish = Wish(
      key: profile.key,
      comments: comment,
      nick_name: profile.name,
      streak: profile.wish_streak,
      created_at: sCreatedAt,
      index: 0,
    );

    try {
      final docRef = FirebaseFirestore.instance
          .collection(Define.FIRESTORE_COLLECTION_WISH)
          .doc(sToday);
      await docRef
          .update({
            "list": FieldValue.arrayUnion([wish.toJson()]),
          })
          .then(
            (value) async {
              logger.i("updateWish success1");
              await countUpWishStreak(profile);
              await pointUpdate(
                profile.key,
                Define.POINT_WISH + profile.wish_streak - 1,
              );
              final refGet = await docRef.get();
              int index = 1;
              for (dynamic s in refGet.get("list")) {
                Wish row = Wish.fromJson(s);
                row = row.copyWith(index: index);
                result.add(row);
                index++;
              }
              logger.i(result);
            },
            onError: (e) async {
              if (e.code == Define.FIRESTORE_ERROR_CODE_NOT_FOUND) {
                await docRef
                    .set({
                      "list": FieldValue.arrayUnion([wish.toJson()]),
                    })
                    .then(
                      (value) async {
                        logger.i("updateWish success2");
                        await countUpWishStreak(profile);
                        await pointUpdate(
                          profile.key,
                          Define.POINT_WISH + profile.wish_streak - 1,
                        );
                        final refGet = await docRef.get();
                        int index = 1;
                        for (dynamic s in refGet.get("list")) {
                          Wish row = Wish.fromJson(s);
                          row = row.copyWith(index: index);
                          result.add(row);
                          index++;
                        }
                        logger.i(result);
                      },
                      onError: (e) {
                        print(e);
                      },
                    );
              } else {
                print(e);
              }
            },
          );
    } catch (e) {
      logger.w(e);
    }

    logger.i(result);
    return result;
  }

  static Future<List<Article>> getArticleList(
    BoardInfo boardInfo,
    String search,
    int listLength,
  ) async {
    if (boardInfo.index == Define.INDEX_BOARD_ALL_PAGE) {
      return await getAllArticleListWithoutNews(boardInfo, search, listLength);
    }
    return await getIndexArticleList(boardInfo, search, listLength);
  }

  static Future<List<Article>> getIndexArticleList(
    BoardInfo boardInfo,
    String search,
    int listLength,
  ) async {
    List<Article> result = [];

    try {
      final collectionRef = FirebaseFirestore.instance
          .collection(Define.FIRESTORE_COLLECTION_ARTICLE)
          .where("board_index", isEqualTo: boardInfo.index)
          .orderBy("key", descending: true)
          .limit(listLength);

      QuerySnapshot querySnapshot = await collectionRef.get();

      List<Map<String, dynamic>> allData =
          querySnapshot.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();
      for (var i = 0; i < allData.length; i++) {
        Article v = Article.fromJson(allData[i]);
        if (search.isNotEmpty) {
          bool isContain = false;

          // 内容チェック
          for (int j = 0; j < v.contents.length; j++) {
            if (!v.contents[j].isPicture &&
                v.contents[j].contents.toLowerCase().contains(
                  search.toLowerCase(),
                )) {
              isContain = true;
              break;
            }
          }

          // タイトルチェック
          if (v.title.toLowerCase().contains(search.toLowerCase())) {
            isContain = true;
            break;
          }

          // 存在しないとスキップ
          if (!isContain) {
            continue;
          }
        }
        if (boardInfo.isPopular == null || !boardInfo.isPopular!) {
          if (boardInfo.isNotice == null || !boardInfo.isNotice!) {
            result.add(v);
            continue;
          } else if (v.is_notice) {
            result.add(v);
            continue;
          }
          continue;
        } else if (v.count_like > 3) {
          result.add(v);
          continue;
        }
      }
    } catch (e) {
      logger.e(e);
    }
    logger.i("getArticleList:${result.length}");
    result.sort((a, b) => b.key.compareTo(a.key));
    return result;
  }

  static Future<List<Article>> getAllArticleListWithoutNews(
    BoardInfo boardInfo,
    String search,
    int listLength,
  ) async {
    logger.i("getAllArticleListWithoutNews");
    List<Article> result = [];

    try {
      final collectionRef = FirebaseFirestore.instance
          .collection(Define.FIRESTORE_COLLECTION_ARTICLE)
          .where(
            "board_index",
            whereNotIn: [
              Define.INDEX_BOARD_IT_NEWS_PAGE,
              Define.INDEX_BOARD_GAME_NEWS_PAGE,
            ],
          )
          .orderBy("board_index")
          .orderBy("key", descending: true)
          .limit(listLength);

      QuerySnapshot querySnapshot = await collectionRef.get();

      List<Map<String, dynamic>> allData =
          querySnapshot.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();
      for (var i = 0; i < allData.length; i++) {
        Article v = Article.fromJson(allData[i]);
        if (search.isNotEmpty) {
          bool isContain = false;

          // 内容チェック
          for (int j = 0; j < v.contents.length; j++) {
            if (!v.contents[j].isPicture &&
                v.contents[j].contents.toLowerCase().contains(
                  search.toLowerCase(),
                )) {
              isContain = true;
              break;
            }
          }

          // タイトルチェック
          if (v.title.toLowerCase().contains(search.toLowerCase())) {
            isContain = true;
          }

          // 存在しないとスキップ
          if (!isContain) {
            continue;
          }
        }

        if (Utils.isValidateBool(boardInfo.isPopular)) {
          if (v.count_like > 3) {
            result.add(v);
          }
          continue;
        }

        if (Utils.isValidateBool(boardInfo.isNotice)) {
          if (v.is_notice) {
            result.add(v);
          }
          continue;
        }

        if (!Utils.isValidateBool(boardInfo.isPopular) &&
            !Utils.isValidateBool(boardInfo.isNotice)) {
          result.add(v);
        }
      }
    } catch (e) {
      logger.e(e);
    }
    logger.i("getArticleList:${result.length}");
    logger.i("getArticleList:${result.toString()}");
    return result;
  }

  static Future<Article> getArticle(String key) async {
    Article result = Article.init();
    logger.i("getArticle");
    try {
      var collection = FirebaseFirestore.instance.collection(
        Define.FIRESTORE_COLLECTION_ARTICLE,
      );
      var docSnapshot = await collection.doc(key).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        result = Article.fromJson(data!);
      } else {
        logger.w("no article:$key");
      }
    } catch (e) {
      logger.w(e);
    }
    logger.i(result.toString());
    return result;
  }

  static Future<void> createArticle(Article article) async {
    // logger.i("createArticle");
    try {
      final colRef = FirebaseFirestore.instance.collection(
        Define.FIRESTORE_COLLECTION_ARTICLE,
      );

      // 디버깅을 위한 로깅 추가
      logger.d("Article contents length: ${article.contents.length}");
      for (int i = 0; i < article.contents.length; i++) {
        logger.d("Content $i: ${article.contents[i]}");
      }

      // 수동으로 JSON 생성하여 List<ArticleContent> 문제 해결
      Map<String, dynamic> articleJson = {
        'key': article.key,
        'board_index': article.board_index,
        'profile_key': article.profile_key,
        'profile_name': article.profile_name,
        'count_view': article.count_view,
        'count_like': article.count_like,
        'count_unlike': article.count_unlike,
        'title': article.title,
        'contents':
            article.contents.map((content) => content.toJson()).toList(),
        'created_at': article.created_at,
        'comments':
            article.comments.map((comment) => comment.toJson()).toList(),
        'is_notice': article.is_notice,
        'thumbnail': article.thumbnail,
      };

      await colRef
          .doc(article.key)
          .set(articleJson)
          .then(
            (value) async {
              logger.i("createArticle success");
            },
            onError: (e) async {
              logger.e("Firestore error: $e");
            },
          );
    } catch (e) {
      logger.e("createArticle exception: $e");
      logger.e("Stack trace: ${StackTrace.current}");
    }
  }

  static Future<Profile> pointUpdate(String profileKey, double point) async {
    logger.d("pointUp");

    Profile result = Profile.init();

    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_PROFILE)
        .doc(profileKey);
    await docRef
        .update({"point": FieldValue.increment(point)})
        .then(
          (value) async {
            logger.i("pointUp success1");
            var docSnapshot = await docRef.get();
            if (docSnapshot.exists) {
              Map<String, dynamic>? data = docSnapshot.data();
              result = Profile.fromJson(data!);
            }
          },
          onError: (e) async {
            if (e.code == Define.FIRESTORE_ERROR_CODE_NOT_FOUND) {
              await docRef
                  .set({"point": point})
                  .then(
                    (value) async {
                      logger.i("pointUp success2");
                      var docSnapshot = await docRef.get();
                      if (docSnapshot.exists) {
                        Map<String, dynamic>? data = docSnapshot.data();
                        result = Profile.fromJson(data!);
                      }
                    },
                    onError: (e) {
                      print(e);
                    },
                  );
            } else {
              print(e);
            }
          },
        );
    return result;
  }

  static Future<List<MainComment>> createComment(
    Article article,
    MainComment comment,
  ) async {
    List<MainComment> result = [];

    logger.d("createComment");
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_ARTICLE)
        .doc(article.key);
    await docRef
        .update({
          Define.FIRESTORE_FIELD_COMMETS: FieldValue.arrayUnion([
            comment.toJson(),
          ]),
        })
        .then(
          (value) async {
            logger.i("createComment success1");
          },
          onError: (e) async {
            if (e.code == Define.FIRESTORE_ERROR_CODE_NOT_FOUND) {
              await docRef
                  .set({
                    Define.FIRESTORE_FIELD_COMMETS: FieldValue.arrayUnion([
                      comment.toJson(),
                    ]),
                  })
                  .then(
                    (value) {
                      logger.i("createComment success2");
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

    final refGet = await docRef.get();
    for (dynamic s in refGet.get(Define.FIRESTORE_FIELD_COMMETS)) {
      MainComment row = MainComment.fromJson(s);
      result.add(row);
    }
    logger.i(result);
    return result;
  }

  static Future<List<MainComment>> getComments(String id) async {
    List<MainComment> result = [];
    try {
      final docRef =
          await FirebaseFirestore.instance
              .collection(Define.FIRESTORE_COLLECTION_ARTICLE)
              .doc(id)
              .get();
      for (dynamic s in docRef.get(Define.FIRESTORE_FIELD_COMMETS)) {
        result.add(MainComment.fromJson(s));
      }
    } catch (e) {
      logger.w("no comment");
    }
    logger.i("getComments");
    return result;
  }

  static Future<int> articleCountViewUp(String key) async {
    logger.d("countUpArticleView");
    int result = 0;
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_ARTICLE)
        .doc(key);
    await docRef
        .update({"count_view": FieldValue.increment(1)})
        .then(
          (value) async {
            logger.i("countUpArticleView success1");
          },
          onError: (e) async {
            logger.e(e);
          },
        );
    final refGet = await docRef.get();
    result = refGet.get("count_view");
    return result;
  }

  static Future<int> articleCountLikeUp(String key) async {
    logger.d("articleCountLikeUp");
    int result = 0;
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_ARTICLE)
        .doc(key);
    await docRef
        .update({"count_like": FieldValue.increment(1)})
        .then(
          (value) async {
            logger.i("articleCountLikeUp success1");
          },
          onError: (e) async {
            if (e.code == Define.FIRESTORE_ERROR_CODE_NOT_FOUND) {
              await docRef
                  .set({"count_like": 0})
                  .then(
                    (value) {
                      logger.i("articleCountLikeUp success2");
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
    final refGet = await docRef.get();
    result = refGet.get("count_like");
    return result;
  }

  static Future<int> articleCountUnLikeUp(String key) async {
    logger.d("articleCountUnLikeUp");
    int result = 0;
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_ARTICLE)
        .doc(key);
    await docRef
        .update({"count_unlike": FieldValue.increment(1)})
        .then(
          (value) async {
            logger.i("articleCountUnLikeUp success1");
          },
          onError: (e) async {
            if (e.code == Define.FIRESTORE_ERROR_CODE_NOT_FOUND) {
              await docRef
                  .set({"count_view": 0})
                  .then(
                    (value) {
                      logger.i("articleCountUnLikeUp success2");
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
    final refGet = await docRef.get();
    result = refGet.get("count_unlike");
    return result;
  }

  static Future<List<MainComment>> deleteComment(
    String key,
    MainComment comment,
  ) async {
    logger.i("deleteComment");

    List<MainComment> result = [];
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_ARTICLE)
        .doc(key);
    await docRef
        .update({
          Define.FIRESTORE_FIELD_COMMETS: FieldValue.arrayRemove([
            comment.toJson(),
          ]),
        })
        .then(
          (value) async {
            logger.i("deleteComment Update Success");
          },
          onError: (e) async {
            logger.e(e);
          },
        );

    final refGet = await docRef.get();
    for (dynamic s in refGet.get(Define.FIRESTORE_FIELD_COMMETS)) {
      MainComment row = MainComment.fromJson(s);
      result.add(row);
    }
    logger.i(result);
    return result;
  }

  static Future<List<MainComment>> deleteArticle(Article article) async {
    logger.i("deleteComment");

    List<MainComment> result = [];
    final docRef =
        FirebaseFirestore.instance
            .collection(Define.FIRESTORE_COLLECTION_ARTICLE)
            .doc(article.key)
            .delete();
    logger.i("deleteComment Update Success");
    return result;
  }

  static Future<String> uploadImageToStorage(String strURL) async {
    String result = "";
    logger.i(strURL);
    Random random = Random();
    int randomNumber = random.nextInt(1000000);
    try {
      final Response responseData = await get(Uri.parse(strURL));
      Uint8List uint8list = responseData.bodyBytes;
      var buffer = uint8list.buffer;
      ByteData byteData = ByteData.view(buffer);
      var tempDir = await getTemporaryDirectory();
      File file = await File(
        '${tempDir.path}/${randomNumber.toString()}',
      ).writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
      );

      Reference reference = FirebaseStorage.instance.ref().child(
        'images/${basename(file.path)}',
      );
      TaskSnapshot uploadTask = await reference.putFile(file);
      result = await reference.getDownloadURL();
      logger.i(result);
    } catch (e) {
      logger.e(e);
      return "";
    }
    return result;
  }

  static Future<void> createAlarm(String profileKey, Alarm alarm) async {
    List<MainComment> result = [];

    logger.d("createAlarm");
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
            logger.i("createAlarm success1");
          },
          onError: (e) async {
            logger.e(e);
          },
        );
  }

  static Future<void> readAlarm(Profile profile) async {
    for (int i = 0; i < profile.alarms.length; i++) {
      profile = profile.copyWith(
        alarms:
            profile.alarms
                .asMap()
                .map((index, alarm) {
                  if (index == i) {
                    return MapEntry(index, alarm.copyWith(is_read: true));
                  }
                  return MapEntry(index, alarm);
                })
                .values
                .toList(),
      );
    }

    logger.d("readAlarm");
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_PROFILE)
        .doc(profile.key);
    await docRef
        .update({
          Define.FIRESTORE_FIELD_ALARMS:
              profile.alarms.map((e) => e.toJson()).toList(),
        })
        .then(
          (value) async {
            logger.i("readAlarm success1");
          },
          onError: (e) async {
            logger.e(e);
          },
        );
  }

  static Future<void> deleteAlarm(Profile profile) async {
    for (int i = 0; i < profile.alarms.length; i++) {
      profile = profile.copyWith(
        alarms:
            profile.alarms
                .asMap()
                .map((index, alarm) {
                  if (index == i) {
                    return MapEntry(index, alarm.copyWith(is_read: true));
                  }
                  return MapEntry(index, alarm);
                })
                .values
                .toList(),
      );
    }

    logger.d("deleteAlarm");
    final docRef = FirebaseFirestore.instance
        .collection(Define.FIRESTORE_COLLECTION_PROFILE)
        .doc(profile.key);
    await docRef
        .update({Define.FIRESTORE_FIELD_ALARMS: []})
        .then(
          (value) async {
            logger.i("deleteAlarm success1");
          },
          onError: (e) async {
            logger.e(e);
          },
        );
  }

  static Future<Profile> checkUser() async {
    User? fireUser = FirebaseAuth.instance.currentUser;
    Profile result = Profile.init();
    if (fireUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
      print("signInAnonymously");
      result = await App.createDBProfile();
    } else {
      print(fireUser.toString());
      result = await App.getProfile();
    }
    return result;
  }

  static Future<bool> isMaster() async {
    Profile result = await App.getProfile();
    return result.key == Define.MASTER_USER_KEY;
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
    logger.i("getProfileList:${result.length}");
    return result;
  }

  static Future<List<Coin>> getCoinListFromPaprika(BuildContext context) async {
    logger.i("getCoinListFromPaprika");

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
    logger.i("createCoinList");
    try {
      for (Coin row in list) {
        final docRef = FirebaseFirestore.instance
            .collection(Define.FIRESTORE_COLLECTION_COIN)
            .doc(row.id);
        await docRef
            .set(row.toJson())
            .then(
              (value) async {
                logger.i("createCoinList success1");
              },
              onError: (e) async {
                logger.e(e);
              },
            );
      }
    } catch (e) {
      logger.w(e);
    }
  }

  static Future<List<Coin>> getCoinPriceFromPaprika(
    BuildContext context,
  ) async {
    logger.i("getCoinPriceFromPaprika");

    Utils.showSnackBar(
      context,
      SnackType.info,
      "${"process_start".tr} : ${"point_market".tr}",
    );

    List<CoinPrice> list = [];

    final response = await get(
      Uri.parse("https://api.coinpaprika.com/v1/exchanges/binance/markets"),
    );

    switch (response.statusCode) {
      case 200:
        List<dynamic> result = jsonDecode(utf8.decode(response.bodyBytes));
        for (int i = 0; i < result.length; i++) {
          CoinPrice target = CoinPrice(
            price: result[i]["quotes"]["USD"]["price"],
            volume_24h: result[i]["quotes"]["USD"]["volume_24h"],
            last_updated: result[i]["last_updated"],
          );
          target = target.copyWith(id: result[i]["base_currency_id"]);
          if (list.firstWhereOrNull((element) => element.id == target.id) ==
              null) {
            list.add(target);
          }
        }
        break;
      default:
        break;
    }

    logger.i(list);

    await updateCoinPrice(context, list);

    Utils.showSnackBar(
      context,
      SnackType.info,
      "${"process_end".tr} : ${"point_market".tr}",
    );

    return [];
  }

  static Future<void> updateCoinPrice(
    BuildContext context,
    List<CoinPrice> coinPriceList,
  ) async {
    logger.d("updateCoinPrice");

    List<Coin> coinList = await getCoinList();

    for (CoinPrice coinPrice in coinPriceList) {
      if (coinList.firstWhereOrNull((element) => element.id == coinPrice.id) ==
          null) {
        continue;
      }

      final docRef = FirebaseFirestore.instance
          .collection(Define.FIRESTORE_COLLECTION_COIN)
          .doc(coinPrice.id);
      await docRef
          .update({
            Define.FIRESTORE_FIELD_PRICE_HISTORY: FieldValue.arrayUnion([
              coinPrice.toJson(),
            ]),
          })
          .then(
            (value) async {
              logger.i("updateCoinPrice success1");
            },
            onError: (e) async {
              if (e.code == Define.FIRESTORE_ERROR_CODE_NOT_FOUND) {
                logger.i("no coin");
              } else {
                logger.e(e);
              }
            },
          );
    }
  }

  static Future<List<Coin>> getCoinList({withoutNoTrade = false}) async {
    List<Coin> result = [];

    try {
      final collectionRef = FirebaseFirestore.instance.collection(
        Define.FIRESTORE_COLLECTION_COIN,
      );

      QuerySnapshot querySnapshot = await collectionRef.get();

      List<Map<String, dynamic>> allData =
          querySnapshot.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();
      for (var i = 0; i < allData.length; i++) {
        Coin v = Coin.fromJson(allData[i]);
        if (withoutNoTrade &&
            (v.price_history == null || v.price_history!.isEmpty)) {
          continue;
        }
        result.add(v);
      }
    } catch (e) {
      logger.e(e);
    }
    for (int i = 0; i < result.length; i++) {
      result[i] = result[i].copyWith(
        color: Utils.randomColor().value.toDouble(),
      );
      if (result[i].price_history != null) {
        String current =
            result[i]
                .price_history![result[i].price_history!.length - 1]
                .last_updated;
        DateTime currentDateTime = coinStringToDateTime(current);
        DateTime oneDayBefore = currentDateTime.subtract(
          const Duration(days: 1, seconds: 1),
        );

        List<Price> validCoinHistory = [];
        List<double> diffList = [];
        double firstPrice = result[i].price_history![0].price;
        double lastPrice =
            result[i].price_history![result[i].price_history!.length - 1].price;
        result[i] = result[i].copyWith(
          diffPercentage: Utils.diffPercentage(firstPrice, lastPrice),
          diffList: diffList,
        );
        for (int j = 0; j < result[i].price_history!.length; j++) {
          String rowDate = result[i].price_history![j].last_updated;
          DateTime rowDateTime = coinStringToDateTime(rowDate);
          if (rowDateTime.isAfter(oneDayBefore)) {
            validCoinHistory.add(result[i].price_history![j]);
            diffList.add(firstPrice - result[i].price_history![j].price);
          }
        }
        result[i] = result[i].copyWith(price_history: validCoinHistory);
      }
    }

    result.sort((a, b) => a.rank.compareTo(b.rank));
    return result;
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
        })
        .then(
          (value) async {
            logger.i("buyCoin success1");
            result = await App.pointUpdate(
              profileKey,
              -(coinBalance.price * coinBalance.quantity),
            );
          },
          onError: (e) async {
            if (e.code == Define.FIRESTORE_ERROR_CODE_NOT_FOUND) {
              await docRef
                  .set({
                    Define.FIRESTORE_FIELD_COIN_BALANCE: [coinBalance.toJson()],
                  })
                  .then(
                    (value) async {
                      logger.i("buyCoin success2");
                      result = await App.pointUpdate(
                        profileKey,
                        -(coinBalance.price * coinBalance.quantity),
                      );
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
        })
        .then(
          (value) async {
            logger.i("sellCoin success1");
            result = await App.pointUpdate(
              profileKey,
              (currentPrice * coinBalance.quantity),
            );
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
}
