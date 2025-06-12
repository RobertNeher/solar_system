import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  Map<String, dynamic> settings = json.decode(
    File('assets/settings/settings.json').readAsStringSync(),
  )['settings'];
  Map<String, dynamic> planets = json.decode(
    File('assets/settings/planets.json').readAsStringSync(),
  );
  print(settings);
  print(planets['planets'].length);
}
