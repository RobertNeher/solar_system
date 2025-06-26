import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:solar_system/src/helper.dart';

class SolarSystemPainter extends CustomPainter {
  final double
  animationValue; // Der aktuelle Wert des Animationscontrollers (0.0 bis 1.0)
  final List<Map<String, dynamic>> planets;
  final Map<String, dynamic> settings; // Liste der Planeten zum Zeichnen
  SolarSystemPainter(this.animationValue, this.settings, this.planets);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Zeichne die Sonne.
    final sunPaint = Paint()..color = colorFromString(settings['sunColor']);
    canvas.drawCircle(center, settings['sunSize'], sunPaint);

    // Draw each planet on the list
    for (var planet in planets) {
      final double orbitalRadius = planet['orbitalRadius'].toDouble();
      final Color planetColor = colorFromString(planet['color']);
      final double planetRadius = planet['radius'].toDouble();
      final double speed = planet['speed'].toDouble();
      // Draw orbits
      final orbitPaint = Paint()
        ..color = Colors.white12
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      canvas.drawCircle(center, orbitalRadius, orbitPaint);

      final double angle =
          (animationValue * speed * 2 * math.pi) % (2 * math.pi);

      final double planetX = center.dx + orbitalRadius * math.cos(angle);
      final double planetY = center.dy + orbitalRadius * math.sin(angle);
      final Offset planetPosition = Offset(planetX, planetY);

      final planetPaint = Paint()..color = planetColor;
      canvas.drawCircle(planetPosition, planetRadius, planetPaint);
      TextSpan planetName = TextSpan(text: planet['name']);
      TextPainter namePainter = TextPainter(
        text: planetName,
        textAlign: TextAlign.center,
      );
      namePainter.layout();
      namePainter.paint(canvas, planetPosition);
    }
  }

  @override
  bool shouldRepaint(covariant SolarSystemPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
