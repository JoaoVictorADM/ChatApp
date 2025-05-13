import 'message.dart';

class Chat {
  final String id;
  final String user1Id;
  final String user2Id;
  final Message? lastMessage;

  Chat({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    this.lastMessage,
  });
}
