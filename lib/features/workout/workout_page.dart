import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/supabase_service.dart';
import '../../models/routine.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  List<Routine> _routines = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await SupabaseService.getRoutines();
    setState(() {
      _routines = data.map((m) => Routine.fromMap(m)).toList();
      _loading = false;
    });
  }

  Future<void> _startWorkout(int? routineId) async {
    final sessionId = await SupabaseService.startWorkout(routineId);
    if (mounted) context.go('/active-workout/$sessionId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar entrenamiento')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Elige una rutina o empieza libre'),
          const SizedBox(height: 12),
          ..._routines.map((r) => Card(
            child: ListTile(
              title: Text(r.name),
              subtitle: Text(r.description ?? ''),
              trailing: const Icon(Icons.play_arrow),
              onTap: () => _startWorkout(r.id),
            ),
          )),
          const Divider(height: 30),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.fitness_center),
              label: const Text('Entrenamiento libre (sin rutina)'),
              onPressed: () => _startWorkout(null),
            ),
          ),
        ],
      ),
    );
  }
}