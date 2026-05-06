class Achievement {
  final int id;
  final String badgeName;
  final String? description;
  final DateTime awardedAt;

  Achievement({required this.id, required this.badgeName, this.description, required this.awardedAt});

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] as int,
      badgeName: map['badge_name'] as String,
      description: map['description'] as String?,
      awardedAt: DateTime.parse(map['awarded_at'] as String),
    );
  }
}