import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:solar_system/src/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SolarSystemPainter extends CustomPainter {
  final double animationValue;
  final double orbitalValue;
  final List<Map<String, dynamic>> planets;
  final Map<String, dynamic> settings; // Liste der Planeten zum Zeichnen
  SolarSystemPainter(
    this.animationValue,
    this.orbitalValue,
    this.settings,
    this.planets,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Central star
    final TextStyle sunNameStyle = TextStyle(
      fontFamily: settings['sun']['font'],
      color: colorFromString(settings['sun']['fontColor']),
      fontSize: settings['sun']['fontSize'].toDouble(),
    );
    final sunPaint = Paint()..color = colorFromString(settings['sun']['color']);
    canvas.drawCircle(center, settings['sun']['radius'].toDouble(), sunPaint);

    TextSpan sunName = TextSpan(
      text: settings['sun']['name'],
      style: sunNameStyle,
    );
    TextPainter planetNamePainter = TextPainter(
      text: sunName,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    planetNamePainter.layout();
    planetNamePainter.paint(
      canvas,
      Offset(
        center.dx - planetNamePainter.width / 2,
        center.dy - planetNamePainter.height / 2,
      ),
    );

    // Draw each planet on the list
    for (var planet in planets) {
      final double orbitalRadius = planet['orbitalRadius'].toDouble();
      final Color planetColor = colorFromString(planet['color']);
      final double planetRadius = planet['radius'].toDouble();
      final double speed = planet['speed'].toDouble();
      final TextStyle planetNameStyle = TextStyle(
        fontFamily: settings['planetName']['font'],
        color: colorFromString(settings['planetName']['fontColor']),
        fontSize: settings['planetName']['fontSize'].toDouble(),
      );
      final TextStyle infoStyle = TextStyle(
        fontFamily: settings['infoBar']['font'],
        color: colorFromString(settings['infoBar']['fontColor']),
        fontSize: settings['infoBar']['fontSize'].toDouble(),
      );
      final double totalDaysInYear = DateTime(
        DateTime.now().year,
        12,
        31,
      ).difference(DateTime(DateTime.now().year, 1, 1)).inDays.toDouble();

      if (settings['orbits']['visible']) {
        // Draw orbits
        final orbitPaint = Paint()
          ..color = colorFromString(settings['orbits']['color'])
          ..style = PaintingStyle.stroke
          ..strokeWidth = settings['orbits']['width'].toDouble();
        canvas.drawCircle(center, orbitalRadius, orbitPaint);
      }
      final double angle = (orbitalValue * speed * 2 * math.pi) % (2 * math.pi);
      final double planetX = center.dx + orbitalRadius * math.cos(angle);
      final double planetY = center.dy + orbitalRadius * math.sin(angle);
      final Offset planetPosition = Offset(planetX, planetY);
      final Paint planetPaint = Paint()..color = planetColor;

      canvas.drawCircle(planetPosition, planetRadius, planetPaint);
      TextSpan planetName = TextSpan(
        text: planet['name'],
        style: planetNameStyle,
      );
      TextPainter planetNamePainter = TextPainter(
        text: planetName,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      planetNamePainter.layout();
      planetNamePainter.paint(
        canvas,
        Offset(
          planetPosition.dx - planetNamePainter.width / 2,
          planetPosition.dy - planetNamePainter.height / 2,
        ),
      );
      TextSpan infoName = TextSpan(
        text: 'Year equivalent\nDay equivalent\nDay of year',
        style: infoStyle,
      );
      TextPainter infoPainter = TextPainter(
        text: infoName,
        textAlign: TextAlign.right,
        textDirection: TextDirection.ltr,
      );
      infoPainter.layout();
      infoPainter.paint(canvas, Offset(size.width - 225, size.height - 50));

      TextSpan infoNumbers = TextSpan(
        text:
            '${settings["animationDuration"]}\n' +
            '${(settings["animationDuration"] / totalDaysInYear).toStringAsPrecision(5)}\n' +
            // '${(orbitalValue * settings["animationDuration"] / totalDaysInYear).toStringAsPrecision(5)}',
            '${(orbitalValue * totalDaysInYear).toStringAsPrecision(5)}',
        style: infoStyle,
      );
      infoPainter = TextPainter(
        text: infoNumbers,
        textAlign: TextAlign.right,
        textDirection: TextDirection.ltr,
      );
      infoPainter.layout();
      infoPainter.paint(canvas, Offset(size.width - 150, size.height - 50));

      infoName = TextSpan(
        text:
            'millseconds = Earth year\nmilliseconds an Earth day \nEarth day of year',
        style: infoStyle,
      );
      infoPainter = TextPainter(
        text: infoName,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      infoPainter.layout();
      infoPainter.paint(canvas, Offset(size.width - 100, size.height - 50));
    }
  }

  @override
  bool shouldRepaint(covariant SolarSystemPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
