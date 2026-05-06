import 'package:flutter/material.dart';

class WorkoutSetRow extends StatelessWidget {
  final int setNumber;
  final TextEditingController weightCtrl;
  final TextEditingController repsCtrl;
  final VoidCallback onDelete;
  final bool isCompleted;

  const WorkoutSetRow({
    super.key,
    required this.setNumber,
    required this.weightCtrl,
    required this.repsCtrl,
    required this.onDelete,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: isCompleted ? Colors.green : Colors.grey[800],
            child: Text('$setNumber', style: const TextStyle(fontSize: 12, color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: weightCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'kg',
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                fillColor: isCompleted ? Colors.green.withOpacity(0.1) : null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: repsCtrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'reps',
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                fillColor: isCompleted ? Colors.green.withOpacity(0.1) : null,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
