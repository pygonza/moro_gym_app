import 'package:flutter/material.dart';

class LogoHeader extends StatelessWidget {
  final double height;
  const LogoHeader({super.key, this.height = 150});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback en caso de que el archivo no esté o tenga errores
        return Column(
          children: [
            Icon(Icons.fitness_center, size: height * 0.6, color: Theme.of(context).colorScheme.primary),
            Text(
              'MORO GYM',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: height * 0.15,
              ),
            ),
          ],
        );
      },
    );
  }
}
