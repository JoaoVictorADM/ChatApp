class User {
  final String id;
  String email;
  String name;
  String? profileImageUrl;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
  });
}
