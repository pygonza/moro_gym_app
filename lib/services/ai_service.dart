import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

class AIService {
  // NOTA: En una app real, esta API KEY debería estar protegida o venir de un backend.
  // Para este prototipo 0$, el usuario puede generar una gratis en Google AI Studio.
  static String? _apiKey;
  static GenerativeModel? _model;
  static ChatSession? _chat;

  static void init(String apiKey) {
    _apiKey = apiKey;
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey!,
    );
    _chat = _model!.startChat();
  }

  static bool get isInitialized => _apiKey != null;

  static Future<String> sendMessage(String message) async {
    if (_chat == null) return "Asistente no inicializado.";
    
    try {
      final response = await _chat!.sendMessage(Content.text(
        "Eres un entrenador personal experto del gimnasio 'Moro Gym'. "
        "Tu objetivo es ayudar a los usuarios con sus rutinas, técnica de ejercicios y motivación. "
        "Responde de forma concisa y profesional. Pregunta del usuario: $message"
      ));
      return response.text ?? "No pude procesar tu solicitud.";
    } catch (e) {
      debugPrint("Error en AI Service: $e");
      return "Lo siento, hubo un error conectando con mi cerebro artificial.";
    }
  }
}
