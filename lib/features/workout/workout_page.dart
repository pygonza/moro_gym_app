import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/supabase_service.dart';
import '../../models/routine.dart';
import '../../core/theme.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late Future<List<Map<String, dynamic>>> _routinesFuture;

  @override
  void initState() {
    super.initState();
    _routinesFuture = SupabaseService.getRoutines();
  }

  Future<void> _startWorkout(int? routineId) async {
    try {
      final id = await SupabaseService.startWorkout(routineId);
      if (mounted) context.go('/active-workout/$id');
    } catch (e) {
      if (mounted) {
        if (e.toString().contains('Sesión')) {
          context.go('/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrenar'), automaticallyImplyLeading: true),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _routinesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final list = snapshot.data ?? [];

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildFreeWorkoutButton(),
              const SizedBox(height: 32),
              const Text('O ELIGE UNA RUTINA', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 16),
              ...list.map((m) {
                final r = Routine.fromMap(m);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.play_arrow, color: AppColors.green),
                    onTap: () => _startWorkout(r.id),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFreeWorkoutButton() {
    return ElevatedButton.icon(
      onPressed: () => _startWorkout(null),
      icon: const Icon(Icons.bolt),
      label: const Text('ENTRENAMIENTO LIBRE'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.green.withOpacity(0.1),
        foregroundColor: AppColors.green,
        side: const BorderSide(color: AppColors.green),
      ),
    );
  }
}
