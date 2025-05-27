import 'package:chatpp/controller/auth_controller.dart';
import 'package:chatpp/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/chat.dart';

class ChatController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = AuthController();

  Stream<List<Chat>> getUserChatsStream() {
    final userId = _auth.getCurrentUser()?.uid;
    if (userId == null) return const Stream.empty();

    final query =
        _firestore
            .collection('Chats')
            .where(
              Filter.or(
                Filter('user1Id', isEqualTo: userId),
                Filter('user2Id', isEqualTo: userId),
              ),
            )
            .snapshots();

    return query.map(
      (snapshot) => snapshot.docs.map((doc) => Chat.fromDoc(doc)).toList(),
    );
  }

  Future<String> getChatId(String receiverId) async {
    final user = _auth.getCurrentUser();
    if (user == null) return '';

    final querySnapshot =
        await _firestore
            .collection('Chats')
            .where('user1Id', whereIn: [user.uid, receiverId])
            .where('user2Id', whereIn: [user.uid, receiverId])
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return '';
    }
  }

  Future<void> sendMessage({
    required String receiverId,
    required String messageText,
  }) async {
    final chatsCollection = FirebaseFirestore.instance.collection('Chats');

    //Procurar chat existente entre os dois usuários (ordem pode variar)
    final querySnapshot =
        await chatsCollection
            .where(
              'user1Id',
              whereIn: [_auth.getCurrentUser()?.uid, receiverId],
            )
            .where(
              'user2Id',
              whereIn: [_auth.getCurrentUser()?.uid, receiverId],
            )
            .get();

    DocumentReference? chatDocRef;

    //Verificar se o usuário que vai receber a mensagem existe

    if (querySnapshot.docs.isNotEmpty) {
      chatDocRef = querySnapshot.docs.first.reference;
    } else {
      //Criar novo chat (chat ainda não existe)
      chatDocRef = await chatsCollection.add({
        'user1Id': _auth.getCurrentUser()?.uid,
        'user2Id': receiverId,
        'lastMessage': null,
      });
    }

    //Criar a mensagem dentro da subcoleção 'messages' do chat
    Message message = Message(
      id: '',
      senderId: _auth.getCurrentUser()?.uid ?? '',
      text: messageText,
      timestamp: DateTime.now(),
    );

    final messagesCollection = chatDocRef.collection('messages');
    /*final newMessageDoc = */
    await messagesCollection.add(message.toMap());

    //Atualizar o campo lastMessage no documento do chat
    await chatDocRef.update({
      'lastMessage': {
        'senderId': _auth.getCurrentUser()?.uid,
        'text': messageText,
        'timestamp': DateTime.now(),
      },
    });
  }

  Stream<List<Message>> getMessagesFromChat(String chatId) {
    if (chatId.isEmpty) {
      return const Stream.empty(); // retorna uma stream vazia
    }

    return _firestore
        .collection('Chats')
        .doc(chatId)
        .collection('messages')
        .orderBy(
          'timestamp',
        ) // Ordena por timestamp (do mais antigo para o mais novo)
        .orderBy(
          'senderId',
        ) // Em caso de empate no timestamp, ordena pelo ID do remetente
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs
              .map((doc) => Message.fromMap(doc.data()))
              .toList();
        });
  }
}
