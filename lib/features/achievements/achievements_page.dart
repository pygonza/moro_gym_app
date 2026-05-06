import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../models/badge_master.dart' as master;
import '../../core/theme.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logros'), automaticallyImplyLeading: true),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: SupabaseService.getAchievements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final earned = (snapshot.data ?? []).map((a) => a['badge_name'] as String).toSet();
          
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemCount: master.Badge.allBadges.length,
            itemBuilder: (context, i) {
              final b = master.Badge.allBadges[i];
              final has = earned.contains(b.name);
              return Opacity(
                opacity: has ? 1.0 : 0.3,
                child: Card(
                  color: has ? AppColors.green.withOpacity(0.05) : null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(b.icon, size: 48, color: has ? Colors.amber : Colors.grey),
                      const SizedBox(height: 12),
                      Text(b.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), child: Text(b.description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.grey))),
                      if (has) const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
