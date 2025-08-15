class UserProfile {
  // final String id;
  final String name;
  final String email;
  final String? avatarUrl; // <-- Added this

  UserProfile({
    // required this.id,
    required this.name,
    required this.email,
    this.avatarUrl, // <-- Added this
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      // id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'], // <-- Added this
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl, // <-- Added this
    };
  }
}
