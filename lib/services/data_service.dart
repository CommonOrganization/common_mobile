import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_service.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();
  //Data
  //Search - gathering, feed, etc

  static const String collection = 'data';

  static Future<void> addSearchGatheringWord({required String word}) async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(collection)
          .doc('search')
          .collection('gathering')
          .where('word', isEqualTo: word)
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          final wordData = await FirebaseService.fireStore
              .collection(collection)
              .doc('search')
              .collection('gathering')
              .doc(doc.id)
              .get();
          int count = wordData.get('count');
          await FirebaseService.fireStore
              .collection(collection)
              .doc('search')
              .collection('gathering')
              .doc(doc.id)
              .update({'count': count + 1});
        }
        return;
      }
      await FirebaseService.fireStore
          .collection(collection)
          .doc('search')
          .collection('gathering')
          .add({
        'word': word,
        'count': 1,
      });
    } catch (e) {
      log('DataService - addSearchGatheringWord Failed : $e');
    }
  }

  static Future<List> getSearchGatheringPopularWord() async {
    try {
      final snapshot = await FirebaseService.fireStore
          .collection(collection)
          .doc('search')
          .collection('gathering')
          .orderBy('count',descending: true)
          .get();

      if(snapshot.docs.isEmpty) return [];
      return snapshot.docs.map((word)=>word.get('word')).toList();
    } catch (e) {
      log('DataService - getSearchGatheringPopularWord Failed : $e');
      return [];
    }
  }

  static Future<String?> getId({required String name}) async {
    try {
      String? id;
      await FirebaseFirestore.instance.runTransaction((transaction) async{
        DocumentReference documentReference = FirebaseFirestore.instance.collection(collection).doc(name);
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        int count = snapshot.get('count');
        transaction.update(documentReference, {'count':count+1});

        id = '$name${count.toString().padLeft(8,'0')}';
      });

      return id;
    } catch (e) {
      log('DataService - getId Failed : $e');
      return null;
    }
  }
}
