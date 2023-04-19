import 'dart:developer';
import 'package:common/constants/constants_value.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/services/firebase_gathering_service.dart';
import 'package:common/services/firebase_service.dart';

class FirebaseClubGatheringService {
  static final FirebaseClubGatheringService _instance =
      FirebaseClubGatheringService();
  factory FirebaseClubGatheringService() => _instance;

  static const String _category = 'clubGathering';

  static Future<bool> uploadGathering(
      {required ClubGathering gathering}) async {
    try {
      String? id = await FirebaseGatheringService.getId(category: _category);
      if (id == null) return false;
      Map<String, dynamic> gatheringData = gathering.toJson();
      gatheringData['id'] = id;
      return await FirebaseGatheringService.uploadGathering(
        category: _category,
        id: id,
        data: gatheringData,
      );
    } catch (e) {
      log('FirebaseClubGatheringService - uploadGathering Failed : $e');
      return false;
    }
  }

  static Future<List<ClubGathering>> getGathering() async {
    try {
      final snapshot =
          await FirebaseService.fireStore.collection(_category).get();

      return snapshot.docs
          .map((snapshot) => ClubGathering.fromJson(snapshot.data()))
          .toList();
    } catch (e) {
      log('FirebaseClubGatheringService - getGathering Failed : $e');
      return [];
    }
  }

  static Future<bool> applyGathering(
      {required String id, required String userId}) async {
    try {
      return await FirebaseGatheringService.applyGathering(
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
          .where('timeStamp',
              isGreaterThanOrEqualTo:
                  nowDate.subtract(const Duration(days: 7)).toString())
          .get();

      return snapshot.docs
          .map((element) => ClubGathering.fromJson(element.data()))
          .toList();
    } catch (e) {
      log('FirebaseClubGatheringService - getNewGathering Failed : $e');
      return [];
    }
  }
}
