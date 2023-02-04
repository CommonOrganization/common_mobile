import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'firebase_service.dart';

class FirebaseUploadService {
  static final FirebaseUploadService _instance = FirebaseUploadService();
  factory FirebaseUploadService() => _instance;

  static Future<String?> uploadImage(
      {required XFile image, required String imageRef}) async {
    try {
      File file = File(image.path);
      var task = await FirebaseService.fireStorage.ref(imageRef).putFile(file);
      return await task.ref.getDownloadURL();
    } catch (e) {
      log('FirebaseUploadService - uploadImage Failed : $e');
      return null;
    }
  }
}
