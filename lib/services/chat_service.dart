import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/models/chat/chat.dart';

abstract class ChatService<T> {
  Future<String?> startChat({required List userIdList, String? title});
  Stream<QuerySnapshot<Map<String,dynamic>>> getUserChat({required String userId});
  Future<T?> getChatRoom({required String chatId});
  Future<Chat?> getLastChat({required String chatId});
  Future<bool> leaveChatRoom({required String userId,required String chatId});
  Future<List<Chat>?> getAlbum({required String chatId});
  Stream<QuerySnapshot<Map<String, dynamic>>> getChat({required String chatId});

  void sendText(
      {required String chatId, required String userId, required String text});
  void sendImage(
      {required String chatId,
      required String userId,
      required List<String> images});
}
