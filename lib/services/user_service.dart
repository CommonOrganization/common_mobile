import 'dart:developer';
import 'package:common/models/user/user.dart';
import 'package:common/services/data_service.dart';
import 'package:common/services/upload_service.dart';
import 'package:image_picker/image_picker.dart';
import 'firebase_service.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  static const String collection = 'user';
  // TODO
  static Future<String?> uploadProfileImage({required XFile image}) async {
    try {
      DateTime nowDate = DateTime.now();
      String imageRef = '/user/${nowDate.microsecondsSinceEpoch}';
      return await UploadService.uploadImage(image: image, imageRef: imageRef);
    } catch (e) {
      log('UserService - uploadUserImage Failed : $e');
      return null;
    }
  }

  static Future<User?> register(
      {required Map<String, dynamic> userData}) async {
    try {
      String? id = await DataService.getId(name: 'user');
      if (id == null) return null;
      Map<String, dynamic> userInfo = {
        'id': id,
        ...userData,
      };
      await FirebaseService.fireStore
          .collection(collection)
          .doc(id)
          .set(userInfo);
      return User.fromJson(userInfo);
    } catch (e) {
      log('UserService - register Failed : $e');
      return null;
    }
  }

  static Future<User?> login(
      {required String email, required String password}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(collection)
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return User.fromJson(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      log('UserService - login Failed : $e');
      return null;
    }
  }

  static Future<bool> leave({required String userId}) async {
    try {
      await FirebaseService.fireStore
          .collection(collection)
          .doc(userId)
          .delete();
      return true;
    } catch (e) {
      log('UserService - leave Failed : $e');
      return false;
    }
  }

  static Future<bool> update(
      {required String id,
      required String field,
      required dynamic value}) async {
    try {
      await FirebaseService.fireStore
          .collection(collection)
          .doc(id)
          .update({field: value});
      return true;
    } catch (e) {
      log('UserService - update Failed : $e');
      return false;
    }
  }

  static Future<bool> multiUpdate({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      await FirebaseService.fireStore
          .collection(collection)
          .doc(id)
          .update(data);
      return true;
    } catch (e) {
      log('UserService - multiUpdate Failed : $e');
      return false;
    }
  }
  // TODO
  static Future<dynamic> get(
      {required String id, required String field}) async {
    try {
      final snapshot =
          await FirebaseService.fireStore.collection(collection).doc(id).get();
      if (snapshot.exists) {
        return snapshot.get(field);
      }
      return null;
    } catch (e) {
      log('UserService - get Failed : $e');
      return null;
    }
  }

  static Future<User?> getUser({required String id}) async {
    try {
      final snapshot =
          await FirebaseService.fireStore.collection(collection).doc(id).get();
      if (snapshot.exists) {
        return User.fromJson(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      log('UserService - getUser Failed : $e');
      return null;
    }
  }

  static Future<bool> duplicate(
      {required String field, required String value}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(collection)
          .where(field, isEqualTo: value)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      log('UserService - duplicate Failed : $e');
      return false;
    }
  }

  static Future<bool> updatePassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(collection)
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var userSnapshot in snapshot.docs) {
          await FirebaseService.fireStore
              .collection(collection)
              .doc(userSnapshot.id)
              .update({'password': newPassword});
        }
        return true;
      }
      return false;
    } catch (e) {
      log('UserService - updatePassword Failed : $e');
      return false;
    }
  }
}
