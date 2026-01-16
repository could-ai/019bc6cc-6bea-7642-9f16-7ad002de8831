class User {
  final String id;
  final String name;
  final String email;
  final String? profilePicture;
  final String preferredCurrency;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    this.preferredCurrency = 'USD',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'preferredCurrency': preferredCurrency,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      profilePicture: map['profilePicture'],
      preferredCurrency: map['preferredCurrency'] ?? 'USD',
    );
  }
}