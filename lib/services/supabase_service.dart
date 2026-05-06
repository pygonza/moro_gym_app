import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  // --- AUTH ---
  static Future<AuthResponse> signUp(String email, String password, String fullName) {
    return client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  static Future<AuthResponse> signIn(String email, String password) {
    return client.auth.signInWithPassword(email: email, password: password);
  }

  static Future<void> signOut() => client.auth.signOut();

  // --- PROFILE ---
  static Future<Map<String, dynamic>?> getProfile() async {
    final user = client.auth.currentUser;
    if (user == null) return null;
    try {
      final data = await client.from('profiles').select().eq('id', user.id).maybeSingle();
      return data;
    } catch (e) {
      return null;
    }
  }

  static Future<void> updateStreak(int streak, DateTime lastDate) async {
    final user = client.auth.currentUser;
    if (user == null) return;
    await client.from('profiles').update({
      'current_streak': streak,
      'last_workout_date': lastDate.toIso8601String().split('T').first,
    }).eq('id', user.id);
  }

  // --- EXERCISES ---
  static Future<List<Map<String, dynamic>>> getAllExercises() async {
    final data = await client.from('exercises').select().order('name');
    return List<Map<String, dynamic>>.from(data);
  }

  // --- ROUTINES ---
  static Future<List<Map<String, dynamic>>> getRoutines() async {
    final user = client.auth.currentUser;
    if (user == null) return [];
    final data = await client.from('routines')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  static Future<int> createRoutine(String name, String? description) async {
    final user = client.auth.currentUser!;
    final res = await client.from('routines').insert({
      'user_id': user.id,
      'name': name,
      'description': description,
    }).select('id').single();
    return res['id'] as int;
  }

  static Future<void> addExerciseToRoutine(int routineId, int exerciseId, int sets, int reps, int rest, int order) async {
    await client.from('routine_exercises').insert({
      'routine_id': routineId,
      'exercise_id': exerciseId,
      'sets': sets,
      'reps': reps,
      'rest_seconds': rest,
      'order_index': order,
    });
  }

  static Future<List<Map<String, dynamic>>> getRoutineExercises(int routineId) async {
    final data = await client.from('routine_exercises')
        .select('*, exercises(*)')
        .eq('routine_id', routineId)
        .order('order_index');
    return List<Map<String, dynamic>>.from(data);
  }

  // --- WORKOUT SESSIONS ---
  static Future<int> startWorkout(int? routineId) async {
    final user = client.auth.currentUser!;
    final res = await client.from('workout_sessions').insert({
      'user_id': user.id,
      'routine_id': routineId,
      'started_at': DateTime.now().toIso8601String(),
    }).select('id').single();
    return res['id'] as int;
  }

  static Future<void> finishWorkout(int sessionId, {String? notes}) async {
    await client.from('workout_sessions').update({
      'finished_at': DateTime.now().toIso8601String(),
      'notes': notes,
    }).eq('id', sessionId);
  }

  static Future<List<Map<String, dynamic>>> getSessions({int limit = 10}) async {
    final user = client.auth.currentUser;
    if (user == null) return [];
    final data = await client.from('workout_sessions')
        .select('*, routines(name)')
        .eq('user_id', user.id)
        .order('started_at', ascending: false)
        .limit(limit);
    return List<Map<String, dynamic>>.from(data);
  }

  // --- SET LOGS ---
  static Future<void> logSet(int sessionId, int exerciseId, int setNumber, int reps, double weight) async {
    await client.from('set_logs').insert({
      'session_id': sessionId,
      'exercise_id': exerciseId,
      'set_number': setNumber,
      'reps_done': reps,
      'weight_kg': weight,
    });
  }

  static Future<List<Map<String, dynamic>>> getSetLogs(int sessionId) async {
    final data = await client.from('set_logs')
        .select('*, exercises(name)')
        .eq('session_id', sessionId)
        .order('created_at');
    return List<Map<String, dynamic>>.from(data);
  }

  // --- ACHIEVEMENTS ---
  static Future<List<Map<String, dynamic>>> getAchievements() async {
    final user = client.auth.currentUser;
    if (user == null) return [];
    final data = await client.from('achievements').select().eq('user_id', user.id);
    return List<Map<String, dynamic>>.from(data);
  }

  static Future<void> awardBadge(String badgeName, String description) async {
    final user = client.auth.currentUser;
    if (user == null) return;
    
    final existing = await client.from('achievements')
        .select().eq('user_id', user.id).eq('badge_name', badgeName).maybeSingle();
    
    if (existing == null) {
      await client.from('achievements').insert({
        'user_id': user.id,
        'badge_name': badgeName,
        'description': description,
      });
    }
  }
}
