import 'package:chatpp/controller/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/app_user.dart';
import 'package:flutter/material.dart';

class UserController {
  final _firestore = FirebaseFirestore.instance;
  final _authController = AuthController();

  Stream<AppUser> getUserById(String userId) {
    return _firestore.collection('Users').doc(userId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        debugPrint("Usuário não encontrado");
        throw Exception("Usuário não encontrado");
      }

      final data = doc.data()!;
      return AppUser(
        id: doc.id,
        email: data['email'] ?? '',
        name: data['name'] ?? 'Sem nome',
        profileImageUrl: data['profileImageUrl'],
      );
    });
  }

  Future<void> updateUserName(String newName) async {
    try {
      await _firestore
          .collection('Users')
          .doc(_authController.getCurrentUser()!.uid)
          .update({'name': newName});
    } catch (e) {
      throw Exception('Erro ao atualizar nome: $e');
    }
  }

  Future<void> updateUserProfileImage(String imageUrl) async {
    try {
      await _firestore
          .collection('Users')
          .doc(_authController.getCurrentUser()!.uid)
          .update({'profileImageUrl': imageUrl});
    } catch (e) {
      throw Exception('Erro ao atualizar imagem: $e');
    }
  }
}
