import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/constants/constants_enum.dart';
import 'package:common/constants/constants_value.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/services/data_service.dart';
import 'package:common/services/firebase_service.dart';
import 'package:common/services/like_service.dart';
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
      log('ClubGatheringService - uploadGathering Failed : $e');
      return false;
    }
  }

  static Future<bool> updateGathering(
      {required ClubGathering gathering}) async {
    try {
      Map<String, dynamic> gatheringData = gathering.toJson();
      return await GatheringService.updateGathering(
        category: _category,
        id: gathering.id,
        data: gatheringData,
      );
    } catch (e) {
      log('ClubGatheringService - updateGathering Failed : $e');
      return false;
    }
  }

  static Future<void> deleteGathering(
      {required ClubGathering gathering}) async {
    try {
      await GatheringService.deleteGathering(
        category: _category,
        id: gathering.id,
      );
    } catch (e) {
      log('ClubGatheringService - deleteGathering Failed : $e');
    }
  }

  static Future<List<ClubGathering>> getGatheringListWhichUserIsParticipating(
      {required String userId}) async {
    return await GatheringService.getParticipatingGatheringList(
        userId: userId,
        category: kClubGatheringCategory) as List<ClubGathering>;
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

      Map<String, dynamic>? likeCountMap = await LikeService.getLikeObjectMap(
          likeType: LikeType.clubGathering.name);
      if (likeCountMap != null) {
        gatheringList.sort((gathering1, gathering2) {
          int gathering1LikeCount = likeCountMap.containsKey(gathering1.id)
              ? likeCountMap[gathering1.id].length
              : 0;
          int gathering2LikeCount = likeCountMap.containsKey(gathering2.id)
              ? likeCountMap[gathering2.id].length
              : 0;
          return gathering2LikeCount - gathering1LikeCount;
        });
      }

      return gatheringList;
    } catch (e) {
      log('ClubGatheringService - getTrendingOnGathering Failed : $e');
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
      log('ClubGatheringService - getRecommendGathering Failed : $e');
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

      List<ClubGathering> gatheringList = snapshot.docs
          .map((element) => ClubGathering.fromJson(element.data()))
          .toList();

      Map<String, dynamic>? likeCountMap = await LikeService.getLikeObjectMap(
          likeType: LikeType.clubGathering.name);
      if (likeCountMap != null) {
        gatheringList.sort((gathering1, gathering2) {
          int gathering1LikeCount = likeCountMap.containsKey(gathering1.id)
              ? likeCountMap[gathering1.id].length
              : 0;
          int gathering2LikeCount = likeCountMap.containsKey(gathering2.id)
              ? likeCountMap[gathering2.id].length
              : 0;
          return gathering2LikeCount - gathering1LikeCount;
        });
      }

      return gatheringList;
    } catch (e) {
      log('ClubGatheringService - getInterestGathering Failed : $e');
      return [];
    }
  }

  static Future<bool> canShowGatheringRanking(
      {required List interestCategory, required String city}) async {
    try {
      bool result = false;
      for (var category in interestCategory) {
        final snapshot = await FirebaseService.fireStore
            .collection(_category)
            .where('category', isEqualTo: category)
            .where('cityList', arrayContains: city)
            .get();
        if (snapshot.size >= 3) {
          result = true;
        }
      }
      return result;
    } catch (e) {
      log('ClubGatheringService - canShowGatheringRanking Failed : $e');
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
      log('ClubGatheringService - getImmediatelyAbleToParticipateGathering Failed : $e');
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
      log('ClubGatheringService - getNearGathering Failed : $e');
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
      log('ClubGatheringService - getNewGathering Failed : $e');
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
      log('ClubGatheringService - searchGatheringWithKeyword Failed : $e');
      return [];
    }
  }

  /// 카테고리 검색
  static Future<List<ClubGathering>> searchGatheringWithCategory(
      {required String city, required String category}) async {
    try {
      late QuerySnapshot<Map<String, dynamic>> snapshot;
      if (category == 'all') {
        snapshot = await FirebaseService.fireStore
            .collection(_category)
            .where('cityList', arrayContains: city)
            .orderBy('timeStamp', descending: true)
            .get();
      } else {
        snapshot = await FirebaseService.fireStore
            .collection(_category)
            .where('category', isEqualTo: category)
            .where('cityList', arrayContains: city)
            .orderBy('timeStamp', descending: true)
            .get();
      }

      return snapshot.docs
          .map((element) => ClubGathering.fromJson(element.data()))
          .toList();
    } catch (e) {
      log('ClubGatheringService - searchGatheringWithCategory Failed : $e');
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
      log('ClubGatheringService - getAllGatheringWithCategory Failed : $e');
      return [];
    }
  }

  static Future<List<ClubGathering>> getLikeGatheringWithObjectList(
      {required List objectIdList}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseService.fireStore.collection(_category).get();

      return snapshot.docs
          .map((element) => ClubGathering.fromJson(element.data()))
          .where((gathering) => objectIdList.contains(gathering.id))
          .toList();
    } catch (e) {
      log('ClubGatheringService - getLikeGatheringWithObjectList Failed : $e');
      return [];
    }
  }
}
