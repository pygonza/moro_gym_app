import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'services/ai_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vfqcvxnqhszdygoeneku.supabase.co', // Tu URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZmcWN2eG5xaHN6ZHlnb2VuZWt1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgwODcyMDEsImV4cCI6MjA5MzY2MzIwMX0.Jfuoc-k-gxCj-2E2UkWQ7k6v3todzycC2ndAh8M5nkg', // Tu anon key
  );

  // Inicializamos el asistente. Puedes poner tu API Key de Gemini aquí.
  // Es gratis en https://aistudio.google.com/
  AIService.init('AIzaSyA8n0h_AJZqxVWX5kg_W9_F7oQqjd9UUwI');

  runApp(const MyApp());
}
