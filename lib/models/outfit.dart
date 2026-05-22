class Outfit {
  final String id;
  final List<String> clothingIds;
  final int matchPercentage;
  final String? userId;
  final DateTime createdAt;
  final bool isSaved;

  Outfit({
    required this.id,
    required this.clothingIds,
    required this.matchPercentage,
    this.userId,
    required this.createdAt,
    this.isSaved = false,
  });

  factory Outfit.fromJson(Map<String, dynamic> json) {
    return Outfit(
      id: json['id'] as String,
      clothingIds: List<String>.from(json['clothingIds'] as List),
      matchPercentage: json['matchPercentage'] as int,
      userId: json['userId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clothingIds': clothingIds,
      'matchPercentage': matchPercentage,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'isSaved': isSaved,
    };
  }

  Outfit copyWith({
    String? id,
    List<String>? clothingIds,
    int? matchPercentage,
    String? userId,
    DateTime? createdAt,
    bool? isSaved,
  }) {
    return Outfit(
      id: id ?? this.id,
      clothingIds: clothingIds ?? this.clothingIds,
      matchPercentage: matchPercentage ?? this.matchPercentage,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
