import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'firebase_service.dart';

import 'package:http/http.dart' as http;

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

      // var request = http.MultipartRequest('POST',Uri.parse("http://localhost:8080/api/upload/image/gathering"));
      //
      // request.files.add(await http.MultipartFile.fromPath("file",file.path));
      //
      // var result = await request.send();
      // final bodyBytes =  await result.stream.toBytes();
      // final responseBody = utf8.decode(bodyBytes);
      //
      // print(responseBody);
      // return responseBody;
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
