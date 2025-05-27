import 'package:flutter/material.dart';
import '../../model/app_user.dart';
import '../../controller/user_controller.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userId;
  final UserController _userController = UserController();

  ChatAppBar({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser>(
      stream: _userController.getUserById(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              "Carregando...",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF1A1A2E), // Cor de fundo do AppBar
            iconTheme: const IconThemeData(
              color: Colors.white,
            ), // Cor dos ícones
          );
        }

        final user = snapshot.data!;

        return AppBar(
          elevation: 1, // Pequena sombra para destacar
          backgroundColor: const Color(0xFF1A1A2E), // Cor de fundo do AppBar
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          titleSpacing: 0,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blueAccent,
                backgroundImage:
                    user.profileImageUrl != null &&
                            user.profileImageUrl!.isNotEmpty
                        ? NetworkImage(user.profileImageUrl!)
                        : null,
                child:
                    user.profileImageUrl == null ||
                            user.profileImageUrl!.isEmpty
                        ? const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        )
                        : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
