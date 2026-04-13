// widgets/pinza_widget.dart
// Pinza robótica animada — se dibuja con código, no necesita imagen
// Úsala así: PinzaWidget(angle: tenazaAngle)

import 'package:flutter/material.dart';
import 'dart:math' as math;

class PinzaWidget extends StatelessWidget {
  final double angle;   // 0 = abierta, 90 = cerrada
  final double size;    // tamaño del widget

  const PinzaWidget({
    super.key,
    required this.angle,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PinzaPainter(angle: angle),
      ),
    );
  }
}

class _PinzaPainter extends CustomPainter {
  final double angle; // 0 a 90

  _PinzaPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final double t = angle / 90.0; // 0.0 = abierta, 1.0 = cerrada
    final double cx = size.width / 2;
    final double cy = size.height / 2 + 10;

    // ---- COLORES ----
    final Paint bodyPaint = Paint()
      ..color = const Color(0xFF30363D)
      ..style = PaintingStyle.fill;

    final Paint bodyStroke = Paint()
      ..color = const Color(0xFF58A6FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final Paint jointPaint = Paint()
      ..color = const Color(0xFF00E5FF)
      ..style = PaintingStyle.fill;

    final Paint armPaint = Paint()
      ..color = const Color(0xFFC9D1D9)
      ..style = PaintingStyle.fill;

    final Paint armStroke = Paint()
      ..color = const Color(0xFF8B949E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Color de las puntas: verde = abierta, rojo = cerrada
    final Paint tipPaint = Paint()
      ..color = t < 0.5
          ? const Color(0xFF00E676)   // verde = abierta
          : const Color(0xFFFF3D00)   // rojo = cerrada
      ..style = PaintingStyle.fill;

    // ---- BASE DEL CUERPO ----
    final RRect body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy + 12), width: 36, height: 44),
      const Radius.circular(6),
    );
    canvas.drawRRect(body, bodyPaint);
    canvas.drawRRect(body, bodyStroke);

    // ---- ARTICULACIÓN CENTRAL ----
    canvas.drawCircle(Offset(cx, cy + 12), 10, jointPaint);

    // ---- BRAZOS (uno arriba, uno abajo) ----
    _drawArm(canvas, cx, cy, t, armPaint, armStroke, tipPaint, isTop: true);
    _drawArm(canvas, cx, cy, t, armPaint, armStroke, tipPaint, isTop: false);
  }

  void _drawArm(
    Canvas canvas,
    double cx,
    double cy,
    double t,
    Paint armPaint,
    Paint armStroke,
    Paint tipPaint, {
    required bool isTop,
  }) {
    final double sign = isTop ? -1.0 : 1.0;

    // Ángulo de apertura: 42° abierta → 8° cerrada
    const double openAngle = 42.0;
    const double closeAngle = 8.0;
    final double armAngleDeg = sign * (openAngle - t * (openAngle - closeAngle));
    final double armAngleRad = armAngleDeg * math.pi / 180.0;

    canvas.save();
    canvas.translate(cx, cy + 12);
    canvas.rotate(armAngleRad);

    // Brazo principal (trapecio)
    final Path arm = Path();
    arm.moveTo(-8, -8);
    arm.lineTo(-6, -60);
    arm.lineTo(6, -60);
    arm.lineTo(8, -8);
    arm.close();
    canvas.drawPath(arm, armPaint);
    canvas.drawPath(arm, armStroke);

    // Punta de la garra
    final Path tip = Path();
    tip.moveTo(6, -60);
    tip.lineTo(16, -65);
    tip.lineTo(22, -52);
    tip.lineTo(10, -52);
    tip.close();
    canvas.drawPath(tip, tipPaint);
    canvas.drawPath(tip, armStroke);

    canvas.restore();
  }

  // Redibuja cuando cambia el ángulo
  @override
  bool shouldRepaint(_PinzaPainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}