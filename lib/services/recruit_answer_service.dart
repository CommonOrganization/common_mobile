import 'dart:developer';
import 'package:common/models/recruit_answer/recruit_answer.dart';

import 'firebase_service.dart';

class RecruitAnswerService {
  static final RecruitAnswerService _instance =
      RecruitAnswerService._internal();
  factory RecruitAnswerService() => _instance;
  RecruitAnswerService._internal();

  static Future<void> uploadRecruitAnswer(
      {required RecruitAnswer recruitAnswer}) async {
    try {
      await FirebaseService.fireStore
          .collection('recruitAnswer')
          .add(recruitAnswer.toJson());
    } catch (e) {
      log('RecruitAnswerService - uploadRecruitAnswer Failed : $e');
    }
  }

  static Future<RecruitAnswer?> getRecruitAnswer(
      {required String gatheringId, required String userId}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection('recruitAnswer')
          .where('gatheringId', isEqualTo: gatheringId)
          .where('userId', isEqualTo: userId)
          .orderBy('timeStamp', descending: true)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return RecruitAnswer.fromJson(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      log('RecruitAnswerService - getRecruitAnswer Failed : $e');
      return null;
    }
  }
}
