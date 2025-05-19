import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/app_user.dart';
import 'package:flutter/material.dart';

class UserController {
  final _firestore = FirebaseFirestore.instance;

  Future<AppUser> getUserById(String userId) async {
    final doc = await _firestore.collection('Users').doc(userId).get();

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
  }
}
