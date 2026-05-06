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
      appBar: AppBar(
        title: const Text('Iniciar Entrenamiento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Elige una rutina', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._routines.map((r) => Card(
            child: ListTile(
              title: Text(r.name),
              subtitle: Text(r.description ?? 'Sin descripción'),
              trailing: const Icon(Icons.play_arrow, color: Colors.green),
              onTap: () => _startWorkout(r.id),
            ),
          )),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.fitness_center),
            label: const Text('ENTRENAMIENTO LIBRE'),
            onPressed: () => _startWorkout(null),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.05),
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
