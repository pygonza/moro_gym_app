import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  /// Asegura que hay un usuario autenticado.
  static Future<User> _getSecureUser() async {
    final user = client.auth.currentUser;
    if (user == null) {
      throw Exception('Sesión expirada. Por favor, inicia sesión de nuevo.');
    }
    return user;
  }

  // --- AUTH ---
  static Future<AuthResponse> signUp(String email, String password, String fullName) async {
    final res = await client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
    
    if (res.user != null) {
      // Forzar creación de perfil manual para evitar fallos de RLS inicial
      try {
        await client.from('profiles').upsert({
          'id': res.user!.id,
          'full_name': fullName,
          'current_streak': 0,
        });
      } catch (e) {
        print("Error upserting profile: $e");
      }
    }
    return res;
  }

  static Future<AuthResponse> signIn(String email, String password) =>
      client.auth.signInWithPassword(email: email, password: password);

  static Future<void> signOut() => client.auth.signOut();

  // --- PROFILE ---
  static Future<Map<String, dynamic>?> getProfile() async {
    final user = client.auth.currentUser;
    if (user == null) return null;
    try {
      return await client.from('profiles').select().eq('id', user.id).maybeSingle();
    } catch (e) {
      print("Error en getProfile: $e");
      return null;
    }
  }

  static Future<void> recreateProfile(String fullName) async {
    final user = await _getSecureUser();
    await client.from('profiles').upsert({
      'id': user.id,
      'full_name': fullName,
    });
  }

  // --- EXERCISES ---
  static Future<List<Map<String, dynamic>>> getAllExercises() async {
    final data = await client.from('exercises').select().order('name');
    return List<Map<String, dynamic>>.from(data);
  }

  static Future<int> createExercise({
    required String name,
    String? muscleGroup,
    String? equipment,
    String? difficulty,
    String? instructions,
  }) async {
    await _getSecureUser();
    final res = await client.from('exercises').insert({
      'name': name,
      'muscle_group': muscleGroup,
      'equipment': equipment,
      'difficulty': difficulty,
      'instructions': instructions,
    }).select('id').single();
    return res['id'] as int;
  }

  // --- ROUTINES ---
  static Future<List<Map<String, dynamic>>> getRoutines() async {
    final user = client.auth.currentUser;
    if (user == null) return [];
    final data = await client.from('routines')
        .select()
        .or('user_id.eq.${user.id},user_id.is.null')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  static Future<int> createRoutine(String name, String? description) async {
    final user = await _getSecureUser();
    final res = await client.from('routines').insert({
      'user_id': user.id,
      'name': name,
      'description': description,
    }).select('id').single();
    return res['id'] as int;
  }

  static Future<void> addExerciseToRoutine(int routineId, int exerciseId, int sets, int reps, int rest, int order) async {
    await _getSecureUser();
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
    final user = await _getSecureUser();
    final res = await client.from('workout_sessions').insert({
      'user_id': user.id,
      'routine_id': routineId,
      'started_at': DateTime.now().toIso8601String(),
    }).select('id').single();
    return res['id'] as int;
  }

  static Future<void> logSet(int sessionId, int exerciseId, int setNumber, int reps, double weight) async {
    await _getSecureUser();
    await client.from('set_logs').insert({
      'session_id': sessionId,
      'exercise_id': exerciseId,
      'set_number': setNumber,
      'reps_done': reps,
      'weight_kg': weight,
    });
  }

  static Future<void> finishWorkout(int sessionId, {String? notes}) async {
    await _getSecureUser();
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

  // --- ACHIEVEMENTS ---
  static Future<List<Map<String, dynamic>>> getAchievements() async {
    final user = client.auth.currentUser;
    if (user == null) return [];
    final data = await client.from('achievements').select().eq('user_id', user.id);
    return List<Map<String, dynamic>>.from(data);
  }
}
