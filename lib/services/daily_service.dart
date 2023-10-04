import 'dart:developer';

import 'package:common/services/data_service.dart';
import 'package:common/services/upload_service.dart';
import 'package:image_picker/image_picker.dart';

import 'firebase_service.dart';

class DailyService {
  static final DailyService _instance = DailyService._internal();
  factory DailyService() => _instance;
  DailyService._internal();

  static const String collection = 'daily';

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

  static Future<bool> uploadDaily({required Map<String, dynamic> data}) async {
    try {
      String? dailyId = await DataService.getId(name: collection);
      if (dailyId == null) return false;
      await FirebaseService.fireStore
          .collection(collection)
          .doc(dailyId)
          .set(data);
      return true;
    } catch (e) {
      log('DailyService - uploadDaily Failed : $e');
      return false;
    }
  }
}
