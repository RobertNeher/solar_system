import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late SharedPreferences prefs;
  late String language = '';
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
    widget.prefs = await SharedPreferences.getInstance();
    widget.language = widget.prefs.getString('language') ?? 'de';

    String jsonData = await rootBundle.loadString('settings/settings.json');
    widget.settings = json.decode(jsonData)['settings'];

    jsonData = await rootBundle.loadString('settings/planets.json');
    widget.planets = json.decode(jsonData)['planets'];
    print(widget.planets);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      await widget.prefs.setString('language', widget.language);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder<void>(
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
          return Scaffold(
            backgroundColor:
                Colors.black, // Schwarzer Hintergrund für den Weltraum
            appBar: AppBar(
              title: const Text('Platzhalter'),
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
    return Container();
  }
}

// CustomPainter zum Zeichnen des Sonnensystems.
class SolarSystemPainter extends CustomPainter {
  final double
  animationValue; // Der aktuelle Wert des Animationscontrollers (0.0 bis 1.0)
  final List<Map<String, dynamic>> planets; // Liste der Planeten zum Zeichnen

  SolarSystemPainter(this.animationValue, this.planets);

  @override
  void paint(Canvas canvas, Size size) {
    // Der Mittelpunkt des Bildschirms ist der Ort der Sonne.
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Zeichne die Sonne.
    final sunPaint = Paint()..color = Colors.yellow;
    canvas.drawCircle(
      center,
      30.0,
      sunPaint,
    ); // Die Sonne ist ein großer gelber Kreis

    // Zeichne jeden Planeten und seine Umlaufbahn.
    for (var planet in planets) {
      final double orbitalRadius = planet['orbitalRadius'];
      final Color planetColor = planet['color'];
      final double planetRadius = planet['radius'];
      final double speed = planet['speed'];

      // Zeichne die Umlaufbahn.
      final orbitPaint = Paint()
        ..color = Colors
            .white12 // Dezente weiße Linie
        ..style = PaintingStyle
            .stroke // Nur der Umriss
        ..strokeWidth = 0.5; // Dünne Linie
      canvas.drawCircle(center, orbitalRadius, orbitPaint);

      // Berechne den aktuellen Winkel des Planeten basierend auf der Animation und Geschwindigkeit.
      // 2 * math.pi ist ein voller Kreis in Radiant.
      final double angle =
          (animationValue * speed * 2 * math.pi) % (2 * math.pi);

      // Berechne die Position des Planeten auf seiner Umlaufbahn.
      final double planetX = center.dx + orbitalRadius * math.cos(angle);
      final double planetY = center.dy + orbitalRadius * math.sin(angle);
      final Offset planetPosition = Offset(planetX, planetY);

      // Zeichne den Planeten.
      final planetPaint = Paint()..color = planetColor;
      canvas.drawCircle(planetPosition, planetRadius, planetPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SolarSystemPainter oldDelegate) {
    // Neuzeichnen, wenn sich der Animationswert ändert.
    return oldDelegate.animationValue != animationValue;
  }
}
