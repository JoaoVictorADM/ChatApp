import 'message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final String user1Id;
  final String user2Id;
  final Message? lastMessage;

  Chat({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.lastMessage,
  });

  factory Chat.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Chat(
      id: doc.id,
      user1Id: data['user1Id'] ?? '',
      user2Id: data['user2Id'] ?? '',
      lastMessage:
          data['lastMessage'] != null
              ? Message(
                id: '', // pode ajustar conforme precisar
                senderId: data['lastMessage']['senderId'],
                text: data['lastMessage']['text'],
                timestamp:
                    (data['lastMessage']['timestamp'] as Timestamp).toDate(),
              )
              : null,
    );
  }
}
