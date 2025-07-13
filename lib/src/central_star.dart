import 'package:flutter/material.dart';
import 'package:solar_system/src/central_star_painter.dart';

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
