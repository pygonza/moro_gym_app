class WorkoutSession {
  final int id;
  final int? routineId;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final String? notes;

  WorkoutSession({
    required this.id,
    this.routineId,
    required this.startedAt,
    this.finishedAt,
    this.notes,
  });

  factory WorkoutSession.fromMap(Map<String, dynamic> map) {
    return WorkoutSession(
      id: map['id'] as int,
      routineId: map['routine_id'] as int?,
      startedAt: DateTime.parse(map['started_at'] as String),
      finishedAt: map['finished_at'] != null ? DateTime.parse(map['finished_at'] as String) : null,
      notes: map['notes'] as String?,
    );
  }
}