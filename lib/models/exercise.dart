class Exercise {
  final int id;
  final String name;
  final String? muscleGroup;
  final String? equipment;
  final String? difficulty;
  final String? instructions;

  Exercise({
    required this.id,
    required this.name,
    this.muscleGroup,
    this.equipment,
    this.difficulty,
    this.instructions,
  });

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as int,
      name: map['name'] as String,
      muscleGroup: map['muscle_group'] as String?,
      equipment: map['equipment'] as String?,
      difficulty: map['difficulty'] as String?,
      instructions: map['instructions'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'muscle_group': muscleGroup,
      'equipment': equipment,
      'difficulty': difficulty,
      'instructions': instructions,
    };
  }
}