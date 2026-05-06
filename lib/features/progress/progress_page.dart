import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/supabase_service.dart';
import '../../core/theme.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
  }

  Future<Map<String, dynamic>> _loadData() async {
    final sessions = await SupabaseService.getSessions(limit: 20);
    // Podrías cargar más datos como volumen por sesión aquí
    return {'sessions': sessions};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Progreso'),
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final sessions = snapshot.data?['sessions'] as List<Map<String, dynamic>>? ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Evolución de Volumen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                _buildChart(),
                const SizedBox(height: 32),
                const Text('Historial de Sesiones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                if (sessions.isEmpty)
                  const Center(child: Text('No hay sesiones registradas.', style: TextStyle(color: Colors.grey))),
                ...sessions.map((s) => _buildSessionCard(s)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 3),
                const FlSpot(1, 4),
                const FlSpot(2, 3.5),
                const FlSpot(3, 5),
                const FlSpot(4, 4.5),
                const FlSpot(5, 6),
              ],
              isCurved: true,
              color: AppColors.green,
              barWidth: 4,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: AppColors.green.withOpacity(0.1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> s) {
    final date = DateTime.parse(s['started_at']);
    final finished = s['finished_at'] != null;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(finished ? Icons.check_circle : Icons.timer, color: finished ? Colors.green : Colors.orange),
        title: Text(s['routines']?['name'] ?? 'Entrenamiento Libre'),
        subtitle: Text('${date.day}/${date.month} - ${s['notes'] ?? ''}'),
      ),
    );
  }
}
