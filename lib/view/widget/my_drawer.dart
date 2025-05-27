import 'package:chatpp/controller/auth_controller.dart';
import 'package:chatpp/controller/user_controller.dart';
import 'package:chatpp/view/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../model/app_user.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final _auth = AuthController();
  final _userController = UserController();

  void _logout() {
    try {
      _auth.signOut();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = _auth.getCurrentUser()?.uid;

    if (userId == null) {
      return const Drawer(
        child: Center(child: Text("Usuário não autenticado")),
      );
    }

    return StreamBuilder<AppUser>(
      stream: _userController.getUserById(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Drawer(
            backgroundColor: Color(0xFF0D0D1B),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.white70,
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Drawer(
            child: Center(child: Text("Erro ao carregar usuário")),
          );
        }

        final user = snapshot.data!;

        return Drawer(
          backgroundColor: const Color(0xFF0D0D1B),
          child: Column(
            children: [
              Column(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: Color(0xFF1A1A2E)),
                    accountName: Text(
                      user.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    accountEmail: Text(
                      user.email,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage:
                          user.profileImageUrl != null
                              ? NetworkImage(user.profileImageUrl!)
                              : null,
                      backgroundColor: Colors.white,
                      child:
                          user.profileImageUrl == null
                              ? const Icon(Icons.person, color: Colors.blue)
                              : null,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.white),
                    title: const Text(
                      'E D I T A R     P E R F I L',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      _logout();
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(width: 8),
                        Text('S A I R', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
