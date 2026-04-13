// widgets/robot_slider.dart
// Slider reutilizable con etiqueta y valor en grados

import 'package:flutter/material.dart';
import 'app_theme.dart';

class RobotSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final bool enabled;
  final Color color;
  final ValueChanged<double> onChanged;

  const RobotSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 90,
    this.enabled = true,
    this.color = AppTheme.cyan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fila con nombre y valor actual
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTheme.labelStyle,
            ),
            // El número de grados
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.bgCardLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.4)),
              ),
              child: Text(
                "${value.toInt()}°",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: enabled ? color : AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // El slider en sí
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: enabled ? color : AppTheme.textSecondary,
            inactiveTrackColor: AppTheme.border,
            thumbColor: enabled ? color : AppTheme.textSecondary,
            overlayColor: color.withOpacity(0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            // Si no está habilitado, no hace nada al mover
            onChanged: enabled ? onChanged : null,
          ),
        ),

        // Etiquetas min/max
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${min.toInt()}°", style: AppTheme.labelStyle),
            Text("${max.toInt()}°", style: AppTheme.labelStyle),
          ],
        ),
      ],
    );
  }
}