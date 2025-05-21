import 'package:chatpp/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import '../../model/app_user.dart';
import '../../controller/user_controller.dart';
import './../../model/message.dart';

class ContactCard extends StatelessWidget {
  final String userId;
  final Message? lastMessage;

  ContactCard({super.key, required this.userId, required this.lastMessage});

  final UserController _userController = UserController();
  final AuthController _authController = AuthController();

  String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return "${timestamp.day}/${timestamp.month}/${timestamp.year}";
    } else {
      return "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageText = lastMessage?.text ?? 'Sem mensagens';
    final displayMessage =
        (lastMessage != null &&
                lastMessage!.senderId == _authController.getCurrentUser()?.uid)
            ? "Você: $messageText"
            : messageText;

    return StreamBuilder<AppUser>(
      stream: _userController.getUserById(
        userId,
      ), // adapte conforme seu controller
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ListTile(title: Text("Carregando..."));
        }

        final user = snapshot.data!;

        return Card(
          color: const Color(0xFF1A1A2E),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              backgroundImage:
                  user.profileImageUrl != null
                      ? NetworkImage(user.profileImageUrl!)
                      : null,
              child:
                  user.profileImageUrl == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
            ),
            title: Text(
              user.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              displayMessage,
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Text(
              lastMessage?.timestamp != null
                  ? formatTimestamp(lastMessage!.timestamp)
                  : '',
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}
