import 'dart:math';
import 'package:flutter/material.dart';
import 'package:solar_system/src/helper.dart';
import 'package:solar_system/src/star_painter.dart';

List<Widget> stellarBackground(
  double windowSize,
  Map<String, dynamic> settings,
) {
  List<Widget> starsInSpace = <Widget>[];

  if (!settings['starBackground']) {
    return starsInSpace;
  }

  CustomPaint star = CustomPaint(
    painter: StarPainter(
      starSize: Size(
        settings['starSize'].toDouble(),
        settings['starSize'].toDouble(),
      ),
      starColor: colorFromString(settings['starColor']),
      edges: settings['starEdges'],
    ),
  );

  for (int i = 0; i < settings['maxStars']; i++) {
    Positioned positionedStar = Positioned(
      left: Random().nextDouble() * windowSize,
      top: Random().nextDouble() * windowSize,
      child: star,
    );
    starsInSpace.add(positionedStar);
  }
  return starsInSpace;
}
