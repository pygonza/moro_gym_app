import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme.dart';
import 'features/auth/auth_gate.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/home/home_page.dart';
import 'features/routines/routines_page.dart';
import 'features/routines/routines_detail_page.dart';
import 'features/workout/workout_page.dart';
import 'features/workout/active_workout_page.dart';
import 'features/progress/progress_page.dart';
import 'features/achievements/achievements_page.dart';
import 'features/profile/profile_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      if (session == null && !isAuthRoute) return '/login';
      if (session != null && isAuthRoute) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/routines',
        builder: (context, state) => const RoutinesPage(),
      ),
      GoRoute(
        path: '/routine/:id',
        builder: (context, state) => RoutineDetailPage(routineId: int.parse(state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/start-workout',
        builder: (context, state) => const WorkoutPage(),
      ),
      GoRoute(
        path: '/active-workout/:sessionId',
        builder: (context, state) => ActiveWorkoutPage(sessionId: int.parse(state.pathParameters['sessionId']!)),
      ),
      GoRoute(
        path: '/progress',
        builder: (context, state) => const ProgressPage(),
      ),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const AchievementsPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
});

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          final router = ref.watch(routerProvider);
          return MaterialApp.router(
            title: 'Moro Gym',
            theme: appTheme,
            routerConfig: router,
          );
        },
      ),
    );
  }
}