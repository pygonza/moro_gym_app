import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/supabase_service.dart';
import '../../models/routine.dart';
import '../../models/exercise.dart';

class ActiveWorkoutPage extends StatefulWidget {
  final int sessionId;
  const ActiveWorkoutPage({super.key, required this.sessionId});

  @override
  State<ActiveWorkoutPage> createState() => _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState extends State<ActiveWorkoutPage> {
  List<RoutineExercise> _exercises = [];
  bool _loading = true;
  int _currentExerciseIndex = 0;
  // formulario para añadir serie
  final _weightCtrl = TextEditingController();
  final _repsCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    // Obtener la sesión para ver el routine_id
    final sessions = await SupabaseService.getSessions(limit: 1);
    final current = sessions.firstWhere((s) => s['id'] == widget.sessionId);
    final routineId = current['routine_id'] as int?;
    if (routineId != null) {
      final data = await SupabaseService.getRoutineExercises(routineId);
      setState(() {
        _exercises = data.map((e) => RoutineExercise.fromMap(e, exercise: Exercise.fromMap(e['exercises']))).toList();
        _loading = false;
      });
    } else {
      // Entrenamiento libre: podrías dejar que elija ejercicios del catálogo, simplifico
      setState(() => _loading = false);
    }
  }

  Future<void> _addSet() async {
    final weight = double.tryParse(_weightCtrl.text);
    final reps = int.tryParse(_repsCtrl.text);
    if (weight == null || reps == null || _exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completa peso y reps')));
      return;
    }
    final exercise = _exercises[_currentExerciseIndex];
    final nextSetNumber = await _getNextSetNumber(exercise.id);
    await SupabaseService.logSet(
      widget.sessionId,
      exercise.exerciseId,
      nextSetNumber,
      reps,
      weight,
    );
    _weightCtrl.clear();
    _repsCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Serie añadida')));
  }

  Future<int> _getNextSetNumber(int exerciseId) async {
    final logs = await SupabaseService.getSetLogs(widget.sessionId);
    return logs.where((l) => l['exercise_id'] == exerciseId).length + 1;
  }

  Future<void> _finishWorkout() async {
    await SupabaseService.finishWorkout(widget.sessionId, notes: _notesCtrl.text.trim());
    // Actualizar racha
    final profile = await SupabaseService.getProfile();
    if (profile != null) {
      final today = DateTime.now();
      final last = profile['last_workout_date'] != null ? DateTime.parse(profile['last_workout_date'] as String) : null;
      int newStreak = 1;
      if (last != null) {
        final diff = today.difference(last).inDays;
        if (diff == 1) {
          newStreak = (profile['current_streak'] as int) + 1;
        } else if (diff == 0) {
          newStreak = profile['current_streak'] as int;
        }
      }
      await SupabaseService.updateStreak(newStreak, today);
      // Otorgar insignias según logros
      if (newStreak == 5) {
        await SupabaseService.awardBadge('Racha de 5 días', 'Has entrenado 5 días seguidos');
      } else if (newStreak == 10) {
        await SupabaseService.awardBadge('Racha de 10 días', '¡Disciplina constante!');
      }
    }
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Entrenamiento libre')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No hay ejercicios predefinidos.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _finishWorkout,
                child: const Text('Finalizar entrenamiento'),
              ),
            ],
          ),
        ),
      );
    }

    final currentExercise = _exercises[_currentExerciseIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(currentExercise.exercise?.name ?? 'Ejercicio'),
        actions: [
          TextButton(
            onPressed: _finishWorkout,
            child: const Text('Finalizar'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${currentExercise.sets} series x ${currentExercise.reps} reps, Descanso: ${currentExercise.restSeconds}s',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (currentExercise.exercise?.instructions != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(currentExercise.exercise!.instructions!, style: TextStyle(color: Colors.grey[300])),
                ),
              ),
            const SizedBox(height: 20),
            Text('Añadir serie:', style: Theme.of(context).textTheme.titleSmall),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightCtrl,
                    decoration: const InputDecoration(labelText: 'Peso (kg)'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _repsCtrl,
                    decoration: const InputDecoration(labelText: 'Reps'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 40),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: _addSet,
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Notas de la sesión',
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _SetHistory(sessionId: widget.sessionId, exerciseId: currentExercise.exerciseId),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentExerciseIndex > 0)
                  OutlinedButton(
                    onPressed: () => setState(() => _currentExerciseIndex--),
                    child: const Text('Anterior'),
                  ),
                if (_currentExerciseIndex < _exercises.length - 1)
                  ElevatedButton(
                    onPressed: () => setState(() => _currentExerciseIndex++),
                    child: const Text('Siguiente ejercicio'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SetHistory extends StatelessWidget {
  final int sessionId;
  final int exerciseId;
  const _SetHistory({required this.sessionId, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: SupabaseService.getSetLogs(sessionId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: Text('Cargando historial...'));
        final logs = snapshot.data!.where((l) => l['exercise_id'] == exerciseId).toList();
        if (logs.isEmpty) return const Text('No hay series registradas aún.');
        return ListView.builder(
          shrinkWrap: true,
          itemCount: logs.length,
          itemBuilder: (_, i) => ListTile(
            leading: CircleAvatar(child: Text('${logs[i]['set_number']}')),
            title: Text('${logs[i]['reps_done']} reps'),
            subtitle: Text('${logs[i]['weight_kg']} kg'),
          ),
        );
      },
    );
  }
}