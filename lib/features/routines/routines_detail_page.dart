import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  late Future<List<Map<String, dynamic>>> _exercisesFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _exercisesFuture = SupabaseService.getRoutineExercises(widget.routineId);
    });
  }

  Future<void> _addExistingExercise() async {
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
      await SupabaseService.addExerciseToRoutine(widget.routineId, selected.id, 3, 10, 60, 0);
      _refresh();
    }
  }

  Future<void> _createNewExercise() async {
    final nameCtrl = TextEditingController();
    final muscleCtrl = TextEditingController();
    
    final created = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo Ejercicio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: muscleCtrl, decoration: const InputDecoration(labelText: 'Grupo Muscular')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty) {
                final id = await SupabaseService.createExercise(
                  name: nameCtrl.text.trim(),
                  muscleGroup: muscleCtrl.text.trim(),
                );
                await SupabaseService.addExerciseToRoutine(widget.routineId, id, 3, 10, 60, 0);
                if (ctx.mounted) Navigator.pop(ctx, true);
              }
            },
            child: const Text('Crear y Añadir'),
          ),
        ],
      ),
    );
    if (created == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Rutina'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/routines'),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _exercisesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final list = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final re = RoutineExercise.fromMap(list[i], exercise: Exercise.fromMap(list[i]['exercises']));
              return Card(
                child: ListTile(
                  title: Text(re.exercise?.name ?? 'Ejercicio'),
                  subtitle: Text('${re.sets} x ${re.reps}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'create',
            onPressed: _createNewExercise,
            child: const Icon(Icons.add_circle_outline),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'select',
            onPressed: _addExistingExercise,
            child: const Icon(Icons.list),
          ),
        ],
      ),
    );
  }
}
