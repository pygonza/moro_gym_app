import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../models/user_profile.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await SupabaseService.getProfile();
    if (data != null && mounted) {
      setState(() => _profile = UserProfile.fromMap(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: _profile == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40))),
            const SizedBox(height: 16),
            Center(child: Text(_profile!.fullName ?? 'Sin nombre', style: Theme.of(context).textTheme.headlineSmall)),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(label: 'Racha', value: '${_profile!.currentStreak} días'),
                    _StatItem(label: 'Último', value: _profile!.lastWorkoutDate != null
                        ? _profile!.lastWorkoutDate.toString().substring(0, 10)
                        : 'Nunca'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  await SupabaseService.signOut();
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const _LogoutScreen()),
                      (route) => false,
                    );
                  }
                },
                child: const Text('Cerrar sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey[400])),
      ],
    );
  }
}

class _LogoutScreen extends StatelessWidget {
  const _LogoutScreen();
  @override
  Widget build(BuildContext context) {
    // Solo para navegar a login
    return const LoginPage();
  }
}