class UserProfile {
  final String id;
  final String? fullName;
  final int currentStreak;
  final DateTime? lastWorkoutDate;

  UserProfile({required this.id, this.fullName, this.currentStreak = 0, this.lastWorkoutDate});

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      fullName: map['full_name'] as String?,
      currentStreak: map['current_streak'] as int? ?? 0,
      lastWorkoutDate: map['last_workout_date'] != null ? DateTime.tryParse(map['last_workout_date'] as String) : null,
    );
  }
}