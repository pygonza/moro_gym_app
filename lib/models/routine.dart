import 'exercise.dart';

class Routine {
  final int id;
  final String name;
  final String? description;
  final List<RoutineExercise> exercises;

  Routine({required this.id, required this.name, this.description, this.exercises = const []});

  factory Routine.fromMap(Map<String, dynamic> map, {List<RoutineExercise>? exercises}) {
    return Routine(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String?,
      exercises: exercises ?? [],
    );
  }
}

class RoutineExercise {
  final int id;
  final int exerciseId;
  final int sets;
  final int reps;
  final int restSeconds;
  final int orderIndex;
  final Exercise? exercise; // cargado join

  RoutineExercise({
    required this.id,
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    required this.orderIndex,
    this.exercise,
  });

  factory RoutineExercise.fromMap(Map<String, dynamic> map, {Exercise? exercise}) {
    return RoutineExercise(
      id: map['id'] as int,
      exerciseId: map['exercise_id'] as int,
      sets: map['sets'] as int,
      reps: map['reps'] as int,
      restSeconds: map['rest_seconds'] as int,
      orderIndex: map['order_index'] as int,
      exercise: exercise,
    );
  }
}