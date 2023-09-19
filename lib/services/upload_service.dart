import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'firebase_service.dart';

class UploadService {
  static final UploadService _instance = UploadService._internal();
  factory UploadService() => _instance;
  UploadService._internal();

  static Future<String?> uploadImage(
      {required XFile image, required String imageRef}) async {
    try {
      File file = File(image.path);
      var task = await FirebaseService.fireStorage.ref(imageRef).putFile(file);
      return await task.ref.getDownloadURL();
    } catch (e) {
      log('UploadService - uploadImage Failed : $e');
      return null;
    }
  }

  static Future<List<String>> uploadImageList({required List<XFile> imageList}) async {
    try {
      List<String> imageUrlList = [];
      DateTime nowDate = DateTime.now();
      for(int i = 0; i < imageList.length; i++){
        String imageRef = '/image/${nowDate.microsecondsSinceEpoch}/$i';
        File file = File(imageList[i].path);
        TaskSnapshot task =
        await FirebaseStorage.instance.ref(imageRef).putFile(file);
        String imageUrl = await task.ref.getDownloadURL();
        imageUrlList.add(imageUrl);
      }

      return imageUrlList;
    } catch (e) {
      log('UploadService - uploadImageList Failed : $e');
      return [];
    }
  }
}
