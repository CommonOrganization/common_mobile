import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/models/daily/daily.dart';
import 'package:common/services/data_service.dart';
import 'package:common/services/upload_service.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/daily_utils.dart';
import 'firebase_service.dart';

class DailyService {
  static final DailyService _instance = DailyService._internal();
  factory DailyService() => _instance;
  DailyService._internal();

  static const String collection = 'daily';

  static Future<List<Daily>> getRecommendDaily() async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(collection)
          .orderBy('timeStamp', descending: true)
          .get();

      return snapshot.docs
          .map((document) => Daily.fromJson(document.data()))
          .toList();
    } catch (e) {
      log('DailyService - getRecommendDaily Failed : $e');
      return [];
    }
  }

  static Future<List<Daily>> getUserDaily({required String userId}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(collection)
          .where('organizerId', isEqualTo: userId)
          .orderBy('timeStamp', descending: true)
          .get();

      return snapshot.docs
          .map((document) => Daily.fromJson(document.data()))
          .toList();
    } catch (e) {
      log('DailyService - getUserDaily Failed : $e');
      return [];
    }
  }

  static Future<List<Daily>> getClubGatheringConnectedDaily(
      {required String clubGatheringId}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(collection)
          .where('connectedClubGatheringId', isEqualTo: clubGatheringId)
          .get();

      return snapshot.docs
          .map((document) => Daily.fromJson(document.data()))
          .toList();
    } catch (e) {
      log('DailyService - getClubGatheringConnectedDaily Failed : $e');
      return [];
    }
  }

  static Future<List<Daily>> searchDailyWithKeyword(
      {required String keyword}) async {
    try {
      final snapshot =
          await FirebaseService.fireStore.collection(collection).get();

      return snapshot.docs
          .map((document) => Daily.fromJson(document.data()))
          .where((daily) => hasKeywordDaily(daily: daily, keyword: keyword))
          .toList();
    } catch (e) {
      log('DailyService - searchDailyWithKeyword Failed : $e');
      return [];
    }
  }

  static Future<List<Daily>> searchDailyWithCategory(
      {required String category}) async {
    try {
      late QuerySnapshot<Map<String, dynamic>> snapshot;
      if (category == 'all') {
        snapshot = await FirebaseService.fireStore
            .collection(collection)
            .orderBy('timeStamp', descending: true)
            .get();
      } else {
        snapshot = await FirebaseService.fireStore
            .collection(collection)
            .where('category', isEqualTo: category)
            .orderBy('timeStamp', descending: true)
            .get();
      }

      return snapshot.docs
          .map((element) => Daily.fromJson(element.data()))
          .toList();
    } catch (e) {
      log('DailyService - searchDailyWithCategory Failed : $e');
      return [];
    }
  }

  static Future<String?> uploadDailyImage({required XFile image}) async {
    try {
      DateTime nowDate = DateTime.now();
      String imageRef = '/daily/${nowDate.microsecondsSinceEpoch}';
      return await UploadService.uploadImage(image: image, imageRef: imageRef);
    } catch (e) {
      log('DailyService - uploadDailyImage Failed : $e');
      return null;
    }
  }

  static Future<bool> uploadDaily({required Daily daily}) async {
    try {
      String? dailyId = await DataService.getId(name: collection);
      if (dailyId == null) return false;
      Map<String, dynamic> dailyData = daily.toJson();
      dailyData['id'] = dailyId;
      await FirebaseService.fireStore
          .collection(collection)
          .doc(dailyId)
          .set(dailyData);
      return true;
    } catch (e) {
      log('DailyService - uploadDaily Failed : $e');
      return false;
    }
  }

  static Future<bool> deleteDaily({required String dailyId}) async {
    try {
      await FirebaseService.fireStore
          .collection(collection)
          .doc(dailyId)
          .delete();
      return true;
    } catch (e) {
      log('DailyService - deleteDaily Failed : $e');
      return false;
    }
  }
}
