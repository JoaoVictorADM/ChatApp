import '../model/chat.dart';

abstract class ChatRepository {
  Future<List<Chat>> getChats(String userId);
  Future<Chat> createChat(String user1Id, String user2Id);
}
