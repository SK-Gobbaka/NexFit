class Clothing {
  final String id;
  final String imageUrl;
  final String category;
  final String color;
  final String? style;
  final String? userId;
  final DateTime createdAt;

  Clothing({
    required this.id,
    required this.imageUrl,
    required this.category,
    required this.color,
    this.style,
    this.userId,
    required this.createdAt,
  });

  factory Clothing.fromJson(Map<String, dynamic> json) {
    return Clothing(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      color: json['color'] as String,
      style: json['style'] as String?,
      userId: json['userId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'category': category,
      'color': color,
      'style': style,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
