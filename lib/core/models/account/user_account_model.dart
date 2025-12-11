class UserAccount {
  final String id;
  String name;
  String email;
  String password;
  String? avatarUrl;

  UserAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.avatarUrl,
  });
}

