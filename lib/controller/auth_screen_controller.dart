import 'package:chatpp/view/screen/login_screen.dart';
import 'package:chatpp/view/screen/register_screen.dart';
import 'package:flutter/material.dart';

class AuthScreenController extends StatefulWidget {
  const AuthScreenController({super.key});

  @override
  State<AuthScreenController> createState() => _AuthScreenControllerState();
}

class _AuthScreenControllerState extends State<AuthScreenController> {
  bool showLoginPage = true;

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen(toggleScreen: toggleScreen);
    } else {
      return RegisterScreen(toggleScreen: toggleScreen);
    }
  }

  void toggleScreen() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
}
