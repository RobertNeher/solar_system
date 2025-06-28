import 'dart:math';
import 'package:flutter/material.dart';
import 'package:solar_system/src/helper.dart';
import 'package:solar_system/src/star_painter.dart';

class StellarBackground extends StatelessWidget {
  final double windowSize;
  final Map<String, dynamic> settings;

  StellarBackground({
    super.key,
    required this.windowSize,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: windowSize,
      height: windowSize,
      color: Colors.transparent,
      child: Stack(children: generateStars()),
    );
  }

  List<Widget> generateStars() {
    List<Widget> starsInSpace = <Widget>[];
    if (settings['maxStars'] <= 0 || settings['starBackground'] == false) {
      return starsInSpace;
    }
    if (settings['starSize'] <= 0) {
      settings['starSize'] = 5; // Default star size
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
}
