class Post {
  final String id;
  final String imageUrl;
  final String occasion;
  final String? userId;
  final DateTime createdAt;
  final int? likes;

  Post({
    required this.id,
    required this.imageUrl,
    required this.occasion,
    this.userId,
    required this.createdAt,
    this.likes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      occasion: json['occasion'] as String,
      userId: json['userId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likes: json['likes'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'occasion': occasion,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
    };
  }
}
