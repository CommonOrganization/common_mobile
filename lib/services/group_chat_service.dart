import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/constants_enum.dart';
import '../models/chat/chat.dart';
import '../models/personal_chat/personal_chat.dart';
import 'chat_service.dart';

class GroupChatService implements ChatService<PersonalChat> {
  static final GroupChatService _instance = GroupChatService._internal();
  factory GroupChatService() => _instance;
  GroupChatService._internal();

  static const String collection = 'personalChat';

  @override
  Future<String?> startChat(
      {required List userIdList}) async {
    try {

    } catch (e) {
      log('GroupChatService - startPersonalChat Failed : $e');
      return null;
    }
  }

  @override
  Future<List<PersonalChat>> getUserChat({required String userId}) async {
    try {
      return [];
    } catch (e) {
      log('GroupChatService - getUserChat Failed : $e');
      return [];
    }
  }

  @override
  Future<PersonalChat?> getChatRoom({required String chatId}) async {
    try {

    } catch (e) {
      log('GroupChatService - getChatRoom Failed : $e');
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
    // TODO: implement getLastChat
    throw UnimplementedError();
  }

  @override
  void sendText(
      {required String chatId,
        required String userId,
        required String text})  {
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
      log('GroupChatService - sendText Failed : $e');
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
      log('GroupChatService - sendImage Failed : $e');
    }
  }


}
