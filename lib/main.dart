import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:solar_system/src/helper.dart';

void main() {
  runApp(const SolarSystemApp());
}

class SolarSystemApp extends StatelessWidget {
  static const String title = 'Solar System Simulation';
  const SolarSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SolarSystemPage(title: title),
    );
  }
}

// ignore: must_be_immutable
class SolarSystemPage extends StatefulWidget {
  // late SharedPreferences prefs;
  // late String language = '';
  String title = '';
  List<Map<String, dynamic>> planets = [];
  Map<String, dynamic> settings = {};

  SolarSystemPage({super.key, required this.title});

  @override
  State<SolarSystemPage> createState() => _SolarSystemPageState();
}

class _SolarSystemPageState extends State<SolarSystemPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;

  Future<void> _loadSettings() async {
    String pathPrefix = '';
    if (kIsWeb) {
      pathPrefix = '';
    } else {
      pathPrefix = 'assets/';
    }
    // widget.prefs = await SharedPreferences.getInstance();
    // widget.language = widget.prefs.getString('language') ?? 'de';
    String jsonData = await rootBundle.loadString(
      '${pathPrefix}settings/settings.json',
    );
    widget.settings = json.decode(jsonData)['settings'];

    jsonData = await rootBundle.loadString(
      '${pathPrefix}settings/planets.json',
    );
    widget.planets = List<Map<String, dynamic>>.from(
      json.decode(jsonData)['planets'],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   if (state == AppLifecycleState.paused) {
  //     await widget.prefs.setString('language', widget.language);
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
              strokeWidth: 5,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          _controller = AnimationController(
            duration: Duration(
              milliseconds: widget.settings['animationDuration'],
            ),
            vsync: this,
          )..repeat();
          widget.title = widget.settings['title'];

          return Scaffold(
            backgroundColor: colorFromString(
              widget.settings['spaceBackgroundColor'],
            ),
            appBar: AppBar(
              title: Text(widget.title),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: SolarSystemPainter(
                      _controller.value,
                      widget.settings,
                      widget.planets,
                    ),
                    child: Container(),
                  );
                },
              ),
            ),
          );
        } else {
          return const Center(
            child: Text(
              'Something went wrong!',
              style: TextStyle(
                // fontFamily: 'Railway',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.red,
              ),
            ),
          );
        }
      },
    );
  }
}

// CustomPainter zum Zeichnen des Sonnensystems.
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
      print(planet);
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
    }
  }

  @override
  bool shouldRepaint(covariant SolarSystemPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
