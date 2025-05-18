class Message {
  final String id;
  //final String chatId;
  final String senderId;
  final String text;
  final DateTime timestamp;

  Message({
    required this.id,
    //required this.chatId,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {'senderId': senderId, 'text': text, 'timestamp': timestamp};
  }
}
