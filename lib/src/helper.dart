import 'dart:math';
import 'package:flutter/material.dart';

// colorString is expected in following format:
// '#<red in hex><green in hex><blue in hex>', eg. '#262626'
Color colorFromString(String colorString) {
  String color = '0x${colorString.substring(1)}';
  return Color(int.parse(color));
}

Color complimentaryColor(Color color) {
  return Color.fromARGB(
    255 - color.a.round(),
    255 - color.r.round(),
    255 - color.b.round(),
    255 - color.g.round(),
  );
}

Color randomColor() {
  return Color.fromARGB(
    255,
    Random().nextInt(256),
    Random().nextInt(256),
    Random().nextInt(256),
  );
}
