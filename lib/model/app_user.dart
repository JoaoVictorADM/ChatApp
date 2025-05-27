import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
  });

  factory AppUser.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? 'Sem nome',
      profileImageUrl: data['profileImageUrl'],
    );
  }
}
