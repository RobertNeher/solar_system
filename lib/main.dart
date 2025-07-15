import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solar_system/src/central_star.dart';
import 'package:solar_system/src/helper.dart';
import 'package:solar_system/src/solar_system_painter.dart';
import 'package:solar_system/src/stellar_background.dart';

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
        primarySwatch: getMaterialColor(Colors.white),
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
    with TickerProviderStateMixin {
  int tickCounter = 0;
  double orbitValue = 0;
  late AnimationController _controller;
  late List<Set> _planetAnimations;
  int round = 0;

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
    orbitValue = 0;
    _planetAnimations = [];

    for (Map<String, dynamic> planet in widget.planets) {
      _planetAnimations.add({
        planet,
        Tween<double>(
          begin: 0,
          end: 365,
          // begin: 0,
          // end: 2 * math.pi,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear)),
      });
      if (planet['moons'] != null) {
        for (Map<String, dynamic> moon in planet['moons']) {
          _planetAnimations.add({
            moon,
            Tween<double>(begin: 0, end: 2 * math.pi).animate(
              CurvedAnimation(parent: _controller, curve: Curves.linear),
            ),
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _planetAnimations.clear();
    super.dispose();
  }

  void _update() {
    // if (_controller.status == AnimationStatus.completed) {
    //   print('Animation completed');
    // }
    if (_controller.status == AnimationStatus.forward) {
      if (_controller.value <= _controller.upperBound) {
        orbitValue +=
            ((_controller.upperBound - _controller.lowerBound) /
            widget.settings['animationDuration']);
      } else {
        tickCounter = 0;
        // orbitValue = 0;
        _controller.reset();
      }
      tickCounter++;
      // orbitValue +=
      //     ((_controller.upperBound - _controller.lowerBound) /
      //     widget.settings['animationDuration']);
    }
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
          widget.title = widget.settings['title'];

          _controller =
              AnimationController(
                  duration: Duration(
                    milliseconds: widget.settings['animationDuration'],
                  ),
                  vsync: this,
                )
                ..repeat(reverse: false)
                ..addListener(_update);

          return Scaffold(
            backgroundColor: colorFromString(
              widget.settings['spaceBackgroundColor'],
            ),
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                widget.title,
                style: TextStyle(
                  fontFamily: widget.settings['font'],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: complimentaryColor(
                    colorFromString(widget.settings['spaceBackgroundColor']),
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Stack(
              alignment: Alignment.center,
              children: [
                StellarBackground(
                  windowSize: MediaQuery.of(context).size.height,
                  settings: widget.settings['stellarBackground'],
                ),
                CentralStar(settings: widget.settings['centralStar']),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: SolarSystemPainter(
                        _controller.value,
                        orbitValue,
                        widget.settings,
                        widget.planets,
                        _planetAnimations,
                        tickCounter,
                      ),
                      child: Container(),
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text(
              'Something went wrong!',
              style: TextStyle(
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
