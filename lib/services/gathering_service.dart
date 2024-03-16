import 'dart:developer';
import 'package:common/constants/constants_enum.dart';
import 'package:common/constants/constants_value.dart';
import 'package:common/models/gathering_apply_status/gathering_apply_status.dart';
import 'package:common/services/firebase_service.dart';
import 'package:common/services/upload_service.dart';
import 'package:common/utils/gathering_utils.dart';
import 'package:image_picker/image_picker.dart';

import '../models/gathering/gathering.dart';

//모임 공통 기능
class GatheringService {
  static final GatheringService _instance = GatheringService._internal();

  factory GatheringService() => _instance;

  GatheringService._internal();

  static const String statusCollection = 'gatheringStatus';

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
      FirebaseService.fireStore.runTransaction((transaction) async {
        transaction.set(
            FirebaseService.fireStore.collection(category).doc(id), data);
        GatheringApplyReturn applyReturn = await applyGathering(
            id: id,
            userId: data['organizerId'],
            recruitWay: RecruitWay.firstCome.name,
            capacity: data['capacity']);

        if (applyReturn != GatheringApplyReturn.success) {
          throw Exception('잠시 후에 다시 실행해주세요');
        }
      });
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

  static Future<GatheringApplyReturn> applyGathering({
    required String id,
    required String userId,
    required String recruitWay,
    required int capacity,
  }) async {
    try {
      GatheringStatus status;
      if (recruitWay == RecruitWay.firstCome.name) {
        status = GatheringStatus.member;
      } else {
        status = GatheringStatus.apply;
      }
      GatheringApplyStatus applyStatus = GatheringApplyStatus(
        status: status.name,
        gatheringId: id,
        applierId: userId,
      );

      final snapshot = await FirebaseService.fireStore
          .collection(statusCollection)
          .where('gatheringId', isEqualTo: applyStatus.gatheringId)
          .where('applierId', isEqualTo: applyStatus.applierId)
          .get();
      if (snapshot.docs.isNotEmpty) return GatheringApplyReturn.already;
      if (snapshot.docs.length >= capacity) return GatheringApplyReturn.full;
      await FirebaseService.fireStore
          .collection(statusCollection)
          .add(applyStatus.toJson());
      return GatheringApplyReturn.success;
    } catch (e) {
      log('GatheringService - applyGathering Failed : $e');
      return GatheringApplyReturn.failed;
    }
  }

  static Future<void> approveGathering(
      {required String category,
      required String id,
      required String applierId}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(statusCollection)
          .where('gatheringId', isEqualTo: id)
          .where('applierId', isEqualTo: applierId)
          .get();

      if (snapshot.docs.isEmpty) return;
      await FirebaseService.fireStore.runTransaction((transaction) async {
        for (var element in snapshot.docs) {
          transaction.update(
              FirebaseService.fireStore
                  .collection(statusCollection)
                  .doc(element.id),
              {
                'status': GatheringStatus.member.name,
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
      required String applierId}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(statusCollection)
          .where('gatheringId', isEqualTo: id)
          .where('applierId', isEqualTo: applierId)
          .get();

      if (snapshot.docs.isEmpty) return;
      await FirebaseService.fireStore.runTransaction((transaction) async {
        for (var element in snapshot.docs) {
          transaction.delete(FirebaseService.fireStore
              .collection(statusCollection)
              .doc(element.id));
        }
      });
    } catch (e) {
      log('GatheringService - disapproveGathering Failed : $e');
    }
  }

  static Future<GatheringApplyStatus?> getGatheringApplyStatus({
    required String id,
    required String userId,
  }) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(statusCollection)
          .where('gatheringId', isEqualTo: id)
          .where('applierId', isEqualTo: userId)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return GatheringApplyStatus.fromJson(snapshot.docs.first.data());
    } catch (e) {
      log('GatheringService - getGatheringApplyStatus Failed : $e');
      return null;
    }
  }

  static Future<List<String>> getUserParticipatingGatheringIdList({
    required String userId,
  }) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(statusCollection)
          .where('applierId', isEqualTo: userId)
          .where('status', isEqualTo: 'member')
          .get();

      if (snapshot.docs.isEmpty) return [];
      return snapshot.docs.map((e) => e.get('gatheringId') as String).toList();
    } catch (e) {
      log('GatheringService - getUserParticipatingGatheringIdList Failed : $e');
      return [];
    }
  }

  static Future<List<String>> getGatheringMemberList(
      {required String id}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(statusCollection)
          .where('gatheringId', isEqualTo: id)
          .where('status', isEqualTo: GatheringStatus.member.name)
          .get();

      return snapshot.docs
          .map((doc) => doc.get('applierId') as String)
          .toList();
    } catch (e) {
      log('GatheringService - getGatheringMemberList Failed : $e');
      return [];
    }
  }

  static Future<List<String>> getGatheringApplierList({
    required String id,
  }) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(statusCollection)
          .where('gatheringId', isEqualTo: id)
          .where('status', isEqualTo: GatheringStatus.apply.name)
          .get();

      return snapshot.docs
          .map((doc) => doc.get('applierId') as String)
          .toList();
    } catch (e) {
      log('GatheringService - getGatheringApplierList Failed : $e');
      return [];
    }
  }

  static Future<List<Gathering>> getParticipatingGatheringList({
    required String userId,
    required String category, // kOneDayGathering or kClubGathering
  }) async {
    try {
      List gatheringList = [];
      await FirebaseService.fireStore.runTransaction((transaction) async {
        final snapshot = await FirebaseService.fireStore
            .collection(statusCollection)
            .where('applierId', isEqualTo: userId)
            .where('status', isEqualTo: 'member')
            .get();

        if (snapshot.docs.isEmpty) return [];
        List gatheringIdList = snapshot.docs
            .map((document) => document.get('gatheringId'))
            .toList();

        List result = [];

        for (var id in gatheringIdList) {
          final gathering = await transaction
              .get(FirebaseService.fireStore.collection(category).doc(id));
          if (gathering.exists) {
            result.add(gathering.data());
          }
        }
        gatheringList = result;
      });
      if (category == kOneDayGatheringCategory) {
        return getOneDayGatheringListByGatheringList(gatheringList);
      }
      return getClubGatheringListByGatheringList(gatheringList);
    } catch (e) {
      log('GatheringService - getParticipatingGatheringList Failed : $e');
      return [];
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
