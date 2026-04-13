// widgets/robot_card.dart
// Tarjeta reutilizable para cada sección

import 'package:flutter/material.dart';
import 'app_theme.dart';

class RobotCard extends StatelessWidget {
  final String title;         // título de la tarjeta
  final Widget child;         // contenido adentro
  final bool isAccented;      // si tiene borde de color cyan
  final Color? accentColor;   // color del borde personalizado

  const RobotCard({
    super.key,
    required this.title,
    required this.child,
    this.isAccented = false,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: accentColor != null
          ? BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: accentColor!.withOpacity(0.6), width: 1),
              boxShadow: [
                BoxShadow(
                  color: accentColor!.withOpacity(0.15),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            )
          : isAccented
              ? AppTheme.cardDecorationAccent
              : AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado de la tarjeta
          Row(
            children: [
              Container(
                width: 3,
                height: 16,
                decoration: BoxDecoration(
                  color: accentColor ?? AppTheme.cyan,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: AppTheme.labelStyle.copyWith(
                  color: accentColor ?? AppTheme.cyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}