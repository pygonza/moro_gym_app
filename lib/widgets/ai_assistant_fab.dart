import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class AIAssistantFAB extends StatefulWidget {
  const AIAssistantFAB({super.key});

  @override
  State<AIAssistantFAB> createState() => _AIAssistantFABState();
}

class _AIAssistantFABState extends State<AIAssistantFAB> {
  void _showChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AIChatSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _showChat,
      child: const Icon(Icons.smart_toy),
    );
  }
}

class _AIChatSheet extends StatefulWidget {
  const _AIChatSheet();

  @override
  State<_AIChatSheet> createState() => _AIChatSheetState();
}

class _AIChatSheetState extends State<_AIChatSheet> {
  final _msgCtrl = TextEditingController();
  final List<Map<String, String>> _history = [
    {'role': 'ai', 'msg': '¡Hola! Soy tu asistente de Moro Gym. ¿En qué puedo ayudarte hoy?'}
  ];
  bool _loading = false;

  Future<void> _send() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _history.add({'role': 'user', 'msg': text});
      _loading = true;
    });
    _msgCtrl.clear();

    final response = await AIService.sendMessage(text);

    setState(() {
      _history.add({'role': 'ai', 'msg': response});
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Asistente Moro Gym', style: Theme.of(context).textTheme.titleLarge),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              itemBuilder: (context, i) {
                final isUser = _history[i]['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Theme.of(context).colorScheme.primary : Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _history[i]['msg']!,
                      style: TextStyle(color: isUser ? Colors.black : Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_loading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    decoration: const InputDecoration(hintText: 'Escribe tu duda...'),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _loading ? null : _send,
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).colorScheme.primary,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
