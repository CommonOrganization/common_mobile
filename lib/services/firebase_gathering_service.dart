import 'dart:developer';
import 'package:common/services/firebase_upload_service.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseGatheringService {
  static final FirebaseGatheringService _instance = FirebaseGatheringService();
  factory FirebaseGatheringService() => _instance;

  static Future<String?> uploadGatheringImage({required XFile image}) async {
    try {
      DateTime nowDate = DateTime.now();
      String imageRef = '/gathering/${nowDate.microsecondsSinceEpoch}';
      return await FirebaseUploadService.uploadImage(
          image: image, imageRef: imageRef);
    } catch (e) {
      log('FirebaseGatheringService - uploadGatheringImage Failed : $e');
      return null;
    }
  }

}
