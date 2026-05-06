import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  List<Map<String, dynamic>> _achievements = [];
  bool _loading = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logros')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _achievements.isEmpty
          ? const Center(child: Text('Aún no has conseguido logros. ¡Entrena para ganarlos!'))
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1),
        itemCount: _achievements.length,
        itemBuilder: (_, i) {
          final a = _achievements[i];
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, size: 40, color: Colors.amber),
                const SizedBox(height: 8),
                Text(a['badge_name'], textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                if (a['description'] != null)
                  Text(a['description'], textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
              ],
            ),
          );
        },
      ),
    );
  }
}