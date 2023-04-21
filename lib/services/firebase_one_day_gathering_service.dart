import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/services/firebase_gathering_service.dart';

import 'firebase_service.dart';

class FirebaseOneDayGatheringService {
  static final FirebaseOneDayGatheringService _instance =
      FirebaseOneDayGatheringService();
  factory FirebaseOneDayGatheringService() => _instance;

  static const String _category = 'oneDayGathering';

  static Future<bool> uploadGathering(
      {required OneDayGathering gathering}) async {
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
      log('FirebaseOneDayGatheringService - uploadGathering Failed : $e');
      return false;
    }
  }

  static Future<List<OneDayGathering>> getGathering() async {
    try {
      final snapshot =
          await FirebaseService.fireStore.collection(_category).get();

      return snapshot.docs
          .map((snapshot) => OneDayGathering.fromJson(snapshot.data()))
          .toList();
    } catch (e) {
      log('FirebaseOneDayGatheringService - getGathering Failed : $e');
      return [];
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
      return await FirebaseGatheringService.applyGathering(
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
      {required String city, required String county}) async {
    try {
      DateTime nowDate = DateTime.now();
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('openingDate', isGreaterThanOrEqualTo: nowDate.toString())
          .get();

      return snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          .where((element) => element.place['city'] == city)
          .where((element) => element.place['county'] == county)
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
      final snapshot = await FirebaseService.fireStore
          .collection(_category)
          .where('timeStamp',
              isGreaterThanOrEqualTo:
                  nowDate.subtract(const Duration(days: 7)).toString())
          .get();

      return snapshot.docs
          .map((element) => OneDayGathering.fromJson(element.data()))
          // .where((element) => element.place['city'] == city)
          .toList();
    } catch (e) {
      log('FirebaseOneDayGatheringService - getNewGathering Failed : $e');
      return [];
    }
  }
}
