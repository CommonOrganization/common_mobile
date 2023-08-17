import 'dart:developer';
import 'firebase_service.dart';

class UtilService {
  static final UtilService _instance = UtilService._internal();
  factory UtilService() => _instance;
  UtilService._internal();

  static Future<String?> getId({required String path}) async {
    try {
      final snapshot =
          await FirebaseService.fireStore.collection('count').doc(path).get();
      int count = snapshot.get('count');
      await FirebaseService.fireStore
          .collection('count')
          .doc(path)
          .update({'count': count + 1});

      return '$path${count.toString().padLeft(8, '0')}';
    } catch (e) {
      log('FirebaseUtilService - getId Failed : $e');
      return null;
    }
  }
}
