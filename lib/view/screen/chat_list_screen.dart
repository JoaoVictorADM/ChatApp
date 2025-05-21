import 'package:flutter/material.dart';
import '../../model/chat.dart';
import '../../controller/chat_controller.dart';
import '../../controller/auth_controller.dart';
import '../widget/contact_card.dart';
import '../widget/my_drawer.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatController _chatController = ChatController();
  final AuthController _auth = AuthController();

  void _send() {
    ChatController chatController = ChatController();
    chatController.sendMessage(
      receiverId: "DYtRTqKELINofjYNLiq8ivVBsP12",
      messageText: "Tralalero",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1B),
      drawer: MyDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF0D0D1B),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Lista de Conversas",
          style: TextStyle(
            fontSize: 24,
            color: Color.fromRGBO(255, 255, 255, 1),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          TextButton(onPressed: _send, child: Text("Enviar mensagem")),
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person_add, color: Colors.blue),
            ),
            onPressed: () => {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Pesquisar contato',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<Chat>>(
        stream: _chatController.getUserChatsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum chat encontrado."));
          }

          final chats = snapshot.data!;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final currentUserId = _auth.getCurrentUser()?.uid;
              final otherUserId =
                  chat.user1Id == currentUserId ? chat.user2Id : chat.user1Id;

              return ContactCard(
                userId: otherUserId,
                lastMessage: chat.lastMessage,
              );
            },
          );
        },
      ),
    );
  }
}
