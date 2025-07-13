import 'dart:math';
import 'package:flutter/material.dart';
import 'package:solar_system/src/central_star_painter.dart';
import 'package:solar_system/src/helper.dart';
import 'package:solar_system/src/star_painter.dart';

class CentralStar extends StatelessWidget {
  final Map<String, dynamic> settings;

  CentralStar({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(color: Colors.transparent, child: generateCentralStar()),
    );
  }

  Widget generateCentralStar() {
    CustomPaint centralStar = CustomPaint(
      painter: CentralStarPainter(settings: settings),
    );

    return centralStar;
  }
}
