import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solar_system/src/helper.dart';
import 'package:solar_system/src/solar_system_painter.dart';

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
  String title = '';
  List<Map<String, dynamic>> planets = [];
  Map<String, dynamic> settings = {};

  SolarSystemPage({super.key, required this.title});

  @override
  State<SolarSystemPage> createState() => _SolarSystemPageState();
}

class _SolarSystemPageState extends State<SolarSystemPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Future<void> _loadSettings() async {
    String pathPrefix = '';
    if (kIsWeb) {
      pathPrefix = '';
    } else {
      pathPrefix = 'assets/';
    }

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

  @override
  void dispose() {
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
