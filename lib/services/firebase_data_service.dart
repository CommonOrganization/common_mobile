import 'dart:developer';
import 'firebase_service.dart';

class FirebaseDataService {
  static final FirebaseDataService _instance = FirebaseDataService();
  factory FirebaseDataService() => _instance;
  //Data
  //Search - gathering, feed, etc

  static Future<void> addSearchGatheringWord({required String word}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection('data')
          .doc('search')
          .collection('gathering')
          .where('word', isEqualTo: word)
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          final wordData = await FirebaseService.fireStore
              .collection('data')
              .doc('search')
              .collection('gathering')
              .doc(doc.id)
              .get();
          int count = wordData.get('count');
          await FirebaseService.fireStore
              .collection('data')
              .doc('search')
              .collection('gathering')
              .doc(doc.id)
              .update({'count': count + 1});
        }
        return;
      }
      await FirebaseService.fireStore
          .collection('data')
          .doc('search')
          .collection('gathering')
          .add({
        'word': word,
        'count': 1,
      });
    } catch (e) {
      log('FirebaseDataService - addSearchGatheringWord Failed : $e');
    }
  }

  static Future<List> getSearchGatheringPopularWord() async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection('data')
          .doc('search')
          .collection('gathering')
          .orderBy('count',descending: true)
          .get();

      if(snapshot.docs.isEmpty) return [];
      return snapshot.docs.map((word)=>word.get('word')).toList();
    } catch (e) {
      log('FirebaseDataService - getSearchGatheringPopularWord Failed : $e');
      return [];
    }
  }
}
