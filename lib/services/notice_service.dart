import 'dart:developer';
import 'package:common/models/notice/notice.dart';
import 'firebase_service.dart';

class NoticeService {
  static final NoticeService _instance = NoticeService._internal();
  factory NoticeService() => _instance;
  NoticeService._internal();

  static const String collection = 'notice';

  static Future<List<Notice>> getNoticeList({required String type}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(collection)
          .where('type', isEqualTo: type)
          .orderBy('timeStamp', descending: true)
          .get();
      return snapshot.docs
          .map((document) => Notice.fromJson(document.data()))
          .toList();
    } catch (e) {
      log('NoticeService - getNoticeList Failed : $e');
      return [];
    }
  }
}
