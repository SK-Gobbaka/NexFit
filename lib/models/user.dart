class User {
  final String id;
  final String username;
  final String? profileImage;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    this.profileImage,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      profileImage: json['profileImage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
