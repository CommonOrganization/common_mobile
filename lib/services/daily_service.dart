import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/models/daily/daily.dart';
import 'package:common/services/data_service.dart';
import 'package:common/services/upload_service.dart';
import 'package:image_picker/image_picker.dart';

import '../models/comment/comment.dart';
import '../models/reply/reply.dart';
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

  static Future<List<Daily>> getLikeGatheringWithObjectList(
      {required List objectIdList}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseService.fireStore.collection(collection).get();

      return snapshot.docs
          .map((element) => Daily.fromJson(element.data()))
          .where((daily) => objectIdList.contains(daily.id))
          .toList();
    } catch (e) {
      log('DailyService - getLikeGatheringWithObjectList Failed : $e');
      return [];
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

  //댓글 작성하기, 삭제하기, 가져오기, 대댓글 작성하기, 삭제하기, 가져오기
  static Stream<QuerySnapshot<Map<String, dynamic>>> getComment(
      {required String dailyId}) {
    try {
      return FirebaseService.fireStore
          .collection(collection)
          .doc(dailyId)
          .collection('comment')
          .orderBy('timeStamp')
          .snapshots();
    } catch (e) {
      log('DailyService - getComment Failed : $e');
      return const Stream.empty();
    }
  }

  static Future<bool> writeComment({required Comment comment}) async {
    try {
      await FirebaseService.fireStore
          .collection(collection)
          .doc(comment.dailyId)
          .collection('comment')
          .doc(comment.id)
          .set(comment.toJson());
      return true;
    } catch (e) {
      log('DailyService - writeComment Failed : $e');
      return false;
    }
  }

  static Future<bool> deleteComment(
      {required String dailyId, required String commentId}) async {
    try {
      await FirebaseService.fireStore
          .collection(collection)
          .doc(dailyId)
          .collection('comment')
          .doc(commentId)
          .delete();
      return true;
    } catch (e) {
      log('DailyService - deleteComment Failed : $e');
      return false;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getReply(
      {required Comment comment}) {
    try {
      return FirebaseService.fireStore
          .collection(collection)
          .doc(comment.dailyId)
          .collection('comment')
          .doc(comment.id)
          .collection('reply')
          .orderBy('timeStamp')
          .snapshots();
    } catch (e) {
      log('DailyService - getReply Failed : $e');
      return const Stream.empty();
    }
  }

  static Future<bool> writeReply({required Reply reply}) async {
    try {
      await FirebaseService.fireStore
          .collection(collection)
          .doc(reply.dailyId)
          .collection('comment')
          .doc(reply.commentId)
          .collection('reply')
          .doc(reply.id)
          .set(reply.toJson());

      return true;
    } catch (e) {
      log('DailyService - writeReply Failed : $e');
      return false;
    }
  }

  static Future<bool> deleteReply(
      {required String dailyId,
      required String commentId,
      required String replyId}) async {
    try {
      await FirebaseService.fireStore
          .collection(collection)
          .doc(dailyId)
          .collection('comment')
          .doc(commentId)
          .collection('reply')
          .doc(replyId)
          .delete();

      return true;
    } catch (e) {
      log('DailyService - deleteReply Failed : $e');
      return false;
    }
  }
}
