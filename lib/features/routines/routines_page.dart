import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/supabase_service.dart';
import '../../models/routine.dart';

class RoutinesPage extends StatefulWidget {
  const RoutinesPage({super.key});

  @override
  State<RoutinesPage> createState() => _RoutinesPageState();
}

class _RoutinesPageState extends State<RoutinesPage> {
  List<Routine> _routines = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    final data = await SupabaseService.getRoutines();
    setState(() {
      _routines = data.map((m) => Routine.fromMap(m)).toList();
      _loading = false;
    });
  }

  Future<void> _createNewRoutine() async {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva rutina'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descripción (opcional)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, nameCtrl.text.trim()),
            child: const Text('Crear'),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      final id = await SupabaseService.createRoutine(name, descCtrl.text.trim());
      // Navegar a detalle para agregar ejercicios
      if (mounted) context.go('/routine/$id');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Rutinas')),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewRoutine,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _routines.isEmpty
          ? const Center(child: Text('No tienes rutinas. Crea una.'))
          : ListView.builder(
        itemCount: _routines.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.fitness_center),
          title: Text(_routines[i].name),
          subtitle: Text(_routines[i].description ?? 'Sin descripción'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/routine/${_routines[i].id}'),
        ),
      ),
    );
  }
}