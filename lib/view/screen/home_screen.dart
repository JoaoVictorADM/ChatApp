import 'package:chatpp/controller/auth_controller.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home1"),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
    );
  }

  void logout() {
    final auth = AuthController();

    try {
      auth.signOut();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }
}
