import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphics/ui/elements/formulas.dart';

class CustomSymbolPainter extends CustomPainter {
  final Color color;
  final List<Offset> outerPointsList;
  final List<Offset>? innerPointsList;
  final Offset startColorFill;
  final List<Offset> _points = [];
  final List<Offset> _pouring = [];
  List<List<int>> _matrix = [];
  Offset _start = const Offset(0, 0);

  CustomSymbolPainter({
    required this.color,
    required this.outerPointsList,
    this.innerPointsList,
    required this.startColorFill,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final formulas = Formulas();
    final paintBorder = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;
    final paintFill = Paint()
      ..color = color
      ..strokeWidth = 1;
    int w = size.width.toInt();
    int h = size.height.toInt();
    List<Offset> points = [];
    _matrix = List.generate(h, (_) => List.filled(w, 0));

    // draw outline border
    moveToStart(Offset(w * outerPointsList[0].dx, h * outerPointsList[0].dy));
    for (int i = 1; i < outerPointsList.length; i++) {
      points.add(Offset(w * outerPointsList[i].dx, h * outerPointsList[i].dy));
    }
    formulas.drawPolygon(_points, _matrix, _start, points, true);
    points.clear();

    // draw inline border
    if (innerPointsList != null) {
      moveToStart(
          Offset(w * innerPointsList![0].dx, h * innerPointsList![0].dy));
      for (int i = 1; i < innerPointsList!.length; i++) {
        points.add(
            Offset(w * innerPointsList![i].dx, h * innerPointsList![i].dy));
      }
      formulas.drawPolygon(_points, _matrix, _start, points, true);
      points.clear();
    }

    // color fill
    formulas.colorFill(
      _matrix,
      _pouring,
      Offset(startColorFill.dx * w, startColorFill.dy * h),
    );

    // showing
    canvas.drawPoints(PointMode.points, _pouring, paintFill);
    canvas.drawPoints(PointMode.points, _points, paintBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void moveToStart(Offset pos) {
    _start = pos;
  }
}
