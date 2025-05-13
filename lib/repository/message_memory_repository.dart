import 'package:uuid/uuid.dart';
import '../../model/message.dart';
import 'message_repository.dart';

class MessageMemoryRepository implements MessageRepository {
  final _messages = <String, List<Message>>{};
  final _uuid = Uuid();

  @override
  Future<List<Message>> getMessages(String chatId) async {
    return _messages[chatId] ?? [];
  }

  @override
  Future<Message> sendMessage(
    String chatId,
    String senderId,
    String text,
  ) async {
    final msg = Message(
      id: _uuid.v4(),
      chatId: chatId,
      senderId: senderId,
      text: text,
      timestamp: DateTime.now(),
    );

    _messages.putIfAbsent(chatId, () => []).add(msg);

    return msg;
  }
}
