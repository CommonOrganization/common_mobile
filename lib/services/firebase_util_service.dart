import 'dart:developer';
import 'firebase_service.dart';

class FirebaseUtilService {
  static final FirebaseUtilService _instance = FirebaseUtilService();
  factory FirebaseUtilService() => _instance;

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
