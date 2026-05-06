import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/supabase_service.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  List<Map<String, dynamic>> _achievements = [];
  bool _loading = true;

  final List<Map<String, String>> _milestones = [
    {'name': 'Primer Paso', 'desc': 'Completa tu primer entrenamiento.'},
    {'name': 'Constancia', 'desc': 'Entrena 3 días seguidos.'},
    {'name': 'Guerrero', 'desc': 'Entrena 7 días seguidos.'},
    {'name': 'Fuerza Bruta', 'desc': 'Registra más de 100kg en cualquier ejercicio.'},
    {'name': 'Madrugador', 'desc': 'Entrena antes de las 8 AM.'},
    {'name': 'Bestia del Moro', 'desc': 'Completa 50 sesiones de entrenamiento.'},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await SupabaseService.getAchievements();
    setState(() {
      _achievements = data;
      _loading = false;
    });
  }

  bool _isUnlocked(String name) {
    return _achievements.any((a) => a['badge_name'] == name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Mis Logros'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _milestones.length,
              itemBuilder: (_, i) {
                final m = _milestones[i];
                final unlocked = _isUnlocked(m['name']!);
                return Opacity(
                  opacity: unlocked ? 1.0 : 0.4,
                  child: Card(
                    color: unlocked ? Colors.green.withOpacity(0.05) : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_events,
                          size: 48,
                          color: unlocked ? Colors.amber : Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          m['name']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                          child: Text(
                            m['desc']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                          ),
                        ),
                        if (unlocked)
                          const Icon(Icons.check_circle, color: Colors.green, size: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
