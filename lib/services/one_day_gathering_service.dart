import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/constants/constants_value.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import '../utils/gathering_utils.dart';
import 'data_service.dart';
import 'firebase_service.dart';
import 'gathering_service.dart';

class OneDayGatheringService {
  static final OneDayGatheringService _instance =
      OneDayGatheringService._internal();

  factory OneDayGatheringService() => _instance;

  OneDayGatheringService._internal();

  static const String _category = 'oneDayGathering';

  static Future<bool> uploadGathering(
      {required OneDayGathering gathering}) async {
    try {

      String? id = await DataService.getId(name: _category);
      if (id == null) return false;
      Map<String, dynamic> gatheringData = gathering.toJson();
      gatheringData['id'] = id;
      return await GatheringService.uploadGathering(
        category: _category,
        id: id,
        data: gatheringData,
      );
    } catch (e) {
      log('OneDayGatheringService - uploadGathering Failed : $e');
      return false;
    }
  }

  static Future<bool> updateGathering(
      {required OneDayGathering gathering}) async {
    try {
      Map<String, dynamic> gatheringData = gathering.toJson();
      return await GatheringService.updateGathering(
        category: _category,
        id: gathering.id,
        data: gatheringData,
      );
    } catch (e) {
      log('OneDayGatheringService - updateGathering Failed : $e');
      return false;
    }
  }

  static Future<void> deleteGathering(
      {required OneDayGathering gathering}) async {
    try {
      await GatheringService.deleteGathering(
        category: _category,
        id: gathering.id,
      );
    } catch (e) {
      log('OneDayGatheringService - deleteGathering Failed : $e');
    }
  }

