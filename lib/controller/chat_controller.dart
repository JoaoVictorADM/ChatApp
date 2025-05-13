// chat_controller.dart
import '../model/chat.dart';
import '../model/message.dart';
import '../repository/chat_repository.dart';
import '../repository/message_repository.dart';

class ChatController {
  final ChatRepository chatRepository;
  final MessageRepository messageRepository;

  ChatController({
    required this.chatRepository,
    required this.messageRepository,
  });

  Future<List<Chat>> getUserChats(String userId) {
    return chatRepository.getChats(userId);
  }

  Future<Chat> createChat(String user1Id, String user2Id) {
    return chatRepository.createChat(user1Id, user2Id);
  }

  Future<List<Message>> getChatMessages(String chatId) {
    return messageRepository.getMessages(chatId);
  }

  Future<Message> sendMessage(String chatId, String senderId, String text) {
    return messageRepository.sendMessage(chatId, senderId, text);
  }
}
