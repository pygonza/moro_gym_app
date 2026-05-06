class SetLog {
  final int id;
  final int sessionId;
  final int exerciseId;
  final int setNumber;
  final int repsDone;
  final double weightKg;
  final DateTime createdAt;

  SetLog({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.setNumber,
    required this.repsDone,
    required this.weightKg,
    required this.createdAt,
  });

  factory SetLog.fromMap(Map<String, dynamic> map) {
    return SetLog(
      id: map['id'] as int,
      sessionId: map['session_id'] as int,
      exerciseId: map['exercise_id'] as int,
      setNumber: map['set_number'] as int,
      repsDone: map['reps_done'] as int,
      weightKg: (map['weight_kg'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}