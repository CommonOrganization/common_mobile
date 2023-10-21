import 'dart:developer';
import 'package:common/constants/constants_enum.dart';
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
      log('GatheringService - uploadGatheringImage Failed : $e');
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
      log('GatheringService - uploadGathering Failed : $e');
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
      log('GatheringService - updateGathering Failed : $e');
      return false;
    }
  }

  static Future<void> deleteGathering(
      {required String category, required String id}) async {
    try {
      await FirebaseService.fireStore.collection(category).doc(id).delete();
    } catch (e) {
      log('GatheringService - deleteGathering Failed : $e');
    }
  }

  static Future<bool> applyGathering({
    required String category,
    required String id,
    required String userId,
    required String recruitWay,
  }) async {
    try {
      // 만약 선착순일경우 applicantList를 굳이 손댈 이유가 없기때문
      // 바로 멤버에 추가를 해주면 된다.
      if (recruitWay == RecruitWay.firstCome.name) {
        await FirebaseService.fireStore.runTransaction((transaction) async {
          final snapshot = await transaction
              .get(FirebaseService.fireStore.collection(category).doc(id));
          if (snapshot.exists) {
            List memberList = snapshot.get('memberList');
            if (memberList.contains(userId)) {
              return false;
            }
            memberList.add(userId);
            transaction.update(
                FirebaseService.fireStore.collection(category).doc(id), {
              'memberList': memberList,
            });
          }
        });
        return true;
      }
      // 이경우 승인제이기때문에 승인이 필요 -> applicantList에만 추가, 추후 승인을 해주는 형태
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
      log('GatheringService - applyGathering Failed : $e');
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
      log('GatheringService - approveGathering Failed : $e');
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
      log('GatheringService - disapproveGathering Failed : $e');
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
      log('GatheringService - get Failed : $e');
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
      log('GatheringService - update Failed : $e');
      return false;
    }
  }
}
