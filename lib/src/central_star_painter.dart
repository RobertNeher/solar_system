import 'package:flutter/material.dart';
import 'package:solar_system/src/helper.dart';

class CentralStarPainter extends CustomPainter {
  Map<String, dynamic> settings;

  CentralStarPainter({required this.settings});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final TextStyle sunNameStyle = TextStyle(
      fontFamily: settings['font'],
      color: colorFromString(settings['fontColor']),
      fontSize: settings['fontSize'].toDouble(),
    );
    final centralStarPaint = Paint()
      ..color = colorFromString(settings['color']);

    canvas.drawCircle(center, settings['radius'].toDouble(), centralStarPaint);

    TextSpan centralStarName = TextSpan(
      text: settings['name'],
      style: sunNameStyle,
    );
    TextPainter planetNamePainter = TextPainter(
      text: centralStarName,
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
