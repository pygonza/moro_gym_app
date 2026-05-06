import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/supabase_service.dart';
import '../../models/user_profile.dart';
import '../../widgets/ai_assistant_fab.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  UserProfile? _profile;
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await SupabaseService.getProfile();
    if (data != null && mounted) {
      setState(() {
        _profile = UserProfile.fromMap(data);
        _streak = _profile!.currentStreak;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moro Gym')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(radius: 30, child: Icon(Icons.person, size: 30)),
                  const SizedBox(height: 8),
                  Text(_profile?.fullName ?? 'Usuario', style: const TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            ListTile(leading: const Icon(Icons.fitness_center), title: const Text('Rutinas'), onTap: () => context.go('/routines')),
            ListTile(leading: const Icon(Icons.trending_up), title: const Text('Progreso'), onTap: () => context.go('/progress')),
            ListTile(leading: const Icon(Icons.emoji_events), title: const Text('Logros'), onTap: () => context.go('/achievements')),
            ListTile(leading: const Icon(Icons.person), title: const Text('Perfil'), onTap: () => context.go('/profile')),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                await SupabaseService.signOut();
                if (mounted) context.go('/login');
              },
            ),
          ],
        ),
      ),
      floatingActionButton: const AIAssistantFAB(),
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('¡Bienvenido!', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text('Racha actual: $_streak días', style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.primary)),
                    if (_profile?.currentStreak == 0)
                      const Text('¡Empieza tu primera sesión hoy!'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Acciones rápidas', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Iniciar entreno'),
                    onPressed: () => context.go('/start-workout'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.list_alt),
                    label: const Text('Mis rutinas'),
                    onPressed: () => context.go('/routines'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.emoji_events),
                    label: const Text('Logros'),
                    onPressed: () => context.go('/achievements'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}