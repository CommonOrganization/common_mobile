import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/services/firebase_service.dart';
import 'package:common/services/firebase_upload_service.dart';
import 'package:image_picker/image_picker.dart';

//모임 공통 기능
class FirebaseGatheringService {
  static final FirebaseGatheringService _instance = FirebaseGatheringService();
  factory FirebaseGatheringService() => _instance;

  static Future<String?> uploadGatheringImage({required XFile image}) async {
    try {
      DateTime nowDate = DateTime.now();
      String imageRef = '/gathering/${nowDate.microsecondsSinceEpoch}';
      return await FirebaseUploadService.uploadImage(
          image: image, imageRef: imageRef);
    } catch (e) {
      log('FirebaseGatheringService - uploadGatheringImage Failed : $e');
      return null;
    }
  }

  static Future<String?> getId({required String category}) async {
    try {
      if (category != 'oneDayGathering' && category != 'clubGathering') {
        return null;
      }
      String? id;
      await FirebaseService.fireStore.runTransaction((transaction) async {
        final snapshot = await transaction
            .get(FirebaseService.fireStore.collection('count').doc(category));
        if (snapshot.exists) {
          int count = snapshot.get('count');
          id = '$category${count.toString().padLeft(8, '0')}';
          transaction.update(
              FirebaseService.fireStore.collection('count').doc(category), {
            'count': count + 1,
          });
        }
      });
      return id;
    } catch (e) {
      log('FirebaseGatheringService - getId Failed : $e');
      return null;
    }
  }

  static Future<bool> uploadGathering(
      {required String category,
      required String id,
      required Map<String, dynamic> data}) async {
    try {
      await FirebaseService.fireStore.collection(category).doc(id).set(data);
      return true;
    } catch (e) {
      log('FirebaseGatheringService - uploadGathering Failed : $e');
      return false;
    }
  }

  static Future<bool> applyGathering(
      {required String category,
      required String id,
      required String userId}) async {
    try {
      await FirebaseService.fireStore.runTransaction((transaction) async {
        final snapshot = await transaction
            .get(FirebaseService.fireStore.collection(category).doc(id));
        if (snapshot.exists) {
          List applicantList = snapshot.get('applicantList');
          if (applicantList.contains(userId)) return false;
          applicantList.add(userId);
          transaction.update(
              FirebaseService.fireStore.collection(category).doc(id), {
            'applicantList': applicantList,
          });
        }
      });
      return true;
    } catch (e) {
      log('FirebaseGatheringService - applyGathering Failed : $e');
      return false;
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getGathering({
    required String category,
  }) async =>
      await FirebaseService.fireStore.collection(category).get();
}
