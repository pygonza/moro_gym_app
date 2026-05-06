import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/supabase_service.dart';
import '../../models/routine.dart';
import '../../core/theme.dart';

class RoutinesPage extends StatefulWidget {
  const RoutinesPage({super.key});

  @override
  State<RoutinesPage> createState() => _RoutinesPageState();
}

class _RoutinesPageState extends State<RoutinesPage> {
  late Future<List<Map<String, dynamic>>> _routinesFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _routinesFuture = SupabaseService.getRoutines();
    });
  }

  Future<void> _createNewRoutine() async {
    final nameCtrl = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva Rutina'),
        content: TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCELAR')),
          FilledButton(onPressed: () => Navigator.pop(ctx, nameCtrl.text.trim()), child: const Text('CREAR')),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      try {
        final id = await SupabaseService.createRoutine(name, '');
        if (mounted) context.go('/routine/$id');
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rutinas'), automaticallyImplyLeading: true),
      floatingActionButton: FloatingActionButton(onPressed: _createNewRoutine, child: const Icon(Icons.add)),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _routinesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final list = snapshot.data ?? [];
          if (list.isEmpty) return const Center(child: Text('Sin rutinas. ¡Crea una!'));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final r = Routine.fromMap(list[i]);
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.fitness_center, color: AppColors.green),
                  title: Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () => context.go('/routine/${r.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
