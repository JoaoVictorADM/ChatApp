import 'package:flutter/material.dart';
import 'profile_screen.dart';
import '../../model/chat.dart';
import '../../controller/chat_controller.dart';
import '../../controller/auth_controller.dart';
import '../widget/contact_card.dart';
import '../../model/message.dart';

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
      messageText: "Oi maria, tudo sim",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D1B),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Colors.blue, // ícone azul
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
        ),
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
              child: Icon(
                Icons.person_add,
                color: Colors.blue, // ícone azul
              ),
            ), // Ícone de adicionar pessoa
            onPressed: () => {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
            60,
          ), // Define a altura da barra inferior
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(
                  0xFF1A1A2E,
                ), // Cor de fundo do campo de pesquisa
                borderRadius: BorderRadius.circular(
                  12,
                ), // Arredonda os cantos do campo
              ),
              child: const TextField(
                style: TextStyle(
                  color: Colors.white,
                ), // Estilo do texto digitado
                cursorColor: Colors.white, // Cor do cursor
                decoration: InputDecoration(
                  hintText: 'Pesquisar contato', // Texto de sugestão
                  hintStyle: TextStyle(
                    color: Colors.white70,
                  ), // Estilo do texto de sugestão
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white70,
                  ), // Ícone de pesquisa
                  border: InputBorder.none, // Remove a borda
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14,
                  ), // Padding dentro do campo
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
