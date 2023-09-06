import 'dart:developer';
import 'package:common/models/report/report.dart';

import 'firebase_service.dart';

class ReportService {
  static final ReportService _instance = ReportService._internal();
  factory ReportService() => _instance;
  ReportService._internal();

  static const String collection = 'report';

  static void report(
      {required String reporterId, required String reportedId}) async {
    try {
      DateTime dateTime = DateTime.now();
      Report report = Report(
        reporterId: reporterId,
        reportedId: reportedId,
        timeStamp: dateTime.toString(),
      );
      FirebaseService.fireStore.collection(collection).add(report.toJson());
    } catch (e) {
      log('ReportService - report Failed : $e');
    }
  }
}
