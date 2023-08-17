import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/services/firebase_service.dart';
import '../utils/gathering_utils.dart';
import 'gathering_service.dart';

class ClubGatheringService {
  static final ClubGatheringService _instance =
      ClubGatheringService._internal();
  factory ClubGatheringService() => _instance;
  ClubGatheringService._internal();

  static const String _category = 'clubGathering';

  static Future<bool> uploadGathering(
      {required ClubGathering gathering}) async {
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
      log('FirebaseClubGatheringService - uploadGathering Failed : $e');
      return false;
    }
  }

  static Future<bool> applyGathering(
      {required String id, required String userId}) async {
    try {
      return await GatheringService.applyGathering(
          category: _category, id: id, userId: userId);
    } catch (e) {
      log('FirebaseClubGatheringService - applyGathering Failed : $e');
      return false;
    }
  }

  static Future<List<ClubGathering>> getGatheringListWhichUserIsParticipating(
      {required String userId}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('memberList', arrayContains: userId)
          .get();

      if (snapshot.docs.isEmpty) return [];

      return snapshot.docs
          .map((gathering) => ClubGathering.fromJson(gathering.data()))
          .toList();
    } catch (e) {
      log('FirebaseClubGatheringService - getGatheringListWhichUserIsParticipating Failed : $e');
      return [];
    }
  }

  /// 소모임 콘텐츠
  static Future<List<ClubGathering>> getTrendingOnGathering(
      {required String city}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('cityList', arrayContains: city)
          .get();

      List<ClubGathering> gatheringList = snapshot.docs
          .map((element) => ClubGathering.fromJson(element.data()))
          .toList();

      gatheringList.sort((gathering1, gathering2) =>
          gathering2.favoriteList.length - gathering1.favoriteList.length);

      return gatheringList;
    } catch (e) {
      log('FirebaseClubGatheringService - getTrendingOnGathering Failed : $e');
      return [];
    }
  }

  static Future<List<ClubGathering>> getRecommendGathering(
      {required String category, required String city}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('cityList', arrayContains: city)
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs
          .map((element) => ClubGathering.fromJson(element.data()))
          .toList();
    } catch (e) {
      log('FirebaseClubGatheringService - getRecommendGathering Failed : $e');
      return [];
    }
  }

  static Future<List<ClubGathering>> getInterestGathering(
      {required String category, required String city}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('cityList', arrayContains: city)
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs
          .map((element) => ClubGathering.fromJson(element.data()))
          .toList();
    } catch (e) {
      log('FirebaseClubGatheringService - getInterestGathering Failed : $e');
      return [];
    }
  }

  static Future<bool> canShowGatheringRanking(
      {required List interestCategory}) async {
    try {
      bool result = false;
      for (var category in interestCategory) {
        final snapshot = await FirebaseService.fireStore
            .collection(_category)
            .where('category', isEqualTo: category)
            .get();
        if (snapshot.size >= 3) {
          result = true;
        }
      }
      return result;
    } catch (e) {
      log('FirebaseClubGatheringService - canShowGatheringRanking Failed : $e');
      return false;
    }
  }

  static Future<List<ClubGathering>> getImmediatelyAbleToParticipateGathering(
      {required String city}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('cityList', arrayContains: city)
          .where('recruitWay', isEqualTo: 'firstCome')
          .get();

      return snapshot.docs
          .map((element) => ClubGathering.fromJson(element.data()))
          .toList();
    } catch (e) {
      log('FirebaseClubGatheringService - getImmediatelyAbleToParticipateGathering Failed : $e');
      return [];
    }
  }

  static Future<List<ClubGathering>> getNearGathering(
      {required String city}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('cityList', arrayContains: city)
          .get();

      return snapshot.docs
          .map((element) => ClubGathering.fromJson(element.data()))
          .toList();
    } catch (e) {
      log('FirebaseClubGatheringService - getNearGathering Failed : $e');
      return [];
    }
  }

  static Future<List<ClubGathering>> getNewGathering(
      {required String city}) async {
    try {
      DateTime nowDate = DateTime.now();

      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('cityList', arrayContains: city)
          .where('timeStamp',
              isGreaterThanOrEqualTo:
                  nowDate.subtract(const Duration(days: 7)).toString())
          .orderBy('timeStamp', descending: true)
          .get();

      return snapshot.docs
          .map((element) => ClubGathering.fromJson(element.data()))
          .toList();
    } catch (e) {
      log('FirebaseClubGatheringService - getNewGathering Failed : $e');
      return [];
    }
  }

  /// 소모임 검색
  static Future<List<ClubGathering>> searchGatheringWithKeyword(
      {required String keyword, required String city}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('cityList', arrayContains: city)
          .get();

      return snapshot.docs
          .map((element) => ClubGathering.fromJson(element.data()))
          .where((element) =>
              hasKeywordClubGathering(gathering: element, keyword: keyword))
          .toList();
    } catch (e) {
      log('FirebaseClubGatheringService - searchGatheringWithKeyword Failed : $e');
      return [];
    }
  }

  /// 카테고리 검색
  static Future<List<ClubGathering>> getNewGatheringWithCategory(
      {required String city, required String category}) async {
    try {
      DateTime nowDate = DateTime.now();
      late QuerySnapshot<Map<String, dynamic>> snapshot;
      if (category == 'all') {
        snapshot = await FirebaseService.fireStore
            .collection(_category)
            .where('cityList', arrayContains: city)
            .where('timeStamp',
                isGreaterThanOrEqualTo:
                    nowDate.subtract(const Duration(days: 7)).toString())
            .orderBy('timeStamp', descending: true)
            .get();
      } else {
        snapshot = await FirebaseService.fireStore
            .collection(_category)
            .where('category', isEqualTo: category)
            .where('cityList', arrayContains: city)
            .where('timeStamp',
                isGreaterThanOrEqualTo:
                    nowDate.subtract(const Duration(days: 7)).toString())
            .orderBy('timeStamp', descending: true)
            .get();
      }

      return snapshot.docs
          .map((element) => ClubGathering.fromJson(element.data()))
          .toList();
    } catch (e) {
      log('FirebaseClubGatheringService - getNewGatheringWithCategory Failed : $e');
      return [];
    }
  }

  static Future<List<ClubGathering>> getAllGatheringWithCategory(
      {required String city, required String category}) async {
    try {
      late QuerySnapshot<Map<String, dynamic>> snapshot;
      if (category == 'all') {
        snapshot = await FirebaseService.fireStore
            .collection(_category)
            .where('cityList', arrayContains: city)
            .get();
      } else {
        snapshot = await FirebaseService.fireStore
            .collection(_category)
            .where('cityList', arrayContains: city)
            .where('category', isEqualTo: category)
            .get();
      }

      return snapshot.docs
          .map((element) => ClubGathering.fromJson(element.data()))
          .toList();
    } catch (e) {
      log('FirebaseClubGatheringService - getAllGatheringWithCategory Failed : $e');
      return [];
    }
  }
}
