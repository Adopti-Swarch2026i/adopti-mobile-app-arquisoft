class User {
  final String id;
  final String email;
  final String displayName;
  final String? photoURL;
  final String? phone;

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.phone,
  });
}
