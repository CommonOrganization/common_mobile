import 'dart:developer';
import 'package:common/services/firebase_service.dart';
import 'package:common/services/upload_service.dart';
import 'package:image_picker/image_picker.dart';

//모임 공통 기능
class GatheringService {
  static final GatheringService _instance = GatheringService._internal();
  factory GatheringService() => _instance;
  GatheringService._internal();

  static Future<String?> uploadGatheringImage({required XFile image}) async {
    try {
      DateTime nowDate = DateTime.now();
      String imageRef = '/gathering/${nowDate.microsecondsSinceEpoch}';
      return await UploadService.uploadImage(image: image, imageRef: imageRef);
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

  static Future<bool> updateGathering(
      {required String category,
      required String id,
      required Map<String, dynamic> data}) async {
    try {
      data.remove('memberList');
      data.remove('applicantList');
      await FirebaseService.fireStore.collection(category).doc(id).update(data);
      return true;
    } catch (e) {
      log('FirebaseGatheringService - updateGathering Failed : $e');
      return false;
    }
  }

  static Future<void> deleteGathering(
      {required String category, required String id}) async {
    try {
      await FirebaseService.fireStore.collection(category).doc(id).delete();
    } catch (e) {
      log('FirebaseGatheringService - deleteGathering Failed : $e');
    }
  }

  static Future<bool> applyGathering(
      {required String category,
      required String id,
      required String userId}) async {
    try {
      bool applySuccess = true;
      await FirebaseService.fireStore.runTransaction((transaction) async {
        final snapshot = await transaction
            .get(FirebaseService.fireStore.collection(category).doc(id));
        if (snapshot.exists) {
          List applicantList = snapshot.get('applicantList');
          if (applicantList.contains(userId)) {
            applySuccess = false;
            return;
          }
          applicantList.add(userId);
          transaction
              .update(FirebaseService.fireStore.collection(category).doc(id), {
            'applicantList': applicantList,
          });
        }
      });
      return applySuccess;
    } catch (e) {
      log('FirebaseGatheringService - applyGathering Failed : $e');
      return false;
    }
  }

  static Future<void> approveGathering(
      {required String category,
      required String id,
      required String applicantId}) async {
    try {
      await FirebaseService.fireStore.runTransaction((transaction) async {
        final snapshot = await transaction
            .get(FirebaseService.fireStore.collection(category).doc(id));
        if (snapshot.exists) {
          List applicantList = snapshot.get('applicantList');
          List memberList = snapshot.get('memberList');
          applicantList.remove(applicantId);
          memberList.add(applicantId);
          transaction
              .update(FirebaseService.fireStore.collection(category).doc(id), {
            'applicantList': applicantList,
            'memberList': memberList,
          });
        }
      });
    } catch (e) {
      log('FirebaseGatheringService - approveGathering Failed : $e');
    }
  }

  static Future<void> disapproveGathering(
      {required String category,
        required String id,
        required String applicantId}) async {
    try {
      await FirebaseService.fireStore.runTransaction((transaction) async {
        final snapshot = await transaction
            .get(FirebaseService.fireStore.collection(category).doc(id));
        if (snapshot.exists) {
          List applicantList = snapshot.get('applicantList');
          applicantList.remove(applicantId);
          transaction
              .update(FirebaseService.fireStore.collection(category).doc(id), {
            'applicantList': applicantList,
          });
        }
      });
    } catch (e) {
      log('FirebaseGatheringService - disapproveGathering Failed : $e');
    }
  }

  static Future<dynamic> get(
      {required String category,
      required String id,
      required String field}) async {
    try {
      final snapshot =
          await FirebaseService.fireStore.collection(category).doc(id).get();
      if (snapshot.exists) {
        return snapshot.get(field);
      }
      return null;
    } catch (e) {
      log('FirebaseGatheringService - get Failed : $e');
      return false;
    }
  }

  static Future<bool> update(
      {required String category,
      required String id,
      required String field,
      required dynamic value}) async {
    try {
      await FirebaseService.fireStore
          .collection(category)
          .doc(id)
          .update({field: value});
      return true;
    } catch (e) {
      log('FirebaseGatheringService - update Failed : $e');
      return false;
    }
  }
}
