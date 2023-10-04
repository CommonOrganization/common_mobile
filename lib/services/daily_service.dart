import 'dart:developer';

import 'package:common/models/daily/daily.dart';
import 'package:common/services/data_service.dart';
import 'package:common/services/upload_service.dart';
import 'package:image_picker/image_picker.dart';

import 'firebase_service.dart';

class DailyService {
  static final DailyService _instance = DailyService._internal();
  factory DailyService() => _instance;
  DailyService._internal();

  static const String collection = 'daily';

  static Future<List<Daily>> getRecommendDaily() async {
    try {
      // 1. 카테고리 ( 가중치 1순위)
      // 2. 올린 일자 (가중치 2순위 - 30일을 기준 오늘부터 30일)
      DateTime nowDate = DateTime.now();
      String imageRef = '/daily/${nowDate.microsecondsSinceEpoch}';
      return [];
    } catch (e) {
      log('DailyService - uploadDailyImage Failed : $e');
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
}
