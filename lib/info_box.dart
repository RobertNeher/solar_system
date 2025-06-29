import 'dart:core';

import 'package:flutter/material.dart';
import 'package:solar_system/src/helper.dart';

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
                  yearEquivalent.toString(),
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