  static Future<List<OneDayGathering>> getConnectedGathering(
      {required String clubGatheringId}) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(_category)
          .where('connectedClubGatheringId', isEqualTo: clubGatheringId)
          .get();
      return snapshot.docs
          .map((snapshot) => OneDayGathering.fromJson(snapshot.data()))
          .toList();
    } catch (e) {
      log('OneDayGatheringService - getConnectedGathering Failed : $e');
      return [];
    }
  }

  // 모든 과정에 이를 추가해주어야함.
  static Future<List<OneDayGathering>> canProvideGathering(
      {required List<OneDayGathering> gatheringList,
      required String userId}) async {
    List<String> gatheringIdList =
        await GatheringService.getUserParticipatingGatheringIdList(
            userId: userId);
    return gatheringList
        .where((gathering) =>
            gathering.showAllThePeople ||
            gatheringIdList.contains(gathering.connectedClubGatheringId))
        .toList();
  }

  /// 이 유저가 가입한 모든 하루모임을 리턴 ( 앞으로의 하루모임만을 리턴 )
  static Future<List<OneDayGathering>> getGatheringListWhichUserIsParticipating(
      {required String userId}) async {
    DateTime nowDate = DateTime.now();

    return (await GatheringService.getParticipatingGatheringList(
            userId: userId,
            category: kOneDayGatheringCategory) as List<OneDayGathering>)
        .where((gathering) =>
            DateTime.parse(gathering.openingDate).difference(nowDate) >=
            Duration.zero)
        .toList();
  }

  /// 이 유저가 참여했던 모든 하루모임을 리턴 ( 지난 하루모임 포함 )
  static Future<List<OneDayGathering>>
      getAllGatheringListWhichUserIsParticipating(
          {required String userId}) async {
    return await GatheringService.getParticipatingGatheringList(
        userId: userId,
        category: kOneDayGatheringCategory) as List<OneDayGathering>;
  }

  /// 하루모임 콘텐츠
  static Future<List<OneDayGathering>> getTodayGathering(
      {required String city, required String userId}) async {
    try {
      DateTime nowDate = DateTime.now();
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('openingDate', isGreaterThanOrEqualTo: nowDate.toString())
          .where('openingDate',
              isLessThanOrEqualTo:
                  nowDate.add(const Duration(days: 1)).toString())
          .get();

      List<OneDayGathering> result = snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((element) => element.place['city'] == city)
          .toList();

      return await canProvideGathering(gatheringList: result, userId: userId);
    } catch (e) {
      log('OneDayGatheringService - getTodayGathering Failed : $e');
      return [];
    }
  }

  static Future<List<OneDayGathering>> getDailyGathering(
      {required String city,
      required DateTime dateTime,
      required String userId}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('openingDate', isGreaterThanOrEqualTo: dateTime.toString())
          .where('openingDate',
              isLessThan: dateTime.add(const Duration(days: 1)).toString())
          .get();

      List<OneDayGathering> result = snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((element) => element.place['city'] == city)
          .toList();
      return await canProvideGathering(gatheringList: result, userId: userId);
    } catch (e) {
      log('OneDayGatheringService - getDailyGathering Failed : $e');
      return [];
    }
  }

  static Future<List<OneDayGathering>> getRecommendGathering(
      {required String category,
      required String city,
      required String userId}) async {
    try {
      DateTime nowDate = DateTime.now();
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('openingDate', isGreaterThanOrEqualTo: nowDate.toString())
          .where('category', isEqualTo: category)
          .get();

      List<OneDayGathering> result = snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((element) => element.place['city'] == city)
          .toList();
      return await canProvideGathering(gatheringList: result, userId: userId);
    } catch (e) {
      log('OneDayGatheringService - getRecommendGathering Failed : $e');
      return [];
    }
  }

  static Future<List<OneDayGathering>> getNearGathering(
      {required String city, required String userId}) async {
    try {
      DateTime nowDate = DateTime.now();
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('openingDate', isGreaterThanOrEqualTo: nowDate.toString())
          .get();

      List<OneDayGathering> result = snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((element) => element.place['city'] == city)
          .toList();

      return await canProvideGathering(gatheringList: result, userId: userId);
    } catch (e) {
      log('OneDayGatheringService - getNearGathering Failed : $e');
      return [];
    }
  }

  static Future<List<OneDayGathering>> getNewGathering(
      {required String city, required String userId}) async {
    try {
      DateTime nowDate = DateTime.now();
      //TODO 쿼리에 timeStamp와 openingDate를 못넣는 이유 - Firestore 이슈 -> 스프링 전환시 동시 처리 예정
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('timeStamp',
              isGreaterThanOrEqualTo:
                  nowDate.subtract(const Duration(days: 7)).toString())
          .orderBy('timeStamp', descending: true)
          .get();

      List<OneDayGathering> result = snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((element) => nowDate
              .difference(DateTime.parse(element.openingDate))
              .isNegative)
          .where((element) => element.place['city'] == city)
          .toList();
      return await canProvideGathering(gatheringList: result, userId: userId);
    } catch (e) {
      log('OneDayGatheringService - getNewGathering Failed : $e');
      return [];
    }
  }

  /// 하루모임 검색
  static Future<List<OneDayGathering>> searchGatheringWithKeyword(
      {required String keyword,
      required String city,
      required String userId}) async {
    try {
      DateTime nowDate = DateTime.now();
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('openingDate', isGreaterThanOrEqualTo: nowDate.toString())
          .get();

      List<OneDayGathering> result = snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((element) =>
              hasKeywordOneDayGathering(gathering: element, keyword: keyword))
          .where((element) => element.place['city'] == city)
          .toList();
      return await canProvideGathering(gatheringList: result, userId: userId);
    } catch (e) {
      log('OneDayGatheringService - searchGatheringWithKeyword Failed : $e');
      return [];
    }
  }

  /// 카테고리 검색
  static Future<List<OneDayGathering>> getNewGatheringWithCategory(
      {required String city,
      required String category,
      required String userId}) async {
    try {
      DateTime nowDate = DateTime.now();
      //TODO 쿼리에 timeStamp와 openingDate를 못넣는 이유 - Firestore 이슈 -> 스프링 전환시 동시 처리 예정
      late QuerySnapshot<Map<String, dynamic>> snapshot;
      if (category == 'all') {
        snapshot = await FirebaseService.fireStore
            .collection(_category)
            .where('timeStamp',
                isGreaterThanOrEqualTo:
                    nowDate.subtract(const Duration(days: 7)).toString())
            .orderBy('timeStamp', descending: true)
            .get();
      } else {
        snapshot = await FirebaseService.fireStore
            .collection(_category)
            .where('category', isEqualTo: category)
            .where('timeStamp',
                isGreaterThanOrEqualTo:
                    nowDate.subtract(const Duration(days: 7)).toString())
            .orderBy('timeStamp', descending: true)
            .get();
      }

      List<OneDayGathering> result = snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((element) => nowDate
              .difference(DateTime.parse(element.openingDate))
              .isNegative)
          .where((element) => element.place['city'] == city)
          .toList();
      return await canProvideGathering(gatheringList: result, userId: userId);
    } catch (e) {
      log('OneDayGatheringService - getNewGatheringWithCategory Failed : $e');
      return [];
    }
  }

  static Future<List<OneDayGathering>> getAllGatheringWithCategory(
      {required String city,
      required String category,
      required String userId}) async {
    try {
      DateTime nowDate = DateTime.now();
      late QuerySnapshot<Map<String, dynamic>> snapshot;
      if (category == 'all') {
        snapshot = await FirebaseService.fireStore
            .collection(_category)
            .where('openingDate', isGreaterThanOrEqualTo: nowDate.toString())
            .get();
      } else {
        snapshot = await FirebaseService.fireStore
            .collection(_category)
            .where('category', isEqualTo: category)
            .where('openingDate', isGreaterThanOrEqualTo: nowDate.toString())
            .get();
      }

      List<OneDayGathering> result = snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((element) => element.place['city'] == city)
          .toList();

      return await canProvideGathering(gatheringList: result, userId: userId);
    } catch (e) {
      log('OneDayGatheringService - getAllGatheringWithCategory Failed : $e');
      return [];
    }
  }

  static Future<List<OneDayGathering>> getLikeGatheringWithObjectList(
      {required List objectIdList}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseService.fireStore.collection(_category).get();

      return snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((gathering) => objectIdList.contains(gathering.id))
          .toList();
    } catch (e) {
      log('OneDayGatheringService - getLikeGatheringWithObjectList Failed : $e');
      return [];
    }
  }
}
