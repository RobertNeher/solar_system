import 'dart:core';

import 'package:flutter/material.dart';
import 'package:solar_system/src/helper.dart';

void addInfo(
  Canvas canvas,
  Size size,
  double orbitalValue,
  Map<String, dynamic> settings,
) {
  final TextStyle infoStyle = TextStyle(
    fontFamily: settings['infoBox']['font'],
    color: colorFromString(settings['infoBox']['fontColor']),
    fontSize: settings['infoBox']['fontSize'].toDouble(),
  );
  final double totalDaysInYear = DateTime(
    DateTime.now().year,
    12,
    31,
  ).difference(DateTime(DateTime.now().year, 1, 1)).inDays.toDouble();

  TextSpan infoName = TextSpan(
    text: 'Year equivalent\nDay equivalent\nDay of year',
    style: infoStyle,
  );
  TextPainter infoPainter = TextPainter(
    text: infoName,
    textAlign: TextAlign.right,
    textDirection: TextDirection.ltr,
  );
  infoPainter.layout();
  infoPainter.paint(canvas, Offset(size.width - 245, size.height - 50));

  TextSpan infoNumbers = TextSpan(
    text:
        '${settings["animationDuration"]}\n' +
        '${(settings["animationDuration"] / totalDaysInYear).toStringAsPrecision(5)}\n' +
        // '${(orbitalValue * settings["animationDuration"] / totalDaysInYear).toStringAsPrecision(5)}',
        '${(orbitalValue * totalDaysInYear).toStringAsPrecision(5)}',
    style: infoStyle,
  );
  infoPainter = TextPainter(
    text: infoNumbers,
    textAlign: TextAlign.right,
    textDirection: TextDirection.ltr,
  );
  infoPainter.layout();
  infoPainter.paint(canvas, Offset(size.width - 160, size.height - 50));

  infoName = TextSpan(
    text:
        'millseconds = Earth year\nmilliseconds an Earth day \nEarth day of year',
    style: infoStyle,
  );
  infoPainter = TextPainter(
    text: infoName,
    textAlign: TextAlign.left,
    textDirection: TextDirection.ltr,
  );
  infoPainter.layout();
  infoPainter.paint(canvas, Offset(size.width - 120, size.height - 50));
}

class InfoBox extends StatelessWidget {
  final double yearEquivalent;
  final double dayEquivalent;
  final Map<String, dynamic> settings;

  const InfoBox({
    super.key,
    required this.yearEquivalent,
    required this.dayEquivalent,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    print(this.dayEquivalent);
    final double barWidth =
        settings['width'] > MediaQuery.of(context).size.width
        ? MediaQuery.of(context).size.width
        : settings['width'];

    final TextStyle cellStyle = TextStyle(
      fontFamily: settings['font'],
      fontSize: settings['fontSize'].toDouble(),
      color: colorFromString(settings['fontColor']),
    );

    final double totalDaysInYear = DateTime(
      DateTime.now().year,
      12,
      31,
    ).difference(DateTime(DateTime.now().year, 1, 1)).inDays.toDouble();
    print(totalDaysInYear);

    return Container(
      color: colorFromString(settings['color']),
      width: barWidth,
      height: settings['height'].toDouble(),
      child: Table(
        // border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: FixedColumnWidth(60),
          2: FixedColumnWidth(60),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,

        children: <TableRow>[
          TableRow(
            children: <Widget>[
              TableCell(
                child: Text(
                  'Year equivalent',
                  style: cellStyle,
                  textAlign: TextAlign.left,
                ),
              ),
              TableCell(
                child: Text(
                  yearEquivalent.toStringAsPrecision(4),
                  style: cellStyle,
                  textAlign: TextAlign.right,
                ),
              ),
              TableCell(
                child: Text(
                  'milli seconds per year',
                  style: cellStyle,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              TableCell(
                child: Text(
                  'Day equivalent',
                  style: cellStyle,
                  textAlign: TextAlign.left,
                ),
              ),
              TableCell(
                child: Text(
                  (yearEquivalent / totalDaysInYear).toStringAsPrecision(7),
                  style: cellStyle,
                ),
              ),
              TableCell(
                child: Text(
                  'milli seconds per day',
                  style: cellStyle,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          TableRow(
            // decoration: const BoxDecoration(color: Colors.grey),
            children: <Widget>[
              TableCell(
                child: Text(
                  'Day of year',
                  style: cellStyle,
                  textAlign: TextAlign.left,
                ),
              ),
              TableCell(
                child: Text(
                  (yearEquivalent / totalDaysInYear * dayEquivalent)
                      .toStringAsPrecision(7),
                  style: cellStyle,
                  textAlign: TextAlign.right,
                ),
              ),
              TableCell(child: Container()),
            ],
          ),
        ],
      ),
    );
  }
}
