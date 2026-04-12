// widgets/app_theme.dart
// Todos los colores y estilos en un solo lugar
// Como variables CSS pero en Flutter

import 'package:flutter/material.dart';

class AppTheme {
  // ---- COLORES ----
  static const Color bgDark       = Color(0xFF0D1117);   // fondo principal
  static const Color bgCard       = Color(0xFF161B22);   // fondo de tarjetas
  static const Color bgCardLight  = Color(0xFF21262D);   // fondo hover
  static const Color cyan         = Color(0xFF00E5FF);   // acento principal
  static const Color green        = Color(0xFF00E676);   // seguridad ON
  static const Color red          = Color(0xFFFF3D00);   // emergencia / OFF
  static const Color orange       = Color(0xFFFFAB00);   // advertencia
  static const Color textPrimary  = Color(0xFFE6EDF3);   // texto principal
  static const Color textSecondary= Color(0xFF8B949E);   // texto secundario
  static const Color border       = Color(0xFF30363D);   // bordes

  // ---- ESTILOS DE TEXTO ----
  static const TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: cyan,
    letterSpacing: 2,
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 12,
    color: textSecondary,
    letterSpacing: 1,
  );

  static const TextStyle valueStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  // ---- DECORACIÓN DE TARJETAS ----
  static BoxDecoration cardDecoration = BoxDecoration(
    color: bgCard,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: border, width: 1),
  );

  static BoxDecoration cardDecorationAccent = BoxDecoration(
    color: bgCard,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: cyan.withOpacity(0.5), width: 1),
    boxShadow: [
      BoxShadow(
        color: cyan.withOpacity(0.1),
        blurRadius: 12,
        spreadRadius: 2,
      ),
    ],
  );
}