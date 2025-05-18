class AppUser {
  final String id;
  final String email;
  final String? name;
  final String? profileImageUrl;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
  });
}
