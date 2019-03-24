import 'dart:math' as math;
import 'package:flutter/material.dart';

class BallCompassPainter extends CustomPainter{
  final double angleToBall;
  static const double RECT_WIDTH = 3.0;
  static const double RECT_HEIGHT = 45.0;

  BallCompassPainter(this.angleToBall);

  Paint fillPaint = Paint()
    ..color = Colors.red[500]
    ..strokeWidth = 2.0
    ..style =PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size){
    double radius = size.width/2;

    canvas.translate(radius, radius);
    canvas.rotate((math.pi * angleToBall) / 180.0);

    final Rect rect = Rect.fromPoints(Offset(-RECT_WIDTH/2, -radius-10), Offset(RECT_WIDTH/2, -radius+RECT_HEIGHT));

    canvas.drawRect(rect, fillPaint);
    canvas.restore();
    canvas.save();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}