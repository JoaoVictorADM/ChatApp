import '../model/message.dart';

abstract class MessageRepository {
  Future<List<Message>> getMessages(String chatId);
  Future<Message> sendMessage(String chatId, String senderId, String text);
}
