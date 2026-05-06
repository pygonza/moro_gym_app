import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/supabase_service.dart';
import '../../models/user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = SupabaseService.getProfile();
  }

  void _retry() {
    setState(() {
      _profileFuture = SupabaseService.getProfile();
    });
  }

  Future<void> _recreate() async {
    try {
      await SupabaseService.recreateProfile('Guerrero Moro');
      _retry();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return _buildErrorState('Error de conexión o permisos.');
          }

          final data = snapshot.data;
          if (data == null) {
            return _buildNoProfileState();
          }

          final profile = UserProfile.fromMap(data);
          return _buildProfileContent(profile);
        },
      ),
    );
  }

  Widget _buildErrorState(String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(msg),
          TextButton(onPressed: _retry, child: const Text('REINTENTAR')),
        ],
      ),
    );
  }

  Widget _buildNoProfileState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Perfil no encontrado'),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _recreate, child: const Text('RECREAR PERFIL')),
        ],
      ),
    );
  }

  Widget _buildProfileContent(UserProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 16),
          Text(profile.fullName ?? 'Usuario', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _StatCard(profile: profile),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await SupabaseService.signOut();
                if (mounted) context.go('/login');
              },
              icon: const Icon(Icons.logout),
              label: const Text('CERRAR SESIÓN'),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent, side: const BorderSide(color: Colors.redAccent)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final UserProfile profile;
  const _StatCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(children: [Text('${profile.currentStreak}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)), const Text('Racha 🔥')]),
            Column(children: [Text(profile.lastWorkoutDate != null ? '${profile.lastWorkoutDate!.day}/${profile.lastWorkoutDate!.month}' : '--/--', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)), const Text('Último')]),
          ],
        ),
      ),
    );
  }
}
