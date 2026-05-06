import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/supabase_service.dart';
import '../../models/routine.dart';
import '../../models/exercise.dart';
import '../../widgets/workout_set_row.dart';
import '../../core/theme.dart';

class ActiveWorkoutPage extends StatefulWidget {
  final int sessionId;
  const ActiveWorkoutPage({super.key, required this.sessionId});

  @override
  State<ActiveWorkoutPage> createState() => _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState extends State<ActiveWorkoutPage> {
  final List<RoutineExercise> _exercises = [];
  final Map<int, List<SetData>> _exerciseSets = {};
  bool _loading = true;
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final sessions = await SupabaseService.getSessions(limit: 20);
      final current = sessions.firstWhere((s) => s['id'] == widget.sessionId);
      final routineId = current['routine_id'] as int?;

      if (routineId != null) {
        final data = await SupabaseService.getRoutineExercises(routineId);
        setState(() {
          for (var e in data) {
            final re = RoutineExercise.fromMap(e, exercise: Exercise.fromMap(e['exercises']));
            _exercises.add(re);
            _exerciseSets[re.exerciseId] = List.generate(re.sets, (_) => SetData(weightCtrl: TextEditingController(), repsCtrl: TextEditingController()));
          }
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al iniciar: $e')));
        context.go('/');
      }
    }
  }

  Future<void> _addExercise() async {
    final all = await SupabaseService.getAllExercises();
    if (!mounted) return;
    final selected = await showDialog<Exercise>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Añadir Ejercicio'),
        children: all.map((e) => SimpleDialogOption(
          onPressed: () => Navigator.pop(ctx, Exercise.fromMap(e)),
          child: Text(e['name']),
        )).toList(),
      ),
    );

    if (selected != null) {
      setState(() {
        final re = RoutineExercise(id: -1, exerciseId: selected.id, sets: 3, reps: 10, restSeconds: 60, orderIndex: _exercises.length, exercise: selected);
        _exercises.add(re);
        _exerciseSets[selected.id] = List.generate(3, (_) => SetData(weightCtrl: TextEditingController(), repsCtrl: TextEditingController()));
      });
    }
  }

  Future<void> _finish() async {
    setState(() => _loading = true);
    try {
      for (var entry in _exerciseSets.entries) {
        for (int i = 0; i < entry.value.length; i++) {
          final s = entry.value[i];
          final w = double.tryParse(s.weightCtrl.text);
          final r = int.tryParse(s.repsCtrl.text);
          if (w != null && r != null) await SupabaseService.logSet(widget.sessionId, entry.key, i + 1, r, w);
        }
      }
      await SupabaseService.finishWorkout(widget.sessionId, notes: _notesCtrl.text.trim());
      if (mounted) context.go('/');
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entreno Activo'),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.go('/')),
        actions: [TextButton(onPressed: _finish, child: const Text('FINALIZAR', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)))],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: _addExercise, label: const Text('EJERCICIO'), icon: const Icon(Icons.add)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_exercises.isEmpty) const Center(child: Padding(padding: EdgeInsets.only(top: 100), child: Text('Lista vacía. Toca "+" para añadir.', style: TextStyle(color: Colors.grey)))),
          ..._exercises.map((ex) => Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ex.exercise?.name ?? 'Ejercicio', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.green)),
                  ...List.generate(_exerciseSets[ex.exerciseId]?.length ?? 0, (i) => WorkoutSetRow(setNumber: i+1, weightCtrl: _exerciseSets[ex.exerciseId]![i].weightCtrl, repsCtrl: _exerciseSets[ex.exerciseId]![i].repsCtrl, onDelete: () => setState(() => _exerciseSets[ex.exerciseId]!.removeAt(i)))),
                  TextButton.icon(onPressed: () => setState(() => _exerciseSets[ex.exerciseId]!.add(SetData(weightCtrl: TextEditingController(), repsCtrl: TextEditingController()))), icon: const Icon(Icons.add, size: 18), label: const Text('AÑADIR SERIE'), style: TextButton.styleFrom(foregroundColor: Colors.grey)),
                ],
              ),
            ),
          )),
          TextField(controller: _notesCtrl, decoration: const InputDecoration(labelText: 'Notas', prefixIcon: Icon(Icons.note))),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class SetData {
  final TextEditingController weightCtrl;
  final TextEditingController repsCtrl;
  SetData({required this.weightCtrl, required this.repsCtrl});
}
