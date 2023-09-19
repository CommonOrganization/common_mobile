import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/constants_enum.dart';
import '../models/chat/chat.dart';
import '../models/personal_chat/personal_chat.dart';
import 'chat_service.dart';
import 'data_service.dart';

class PersonalChatService implements ChatService<PersonalChat> {
  static final PersonalChatService _instance = PersonalChatService._internal();
  factory PersonalChatService() => _instance;
  PersonalChatService._internal();

  static const String collection = 'personalChat';

  @override
  Future<String?> startChat({required List<String> userIdList}) async {
    try {
      String user1Id = userIdList.first;
      String user2Id = userIdList.where((id) => id != user1Id).first;

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where(
            'userIdList',
            arrayContains: user1Id,
          )
          .get();
      List<QueryDocumentSnapshot> documentSnapshot =
          snapshot.docs.where((element) {
        List userIdList = element.get('userIdList');
        return userIdList.contains(user2Id);
      }).toList();
      // 이미 존재하는 채팅방의 경우
      if (documentSnapshot.isNotEmpty) {
        return documentSnapshot.first.id;
      }

      // 존재하지 않는 채팅방 -> 새로 만들어주어야함
      String? personalChatId = await DataService.getId(name: collection);

      if (personalChatId != null) {
        PersonalChat personalChat =
            PersonalChat(id: personalChatId, userIdList: [user1Id, user2Id]);

        await FirebaseFirestore.instance
            .collection(collection)
            .doc(personalChatId)
            .set(personalChat.toJson());
      }
      return personalChatId;
    } catch (e) {
      log('PersonalChatService - startPersonalChat Failed : $e');
      return null;
    }
  }

  @override
  Future<List<PersonalChat>> getUserChat({required String userId}) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where('userIdList', arrayContains: userId)
          .get();

      return snapshot.docs
          .map((document) =>
              PersonalChat.fromJson(document.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log('PersonalChatService - getUserChat Failed : $e');
      return [];
    }
  }

  @override
  Future<PersonalChat?> getChatRoom({required String chatId}) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(chatId)
          .get();

      if (snapshot.exists) {
        return PersonalChat.fromJson(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      log('PersonalChatService - getChatRoom Failed : $e');
      return null;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getChat(
      {required String chatId}) {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(chatId)
        .collection('chat')
        .orderBy('timeStamp')
        .snapshots();
  }

  @override
  Future<Chat?> getLastChat({required String chatId})async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(chatId)
          .collection('chat').orderBy('timeStamp',descending: true).get();

      if (snapshot.docs.isNotEmpty) {
        return Chat.fromJson(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      log('PersonalChatService - getLastChat Failed : $e');
      return null;
    }
  }

  @override
  void sendText(
      {required String chatId, required String userId, required String text}) {
    try {
      DateTime nowDate = DateTime.now();
      Chat textChat = Chat(
        senderId: userId,
        message: text,
        messageType: MessageType.text.name,
        timeStamp: nowDate.toString(),
      );

      FirebaseFirestore.instance
          .collection(collection)
          .doc(chatId)
          .collection('chat')
          .add(textChat.toJson());
    } catch (e) {
      log('PersonalChatService - sendText Failed : $e');
    }
  }

  @override
  void sendImage(
      {required String chatId,
      required String userId,
      required List<String> images}) {
    try {
      DateTime nowDate = DateTime.now();
      Chat textChat = Chat(
        senderId: userId,
        message: images,
        messageType: MessageType.image.name,
        timeStamp: nowDate.toString(),
      );

      FirebaseFirestore.instance
          .collection(collection)
          .doc(chatId)
          .collection('chat')
          .add(textChat.toJson());
    } catch (e) {
      log('PersonalChatService - sendImage Failed : $e');
    }
  }


}
