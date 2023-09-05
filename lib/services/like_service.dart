import 'dart:developer';
import 'package:common/models/like_object/like_object.dart';
import 'firebase_service.dart';

class LikeService {
  static final LikeService _instance = LikeService._internal();
  factory LikeService() => _instance;
  LikeService._internal();

  static Future<bool> isLikeObject(
      {required String objectId, required String userId}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection('likeObject')
          .where('objectId', isEqualTo: objectId)
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      log('LikeService - isLikeObject Failed : $e');
      return false;
    }
  }

  static Future<void> likeObject(
      {required String objectId, required String userId,required String likeType}) async {
    try {
      LikeObject likeObject = LikeObject(
        userId: userId,
        objectId: objectId,
        likeType: likeType,
        timeStamp: DateTime.now().toString(),
      );
      await FirebaseService.fireStore
          .collection('likeObject')
          .add(likeObject.toJson());
    } catch (e) {
      log('LikeService - likeObject Failed : $e');
    }
  }

  static Future<void> dislikeObject(
      {required String objectId, required String userId}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection('likeObject')
          .where('objectId', isEqualTo: objectId)
          .where('userId', isEqualTo: userId)
          .get();
      for (var document in snapshot.docs) {
        await FirebaseService.fireStore
            .collection('likeObject')
            .doc(document.id)
            .delete();
      }
    } catch (e) {
      log('LikeService - dislikeObject Failed : $e');
    }
  }

  static Future<Map<String,dynamic>?> getLikeObjectMap({required String likeType}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection('likeObject')
          .where('likeType', isEqualTo: likeType)
          .get();
      Map<String, dynamic> likeObjectMap = {};

      for (var document in snapshot.docs) {
        String objectId = document.get('objectId');
        String userId = document.get('userId');
        if (likeObjectMap.containsKey(objectId)) {
          if ((likeObjectMap[objectId] as List).contains(userId)) continue;
          (likeObjectMap[objectId] as List).add(userId);
          continue;
        }
        likeObjectMap[objectId] = [userId];
      }
      return likeObjectMap;
    } catch (e) {
      log('LikeService - getLikeObjectMap Failed : $e');
      return null;
    }
  }

  static Future<int> getLikeObjectCount({required String objectId}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection('likeObject')
          .where('objectId', isEqualTo: objectId)
          .get();

      return snapshot.size;
    } catch (e) {
      log('LikeService - getLikeObjectCount Failed : $e');
      return 0;
    }
  }
}
