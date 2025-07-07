import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final Canvas canvas;
  final Size size;
  final TextStyle textStyle;
  final Offset offset;
  final List<List<String>> data;
  int padding;

  InfoBox({
    super.key,
    required this.canvas,
    required this.size,
    required this.textStyle,
    required this.offset,
    required this.data,
    this.padding = 5,
  });

  TextPainter getTextPainter(String text) {
    TextSpan textSpan = TextSpan(text: text, style: this.textStyle);
    TextPainter textPaint = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPaint.layout();
    return textPaint;
  }

  Paint linePaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 1.0;

  @override
  Widget build(BuildContext context) {
    TextPainter textPainter = getTextPainter('Info Box');
    Offset baseOffset = this.offset;

    baseOffset = Offset(
      baseOffset.dx + this.padding,
      baseOffset.dy + this.padding,
    );

    return CustomPaint(
      size: size,
      painter: infoBoxPainter(data, baseOffset, textPainter, linePaint, padding),
    );
  }
}

CustomPainter infoBoxPainter(List<List<String>> data, Offset baseOffset, TextPainter textPainter, Paint linePaint, int padding) {
  return CustomPainter(
    for (List<String> row in data) {
      for (String item in row) {
        TextPainter textPainter = getTextPainter(item);
        textPainter.paint(canvas, baseOffset);
        // Line below the text
        canvas.drawLine(
          Offset(
            baseOffset.dx - this.padding,
            baseOffset.dy + textPainter.height + this.padding,
          ),
          Offset(
            baseOffset.dx + textPainter.width + this.padding,
            baseOffset.dy + textPainter.height + this.padding,
          ),
          linePaint,
        );
        // Line to the right of the text
        canvas.drawLine(
          Offset(
            baseOffset.dx + textPainter.width + this.padding,
            baseOffset.dy,
          ),
          Offset(
            baseOffset.dx + textPainter.width + this.padding,
            baseOffset.dy + textPainter.height + this.padding,
          ),
          linePaint,
        );
        baseOffset = Offset(
          baseOffset.dx + textPainter.width + this.padding,
          baseOffset.dy,
        );
      }
      baseOffset = Offset(
        baseOffset.dx,
        baseOffset.dy + textPainter.height + this.padding,
      ); // Add space between rows
    }

    CustomPaint customPaint = CustomPaint(
      size: size,
      painter: TextPainter(
        text: TextSpan(
          text: 'Hello',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        textDirection: TextDirection.ltr,
      ),
    );
    return Center(
      child: Text(
        data.length.toString(),
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
