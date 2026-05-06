import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<Map<String, dynamic>> _sessions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await SupabaseService.getSessions(limit: 20);
    setState(() {
      _sessions = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progreso')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _sessions.isEmpty
          ? const Center(child: Text('Aún no hay sesiones'))
          : Column(
        children: [
          const SizedBox(height: 16),
          Text('Últimas sesiones', style: Theme.of(context).textTheme.titleMedium),
          Expanded(
            child: ListView.builder(
              itemCount: _sessions.length,
              itemBuilder: (_, i) {
                final s = _sessions[i];
                return ListTile(
                  leading: Icon(Icons.check_circle, color: s['finished_at'] != null ? Colors.green : Colors.orange),
                  title: Text(s['routines'] != null ? s['routines']['name'] : 'Libre'),
                  subtitle: Text(s['started_at'].toString().substring(0, 16)),
                  trailing: s['finished_at'] != null ? const Icon(Icons.done) : const Text('En progreso'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}