import 'package:chatpp/controller/auth_controller.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void logout() {
    final auth = AuthController();

    try {
      auth.signOut();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profile Screen"),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
    );
  }
}
