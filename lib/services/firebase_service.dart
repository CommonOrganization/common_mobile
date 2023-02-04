import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService();
  factory FirebaseService() => _instance;

  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static final FirebaseStorage _fireStorage = FirebaseStorage.instance;

  static FirebaseFirestore get fireStore => _fireStore;
  static FirebaseStorage get fireStorage => _fireStorage;
}
