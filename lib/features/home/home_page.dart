import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/supabase_service.dart';
import '../../models/user_profile.dart';
import '../../widgets/logo_header.dart';
import '../../core/theme.dart';

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
      appBar: AppBar(
        title: const LogoHeader(height: 40),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildWelcomeHeader(),
            const SizedBox(height: 24),
            _buildActionGrid(context),
            const SizedBox(height: 32),
            _buildRecentActivityHeader(),
            const SizedBox(height: 12),
            _buildQuickStartCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hola, ${_profile?.fullName?.split(' ').first ?? 'Guerrero'}',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
            const SizedBox(width: 4),
            Text(
              'Racha de $_streak días',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _ActionCard(
          title: 'Rutinas',
          icon: Icons.fitness_center,
          color: AppColors.green,
          onTap: () => context.go('/routines'),
        ),
        _ActionCard(
          title: 'Progreso',
          icon: Icons.trending_up,
          color: Colors.blueAccent,
          onTap: () => context.go('/progress'),
        ),
        _ActionCard(
          title: 'Logros',
          icon: Icons.emoji_events,
          color: Colors.amber,
          onTap: () => context.go('/achievements'),
        ),
        _ActionCard(
          title: 'Perfil',
          icon: Icons.person,
          color: Colors.purpleAccent,
          onTap: () => context.go('/profile'),
        ),
      ],
    );
  }

  Widget _buildRecentActivityHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Tu Próximo Reto', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildQuickStartCard(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.go('/start-workout'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow, color: AppColors.green, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Iniciar Entrenamiento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Supera tus límites hoy', style: TextStyle(color: Colors.grey[400])),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.lightGrey),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LogoHeader(height: 50),
                const Spacer(),
                Text(_profile?.fullName ?? 'Usuario', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app), 
            title: const Text('Cerrar sesión'), 
            onTap: () async {
              await SupabaseService.signOut();
              if (mounted) context.go('/login');
            }
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({required this.title, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
