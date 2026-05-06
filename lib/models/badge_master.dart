import 'package:flutter/material.dart';

class Badge {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final String conditionDescription;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.conditionDescription,
  });

  static const List<Badge> allBadges = [
    Badge(
      id: 'first_workout',
      name: 'Primer Paso',
      description: 'Completaste tu primer entrenamiento.',
      icon: Icons.directions_run,
      conditionDescription: '1 sesión completada',
    ),
    Badge(
      id: 'streak_3',
      name: 'Constancia',
      description: 'Entrenaste 3 días seguidos.',
      icon: Icons.local_fire_department,
      conditionDescription: 'Racha de 3 días',
    ),
    Badge(
      id: 'streak_7',
      name: 'Constancia de Hierro',
      description: 'Entrenaste 7 días seguidos.',
      icon: Icons.fitness_center,
      conditionDescription: 'Racha de 7 días',
    ),
    Badge(
      id: 'streak_30',
      name: 'Incombustible',
      description: '¡Un mes entero dándolo todo!',
      icon: Icons.workspace_premium,
      conditionDescription: 'Racha de 30 días',
    ),
    Badge(
      id: 'sessions_10',
      name: 'Veterano',
      description: 'Has completado 10 sesiones.',
      icon: Icons.military_tech,
      conditionDescription: '10 sesiones totales',
    ),
    Badge(
      id: 'sessions_50',
      name: 'Bestia del Moro',
      description: '50 entrenamientos alcanzados.',
      icon: Icons.bolt,
      conditionDescription: '50 sesiones totales',
    ),
    Badge(
      id: 'sessions_100',
      name: 'Leyenda del Moro',
      description: '100 entrenamientos. ¡Eres imparable!',
      icon: Icons.star,
      conditionDescription: '100 sesiones totales',
    ),
    Badge(
      id: 'bench_100',
      name: 'Club de los 100',
      description: 'Levantaste 100kg o más en Press de Banca.',
      icon: Icons.fitness_center,
      conditionDescription: '100kg en Press de banca',
    ),
    Badge(
      id: 'deadlift_200',
      name: 'Poder Puro',
      description: 'Levantaste 200kg en Peso Muerto.',
      icon: Icons.straighten,
      conditionDescription: '200kg en Peso muerto',
    ),
    Badge(
      id: 'squat_150',
      name: 'Piernas de Acero',
      description: 'Levantaste 150kg en Sentadilla.',
      icon: Icons.layers,
      conditionDescription: '150kg en Sentadilla',
    ),
    Badge(
      id: 'exercises_10',
      name: 'Polivalente',
      description: 'Has usado 10 ejercicios diferentes.',
      icon: Icons.category,
      conditionDescription: '10 ejercicios usados',
    ),
    Badge(
      id: 'routine_completed',
      name: 'Planificador',
      description: 'Completaste una rutina personalizada.',
      icon: Icons.assignment_turned_in,
      conditionDescription: '1 rutina propia terminada',
    ),
    Badge(
      id: 'routine_creator',
      name: 'Arquitecto',
      description: 'Has creado tu propia rutina.',
      icon: Icons.architecture,
      conditionDescription: '1 rutina creada',
    ),
    Badge(
      id: 'free_workout_lover',
      name: 'Espíritu Libre',
      description: 'Te gusta entrenar sin planes fijos.',
      icon: Icons.explore,
      conditionDescription: '5 entrenos libres',
    ),
    Badge(
      id: 'early_bird',
      name: 'Madrugador',
      description: 'Entrenaste antes de las 8 AM.',
      icon: Icons.wb_sunny,
      conditionDescription: 'Entreno antes de 8:00',
    ),
    Badge(
      id: 'night_owl',
      name: 'Noctámbulo',
      description: 'Entrenaste después de las 10 PM.',
      icon: Icons.dark_mode,
      conditionDescription: 'Entreno después de 22:00',
    ),
    Badge(
      id: 'volume_beast',
      name: 'Bestia del Volumen',
      description: 'Más de 20 series en una sesión.',
      icon: Icons.reorder,
      conditionDescription: '+20 series en un día',
    ),
    Badge(
      id: 'consistency_king',
      name: 'Rey de la Disciplina',
      description: 'Entrenaste 5 días en una misma semana.',
      icon: Icons.calendar_month,
      conditionDescription: '5 entrenos en 7 días',
    ),
    Badge(
      id: 'social_gym',
      name: 'Compañero',
      description: 'Has registrado notas en tus sesiones.',
      icon: Icons.chat,
      conditionDescription: '5 sesiones con notas',
    ),
    Badge(
      id: 'legend',
      name: 'LEYENDA',
      description: 'Has desbloqueado el potencial máximo.',
      icon: Icons.emoji_events,
      conditionDescription: '15 logros obtenidos',
    ),
  ];
}
