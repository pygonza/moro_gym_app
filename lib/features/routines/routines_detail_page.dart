import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../models/exercise.dart';
import '../../models/routine.dart';

class RoutineDetailPage extends StatefulWidget {
  final int routineId;
  const RoutineDetailPage({super.key, required this.routineId});

  @override
  State<RoutineDetailPage> createState() => _RoutineDetailPageState();
}

class _RoutineDetailPageState extends State<RoutineDetailPage> {
  List<RoutineExercise> _exercises = [];
  late Future<List<Map<String, dynamic>>> _exercisesFuture;

  @override
  void initState() {
    super.initState();
    _exercisesFuture = SupabaseService.getRoutineExercises(widget.routineId);
  }

  Future<void> _addExercise() async {
    final allExercises = await SupabaseService.getAllExercises();
    if (!mounted) return;
    final selected = await showDialog<Exercise>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Selecciona ejercicio'),
        children: allExercises.map((e) {
          final ex = Exercise.fromMap(e);
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, ex),
            child: Text('${ex.name} (${ex.muscleGroup})'),
          );
        }).toList(),
      ),
    );
    if (selected != null) {
      await SupabaseService.addExerciseToRoutine(
        widget.routineId,
        selected.id,
        3, // sets por defecto
        10, // reps
        60, // descanso
        _exercises.length,
      );
      setState(() {
        _exercisesFuture = SupabaseService.getRoutineExercises(widget.routineId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de rutina')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _exercisesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final list = snapshot.data!;
          return ReorderableListView.builder(
            itemCount: list.length,
            onReorder: (oldIndex, newIndex) {
              // Aquí podrías actualizar el order_index en Supabase si quieres persistir el orden
            },
            itemBuilder: (_, i) {
              final re = RoutineExercise.fromMap(list[i], exercise: Exercise.fromMap(list[i]['exercises']));
              return ListTile(
                key: ValueKey(re.id),
                leading: const Icon(Icons.drag_handle),
                title: Text(re.exercise?.name ?? 'Ejercicio ${re.exerciseId}'),
                subtitle: Text('${re.sets} x ${re.reps}, descanso ${re.restSeconds}s'),
              );
            },
          );
        },
      ),
    );
  }
}