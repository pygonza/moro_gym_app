import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/supabase_service.dart';
import '../../models/routine.dart';
import '../../models/exercise.dart';
import '../../widgets/workout_set_row.dart';

class ActiveWorkoutPage extends StatefulWidget {
  final int sessionId;
  const ActiveWorkoutPage({super.key, required this.sessionId});

  @override
  State<ActiveWorkoutPage> createState() => _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState extends State<ActiveWorkoutPage> {
  List<RoutineExercise> _exercises = [];
  Map<int, List<SetData>> _exerciseSets = {};
  bool _loading = true;
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final sessions = await SupabaseService.getSessions(limit: 5);
    final current = sessions.firstWhere((s) => s['id'] == widget.sessionId);
    final routineId = current['routine_id'] as int?;
    
    if (routineId != null) {
      final data = await SupabaseService.getRoutineExercises(routineId);
      setState(() {
        _exercises = data.map((e) => RoutineExercise.fromMap(e, exercise: Exercise.fromMap(e['exercises']))).toList();
        for (var ex in _exercises) {
          _exerciseSets[ex.exerciseId] = List.generate(ex.sets, (index) => SetData(
            weightCtrl: TextEditingController(),
            repsCtrl: TextEditingController(),
          ));
        }
        _loading = false;
      });
    } else {
      // Caso Entrenamiento Libre
      setState(() {
        _exercises = [];
        _loading = false;
      });
    }
  }

  Future<void> _addExerciseToFreeWorkout() async {
    final allExercises = await SupabaseService.getAllExercises();
    if (!mounted) return;
    final selected = await showDialog<Exercise>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Añadir Ejercicio'),
        children: allExercises.map((e) {
          final ex = Exercise.fromMap(e);
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, ex),
            child: Text(ex.name),
          );
        }).toList(),
      ),
    );
    if (selected != null) {
      setState(() {
        _exercises.add(RoutineExercise(
          id: -1, // Temporal
          exerciseId: selected.id,
          sets: 3,
          reps: 10,
          restSeconds: 60,
          orderIndex: _exercises.length,
          exercise: selected,
        ));
        _exerciseSets[selected.id] = List.generate(3, (index) => SetData(
          weightCtrl: TextEditingController(),
          repsCtrl: TextEditingController(),
        ));
      });
    }
  }

  void _addSet(int exerciseId) {
    setState(() {
      _exerciseSets[exerciseId]!.add(SetData(
        weightCtrl: TextEditingController(),
        repsCtrl: TextEditingController(),
      ));
    });
  }

  Future<void> _finishWorkout() async {
    // 1. Guardar todos los logs de las series
    for (var entry in _exerciseSets.entries) {
      final exId = entry.key;
      final sets = entry.value;
      for (int i = 0; i < sets.length; i++) {
        final weight = double.tryParse(sets[i].weightCtrl.text);
        final reps = int.tryParse(sets[i].repsCtrl.text);
        if (weight != null && reps != null) {
          await SupabaseService.logSet(widget.sessionId, exId, i + 1, reps, weight);
        }
      }
    }

    // 2. Finalizar sesión
    await SupabaseService.finishWorkout(widget.sessionId, notes: _notesCtrl.text.trim());
    
    // 3. Lógica de Logros y Rachas (Simulada por ahora)
    await _checkAchievements();

    if (mounted) context.go('/');
  }

  Future<void> _checkAchievements() async {
    // 1. Obtener datos para evaluación
    final profileData = await SupabaseService.getProfile();
    final sessions = await SupabaseService.getSessions(limit: 50);
    final logs = await SupabaseService.getSetLogs(widget.sessionId);
    
    final int streak = profileData?['current_streak'] ?? 0;
    final int totalSessions = sessions.length;
    final double maxWeight = logs.isNotEmpty 
        ? logs.map((l) => (l['weight_kg'] as num).toDouble()).reduce((a, b) => a > b ? a : b)
        : 0;

    // 2. Evaluar hitos
    if (totalSessions >= 1) {
      await SupabaseService.awardBadge('Primer Paso', 'Has completado tu primer entrenamiento.');
    }
    if (streak >= 7) {
      await SupabaseService.awardBadge('Constancia de Hierro', 'Racha de 7 días completada.');
    }
    if (maxWeight >= 100) {
      await SupabaseService.awardBadge('Club de los 100', 'Levantaste 100kg o más en un ejercicio.');
    }
    if (totalSessions >= 10) {
      await SupabaseService.awardBadge('Veterano', 'Has completado 10 sesiones de entrenamiento.');
    }
    if (totalSessions >= 50) {
      await SupabaseService.awardBadge('Bestia del Moro', '¡50 entrenamientos completados!');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Entrenamiento Activo'),
        actions: [
          TextButton(
            onPressed: _finishWorkout,
            child: const Text('FINALIZAR', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      floatingActionButton: _exercises.isEmpty || _exerciseSets.keys.length < _exercises.length 
        ? FloatingActionButton.extended(
            onPressed: _addExerciseToFreeWorkout,
            label: const Text('AÑADIR EJERCICIO'),
            icon: const Icon(Icons.add),
          )
        : FloatingActionButton(
            onPressed: _addExerciseToFreeWorkout,
            child: const Icon(Icons.add),
          ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._exercises.map((ex) => _buildExerciseCard(ex)),
          const SizedBox(height: 24),
          TextField(
            controller: _notesCtrl,
            decoration: const InputDecoration(
              labelText: 'Notas del entrenamiento',
              hintText: '¿Cómo te sentiste hoy?',
              prefixIcon: Icon(Icons.edit_note),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(RoutineExercise re) {
    final sets = _exerciseSets[re.exerciseId] ?? [];
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    re.exercise?.name ?? 'Ejercicio',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, size: 20, color: Colors.grey),
                  onPressed: () {}, // Mostrar instrucciones
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(sets.length, (index) => WorkoutSetRow(
              setNumber: index + 1,
              weightCtrl: sets[index].weightCtrl,
              repsCtrl: sets[index].repsCtrl,
              onDelete: () => setState(() => sets.removeAt(index)),
            )),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _addSet(re.exerciseId),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('AÑADIR SERIE'),
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class SetData {
  final TextEditingController weightCtrl;
  final TextEditingController repsCtrl;
  SetData({required this.weightCtrl, required this.repsCtrl});
}
