import 'dart:ui';

import 'package:flutter/material.dart';

class MyCustomPainter extends CustomPainter {
  List<Offset> points2D = [];
  double distance;

  MyCustomPainter({
    required this.distance,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintFace = Paint()
      ..color = Colors.red
      ..strokeWidth = 3;
    final paintSide = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;
    final paintBack = Paint()
      ..color = Colors.black12
      ..strokeWidth = 2;

    const double front = 6;
    const double back = 1;
    final points3D = [
      Point(-10, 1, front),
      Point(-10, 0.5, front),
      Point(-10, -0.5, front),
      Point(-10, -1.5, front),
      Point(-10, -2, front),
      Point(-9, 1.5, front),
      Point(-9, -0.5, front),
      Point(-9, -1.5, front),
      Point(-8.5, 0.5, front),
      Point(-8, 2, front),
      Point(-8, -1, front),
      Point(-8, -2, front),
      Point(-7.5, 1.5, front),
      Point(-7, 0, front),
      Point(-7, -3, front),
      Point(-6, 0, front),
      Point(-6, -3, front),
      Point(-5.5, 1, front),
      Point(-5, 0, front),
      Point(-5, -1, front),
      Point(-5, -2, front),
      Point(-4, 2, front),
      Point(-4, 1, front),
      Point(-3, 2, front),
      Point(-3, -1.5, front),
      Point(-2.5, 2.5, front),
      Point(-2.5, 2, front),
      Point(-1.5, 2.5, front),
      Point(-1.5, 2, front),
      Point(-1, 4, front),
      Point(-0.5, 3.5, front),
      Point(1, 2, front),
      Point(1, -1.5, front),
      Point(2, 4, front),
      Point(2, 3.5, front),
      Point(4, -1.5, front),
      Point(5, -1, front),
      Point(5, -2, front),
      Point(6, 2, front),
      Point(6, 0, front),
      Point(6, -3, front),
      Point(6.5, 2.5, front),
      Point(7, 3, front),
      Point(7, 0, front),
      Point(7, -3, front),
      Point(8, -1, front),
      Point(8, -2, front),
      Point(8.5, 0, front),
      Point(9, 2, front),
      Point(9, 1, front),
      Point(10, 2, front),
      Point(10, 1, front),
      Point(10, 0, front),
      Point(10, -2, front),

      Point(-10, 1, back),
      Point(-10, 0.5, back),
      Point(-10, -0.5, back),
      Point(-10, -1.5, back),
      Point(-10, -2, back),
      Point(-9, 1.5, back),
      Point(-9, -0.5, back),
      Point(-9, -1.5, back),
      Point(-8.5, 0.5, back),
      Point(-8, 2, back),
      Point(-8, -1, back),
      Point(-8, -2, back),
      Point(-7.5, 1.5, back),
      Point(-7, 0, back),
      Point(-7, -3, back),
      Point(-6, 0, back),
      Point(-6, -3, back),
      Point(-5.5, 1, back),
      Point(-5, 0, back),
      Point(-5, -1, back),
      Point(-5, -2, back),
      Point(-4, 2, back),
      Point(-4, 1, back),
      Point(-3, 2, back),
      Point(-3, -1.5, back),
      Point(-2.5, 2.5, back),
      Point(-2.5, 2, back),
      Point(-1.5, 2.5, back),
      Point(-1.5, 2, back),
      Point(-1, 4, back),
      Point(-0.5, 3.5, back),
      Point(1, 2, back),
      Point(1, -1.5, back),
      Point(2, 4, back),
      Point(2, 3.5, back),
      Point(4, -1.5, back),
      Point(5, -1, back),
      Point(5, -2, back),
      Point(6, 2, back),
      Point(6, 0, back),
      Point(6, -3, back),
      Point(6.5, 2.5, back),
      Point(7, 3, back),
      Point(7, 0, back),
      Point(7, -3, back),
      Point(8, -1, back),
      Point(8, -2, back),
      Point(8.5, 0, back),
      Point(9, 2, back),
      Point(9, 1, back),
      Point(10, 2, back),
      Point(10, 1, back),
      Point(10, 0, back),
      Point(10, -2, back),
    ];

    double c = 10 * distance;
    for (int i = 0; i < points3D.length; i++) {
      double x = points3D[i].dx / (1 - points3D[i].dz / c);
      double y = points3D[i].dy / (1 - points3D[i].dz / c);
      points2D.add(Offset(toScreenX(x), toScreenY(y)));
    }

    List<int> indexes = [];
    //
    indexes.addAll(
      [0, 4, 11, 14, 16, 20, 37, 40, 44, 46, 53, 50, 48, 42, 33, 29, 21, 9, 0],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    //
    indexes.addAll(
      [5, 12, 8, 1],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    //
    indexes.addAll(
      [51, 49, 47, 52],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    //
    indexes.addAll(
      [2, 6, 7, 3],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    //
    indexes.addAll(
      [11, 10, 13, 15, 19, 20],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    //
    indexes.addAll(
      [37, 36, 39, 43, 45, 46],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    //
    indexes.addAll(
      [17, 18, 22, 17],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    //
    indexes.addAll(
      [23, 30, 34, 41, 38, 23, 31, 34],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    //
    indexes.addAll(
      [23, 24, 35, 38, 31, 32],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    //
    indexes.addAll(
      [25, 26, 28, 27, 25],
    );
    paintLines(indexes, canvas, paintSide, paintBack);

    indexes.addAll(
      [0, 4, 11, 14, 16, 20, 37, 40, 44, 46, 53, 50, 48, 42, 33, 29, 21, 9],
    );
    paintBorderLines(indexes, canvas, paintSide);

    canvas.drawPoints(PointMode.points, points2D, paintFace);
    print(points2D.length);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void paintLines(List<int> indexList, Canvas canvas, Paint paintFront,
      Paint paintBackground) {
    for (int i = 0; i < indexList.length - 1; i++) {
      canvas.drawLine(
          points2D[indexList[i]], points2D[indexList[i + 1]], paintFront);
      canvas.drawLine(points2D[indexList[i] + 54],
          points2D[indexList[i + 1] + 54], paintBackground);
      // canvas.drawLine(
      //     points2D[indexList[i]], points2D[indexList[i] + 54], paintBackground);
    }
    indexList.clear();
  }

  void paintBorderLines(List<int> indexList, Canvas canvas, Paint paint) {
    for (int i = 0; i < indexList.length; i++) {
      canvas.drawLine(
          points2D[indexList[i]], points2D[indexList[i] + 54], paint);
    }
    indexList.clear();
  }

  double toScreenX(double x) {
    const xMin = -12.0;
    const xMax = 12.0;
    return (x - xMin) * 300 / (xMax - xMin) + 0;
  }

  double toScreenY(double y) {
    const yMin = -12.0;
    const yMax = 12.0;
    return (300 - (y - yMin) * 300 / (yMax - yMin));
  }
}

class Point {
  final double _dx;
  final double _dy;
  final double _dz;

  Point(double dx, double dy, double dz)
      : _dx = dx,
        _dy = dy,
        _dz = dz;

  double get dx => _dx;

  double get dy => _dy;

  double get dz => _dz;
}
