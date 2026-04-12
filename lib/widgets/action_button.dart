// widgets/action_button.dart
// Botón de acción reutilizable con click corto y largo

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';

class ActionButton extends StatelessWidget {
  final String label;         // nombre del botón
  final String description;   // descripción debajo
  final IconData icon;
  final Color color;
  final bool enabled;
  final VoidCallback? onTap;       // click corto
  final VoidCallback? onLongPress; // click largo

  const ActionButton({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled
          ? () {
              HapticFeedback.lightImpact(); // vibración leve
              onTap?.call();
            }
          : null,
      onLongPress: enabled
          ? () {
              HapticFeedback.heavyImpact(); // vibración fuerte
              onLongPress?.call();
            }
          : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.4,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.bgCardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: enabled ? color.withOpacity(0.5) : AppTheme.border,
              width: 1,
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.15),
                      blurRadius: 8,
                    )
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: enabled ? color : AppTheme.textSecondary, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: enabled ? AppTheme.textPrimary : AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}