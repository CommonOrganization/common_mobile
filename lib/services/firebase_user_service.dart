import 'dart:developer';
import 'package:common/models/user/user.dart';
import 'package:common/services/firebase_upload_service.dart';
import 'package:image_picker/image_picker.dart';
import 'firebase_service.dart';
import 'firebase_util_service.dart';

class FirebaseUserService {
  static final FirebaseUserService _instance = FirebaseUserService();
  factory FirebaseUserService() => _instance;

  static Future<String?> uploadProfileImage({required XFile image}) async {
    try {
      DateTime nowDate = DateTime.now();
      String imageRef = '/user/${nowDate.microsecondsSinceEpoch}';
      return await FirebaseUploadService.uploadImage(
          image: image, imageRef: imageRef);
    } catch (e) {
      log('FirebaseUserService - uploadUserImage Failed : $e');
      return null;
    }
  }

  static Future<bool> register({required Map<String, dynamic> userData}) async {
    try {
      String? id = await FirebaseUtilService.getId(path: 'user');
      if (id == null) return false;
      Map<String, dynamic> userInfo = {
        'id': id,
        ...userData,
      };
      await FirebaseService.fireStore.collection('user').doc(id).set(userInfo);
      return true;
    } catch (e) {
      log('FirebaseUserService - register Failed : $e');
      return false;
    }
  }

  static Future<User?> login(
      {required String phone, required String password}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection('user')
          .where('phone', isEqualTo: phone)
          .where('password', isEqualTo: password)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return User.fromJson(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      log('FirebaseUserService - login Failed : $e');
      return null;
    }
  }

  static Future<User?> refresh({required String id}) async {
    try {
      final snapshot =
          await FirebaseService.fireStore.collection('user').doc(id).get();

      if (snapshot.exists) {
        return User.fromJson(snapshot.data()!);
      }
      return null;
    } catch (e) {
      log('FirebaseUserService - refresh Failed : $e');
      return null;
    }
  }

  static Future<bool> update(
      {required String id,
      required String field,
      required String value}) async {
    try {
      await FirebaseService.fireStore
          .collection('user')
          .doc(id)
          .update({field: value});
      return true;
    } catch (e) {
      log('FirebaseUserService - update Failed : $e');
      return false;
    }
  }

  static Future<bool> duplicate(
      {required String field, required String value}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection('user')
          .where(field, isEqualTo: value)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      log('FirebaseUserService - duplicate Failed : $e');
      return false;
    }
  }

  static Future<bool> updatePassword({
    required String phone,
    required String newPassword,
  }) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection('user')
          .where('phone', isEqualTo: phone)
          .get();

      if(snapshot.docs.isNotEmpty){
        for (var userSnapshot in snapshot.docs) {
          await FirebaseService.fireStore
              .collection('user')
              .doc(userSnapshot.id).update({'password':newPassword});
        }
        return true;
      }
      return false;
    } catch (e) {
      log('FirebaseUserService - updatePassword Failed : $e');
      return false;
    }
  }
}
