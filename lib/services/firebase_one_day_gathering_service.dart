import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/services/firebase_gathering_service.dart';

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
      return (await FirebaseGatheringService.getGathering(category: _category))
          .docs
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
          .where(_category)
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
}
