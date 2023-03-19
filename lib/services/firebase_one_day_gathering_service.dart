import 'dart:developer';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/services/firebase_gathering_service.dart';

class FirebaseOneDayGatheringService {
  static final FirebaseOneDayGatheringService _instance =
      FirebaseOneDayGatheringService();
  factory FirebaseOneDayGatheringService() => _instance;

  static const String _category = 'oneDayGathering';

  static Future<bool> uploadGathering(
      {required OneDayGathering gathering}) async {
    try {
      String? id = await FirebaseGatheringService.getId(category: _category);
      if (id == null) return false;
      Map<String, dynamic> gatheringData = gathering.toJson();
      gatheringData['id'] = id;
      return await FirebaseGatheringService.uploadGathering(
        category: _category,
        id: id,
        data: gatheringData,
      );
    } catch (e) {
      log('FirebaseOneDayGatheringService - uploadGathering Failed : $e');
      return false;
    }
  }
}
