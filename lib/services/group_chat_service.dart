import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/models/group_chat/group_chat.dart';
import '../constants/constants_enum.dart';
import '../models/chat/chat.dart';
import 'chat_service.dart';
import 'data_service.dart';

class GroupChatService implements ChatService<GroupChat> {
  static final GroupChatService _instance = GroupChatService._internal();
  factory GroupChatService() => _instance;
  GroupChatService._internal();

  static const String collection = 'groupChat';

  @override
  Future<String?> startChat({
    required List userIdList,
    String? title,
  }) async {
    try {
      if (title == null || title.isEmpty) return null;
      // 존재하지 않는 채팅방 -> 새로 만들어주어야함
      String? groupChatId = await DataService.getId(name: collection);
      if (groupChatId == null) return null;
      DateTime nowDate = DateTime.now();
      GroupChat groupChat = GroupChat(
        id: groupChatId,
        userIdList: userIdList,
        title: title,
        timeStamp: nowDate.toString(),
      );

      await FirebaseFirestore.instance
          .collection(collection)
          .doc(groupChatId)
          .set(groupChat.toJson());
      return groupChatId;
    } catch (e) {
      log('GroupChatService - startChat Failed : $e');
      return null;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChat(
      {required String userId}) {
    try {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('userIdList', arrayContains: userId)
          .snapshots();
    } catch (e) {
      log('GroupChatService - getUserChat Failed : $e');
      return const Stream.empty();
    }
  }

  @override
  Future<GroupChat?> getChatRoom({required String chatId}) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(chatId)
          .get();

      if (snapshot.exists) {
        return GroupChat.fromJson(snapshot.data() as Map<String, dynamic>);
      }
      return null;
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
  Future<Chat?> getLastChat({required String chatId}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection(collection)
          .doc(chatId)
          .collection('chat')
          .orderBy('timeStamp', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return Chat.fromJson(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      log('GroupChatService - getLastChat Failed : $e');
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

  @override
  Future<bool> leaveChatRoom(
      {required String userId, required String chatId}) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(chatId)
          .get();

      if (snapshot.exists) {
        List userIdList = snapshot.get('userIdList');
        userIdList.remove(userId);
        await FirebaseFirestore.instance
            .collection(collection)
            .doc(chatId)
            .update({
          'userIdList': userIdList,
        });
        return true;
      }
      return false;
    } catch (e) {
      log('GroupChatService - leaveChatRoom Failed : $e');
      return false;
    }
  }

  @override
  Future<List<Chat>?> getAlbum({required String chatId}) async{
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(chatId)
          .collection('chat')
          .where('messageType', isEqualTo: 'image')
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((document) => Chat.fromJson(document.data()))
            .toList();
      }
      return null;
    } catch (e) {
      log('GroupChatService - getAlbum Failed : $e');
      return null;
    }
  }
}
