import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import '../utils/gathering_utils.dart';
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
      String? id = await GatheringService.getId(category: _category);
      if (id == null) return false;
      Map<String, dynamic> gatheringData = gathering.toJson();
      gatheringData['id'] = id;
      return await GatheringService.uploadGathering(
        category: _category,
        id: id,
        data: gatheringData,
      );
    } catch (e) {
      log('FirebaseOneDayGatheringService - uploadGathering Failed : $e');
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
      log('FirebaseOneDayGatheringService - updateGathering Failed : $e');
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
      log('FirebaseOneDayGatheringService - deleteGathering Failed : $e');
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
      log('FirebaseOneDayGatheringService - getConnectedGathering Failed : $e');
      return [];
    }
  }

  static Future<bool> applyGathering(
      {required String id, required String userId}) async {
    try {
      return await GatheringService.applyGathering(
          category: _category, id: id, userId: userId);
    } catch (e) {
      log('FirebaseOneDayGatheringService - applyGathering Failed : $e');
      return false;
    }
  }

  static Future<List<OneDayGathering>> getGatheringListWhichUserIsParticipating(
      {required String userId}) async {
    try {
      DateTime nowDate = DateTime.now();
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('memberList', arrayContains: userId)
          .where('openingDate', isGreaterThanOrEqualTo: nowDate.toString())
          .orderBy('openingDate', descending: true)
          .get();
      if (snapshot.docs.isEmpty) return [];

      return snapshot.docs
          .map((gathering) => OneDayGathering.fromJson(gathering.data()))
          .toList();
    } catch (e) {
      log('FirebaseOneDayGatheringService - getGatheringListWhichUserIsParticipating Failed : $e');
      return [];
    }
  }

  /// 하루모임 콘텐츠
  static Future<List<OneDayGathering>> getTodayGathering(
      {required String city}) async {
    try {
      DateTime nowDate = DateTime.now();
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('openingDate', isGreaterThanOrEqualTo: nowDate.toString())
          .where('openingDate',
              isLessThanOrEqualTo:
                  nowDate.add(const Duration(days: 1)).toString())
          .get();

      return snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((element) => element.place['city'] == city)
          .toList();
    } catch (e) {
      log('FirebaseOneDayGatheringService - getTodayGathering Failed : $e');
      return [];
    }
  }

  static Future<List<OneDayGathering>> getDailyGathering(
      {required String city, required DateTime dateTime}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('openingDate', isGreaterThanOrEqualTo: dateTime.toString())
          .where('openingDate',
              isLessThan: dateTime.add(const Duration(days: 1)).toString())
          .get();

      return snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((element) => element.place['city'] == city)
          .toList();
    } catch (e) {
      log('FirebaseOneDayGatheringService - getDailyGathering Failed : $e');
      return [];
    }
  }

  static Future<List<OneDayGathering>> getRecommendGathering(
      {required String category, required String city}) async {
    try {
      DateTime nowDate = DateTime.now();
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('openingDate', isGreaterThanOrEqualTo: nowDate.toString())
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((element) => element.place['city'] == city)
          .toList();
    } catch (e) {
      log('FirebaseOneDayGatheringService - getRecommendGathering Failed : $e');
      return [];
    }
  }

  static Future<List<OneDayGathering>> getNearGathering(
      {required String city}) async {
    try {
      DateTime nowDate = DateTime.now();
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('openingDate', isGreaterThanOrEqualTo: nowDate.toString())
          .get();

      return snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((element) => element.place['city'] == city)
          .toList();
    } catch (e) {
      log('FirebaseOneDayGatheringService - getNearGathering Failed : $e');
      return [];
    }
  }

  static Future<List<OneDayGathering>> getNewGathering(
      {required String city}) async {
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

      return snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((element) => nowDate
              .difference(DateTime.parse(element.openingDate))
              .isNegative)
          .where((element) => element.place['city'] == city)
          .toList();
    } catch (e) {
      log('FirebaseOneDayGatheringService - getNewGathering Failed : $e');
      return [];
    }
  }

  /// 하루모임 검색
  static Future<List<OneDayGathering>> searchGatheringWithKeyword(
      {required String keyword, required String city}) async {
    try {
      DateTime nowDate = DateTime.now();
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('openingDate', isGreaterThanOrEqualTo: nowDate.toString())
          .get();

      return snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((element) =>
              hasKeywordOneDayGathering(gathering: element, keyword: keyword))
          .where((element) => element.place['city'] == city)
          .toList();
    } catch (e) {
      log('FirebaseOneDayGatheringService - searchGatheringWithKeyword Failed : $e');
      return [];
    }
  }

  /// 카테고리 검색
  static Future<List<OneDayGathering>> getNewGatheringWithCategory(
      {required String city, required String category}) async {
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

      return snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((element) => nowDate
              .difference(DateTime.parse(element.openingDate))
              .isNegative)
          .where((element) => element.place['city'] == city)
          .toList();
    } catch (e) {
      log('FirebaseOneDayGatheringService - getNewGatheringWithCategory Failed : $e');
      return [];
    }
  }

  static Future<List<OneDayGathering>> getAllGatheringWithCategory(
      {required String city, required String category}) async {
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

      return snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((element) => element.place['city'] == city)
          .toList();
    } catch (e) {
      log('FirebaseOneDayGatheringService - getAllGatheringWithCategory Failed : $e');
      return [];
    }
  }
}
