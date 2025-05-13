import 'package:uuid/uuid.dart';
import '../../model/chat.dart';
import 'chat_repository.dart';
import '../exception/chat_exception.dart';

class ChatMemoryRepository implements ChatRepository {
  final _chats = <String, Chat>{};
  final _uuid = Uuid();

  @override
  Future<List<Chat>> getChats(String userId) async {
    return _chats.values
        .where((c) => c.user1Id == userId || c.user2Id == userId)
        .toList();
  }

  @override
  Future<Chat> createChat(String user1Id, String user2Id) async {
    if (await _chatExistsBetweenUsers(user1Id, user2Id)) {
      throw ChatException("Você já possui um chat com esse usuário");
    }

    final chat = Chat(
      id: _uuid.v4(),
      user1Id: user1Id,
      user2Id: user2Id,
      lastMessage: null,
    );

    _chats[chat.id] = chat;

    return chat;
  }

  Future<bool> _chatExistsBetweenUsers(String user1Id, String user2Id) async {
    return _chats.values.any(
      (chat) =>
          (chat.user1Id == user1Id && chat.user2Id == user2Id) ||
          (chat.user1Id == user2Id && chat.user2Id == user1Id),
    );
  }
}
