import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphics/Library/Widgets/Inherited/provider.dart';
import 'package:graphics/ui/widgets/labs/lab3/lab3_model.dart';

class MyCustomPainter extends CustomPainter {
  final BuildContext context;
  final double height;
  final double width;
  List<Offset> points2D = [];
  double distance;
  late List<List<Color>> matrix;
  double xMin = 100000, xMax = -100000;
  double yMin = 100000, yMax = -100000;

  MyCustomPainter({
    required this.context,
    required this.height,
    required this.width,
    required this.distance,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final model = NotifierProvider.watch<Lab3Model>(context);
    if (model == null) return;

    final paintFace = Paint()
      ..color = Colors.red
      ..strokeWidth = 3;
    final paintSide = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;
    final paintBack = Paint()
      ..color = Colors.black12
      ..strokeWidth = 2;

    const double front = 4;
    const double back = -4;
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
      Point(-1, 4, front - 1),
      Point(-0.5, 3.5, front - 0.75),
      Point(1, 2, front),
      Point(1, -1.5, front),
      Point(2, 4, front - 1),
      Point(2, 3.5, front - 0.75),
      Point(4, -1.5, front),
      Point(5, -1, front),
      Point(5, -2, front),
      Point(6, 2, front),
      Point(6, 0, front),
      Point(6, -3, front),
      Point(6.5, 2.5, front - 0.25),
      Point(7, 3, front - 0.5),
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
      // wheels
      Point(-8, -2, front - 1.5),
      Point(-7, -3, front - 1.5),
      Point(-6, -3, front - 1.5),
      Point(-5, -2, front - 1.5),
      Point(5, -2, front - 1.5),
      Point(6, -3, front - 1.5),
      Point(7, -3, front - 1.5),
      Point(8, -2, front - 1.5),
      // mirrors
      Point(-2.5, 2, front + 1),
      Point(-2.5, 2.5, front + 1),
      Point(-1.5, 2.5, front + 1),
      Point(-1.5, 2, front + 1),
      //
      Point(10, 0, front - 2),
      Point(10, 1, front - 2),
      // -----------------------
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
      Point(-1, 4, back + 1),
      Point(-0.5, 3.5, back + 0.75),
      Point(1, 2, back),
      Point(1, -1.5, back),
      Point(2, 4, back + 1),
      Point(2, 3.5, back + 0.75),
      Point(4, -1.5, back),
      Point(5, -1, back),
      Point(5, -2, back),
      Point(6, 2, back),
      Point(6, 0, back),
      Point(6, -3, back),
      Point(6.5, 2.5, back + 0.25),
      Point(7, 3, back + 0.5),
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
      // wheels
      Point(-8, -2, back + 1.5),
      Point(-7, -3, back + 1.5),
      Point(-6, -3, back + 1.5),
      Point(-5, -2, back + 1.5),
      Point(5, -2, back + 1.5),
      Point(6, -3, back + 1.5),
      Point(7, -3, back + 1.5),
      Point(8, -2, back + 1.5),
      // mirrors
      Point(-2.5, 2, back - 1),
      Point(-2.5, 2.5, back - 1),
      Point(-1.5, 2.5, back - 1),
      Point(-1.5, 2, back - 1),
      //
      Point(10, 0, back + 2),
      Point(10, 1, back + 2),
    ];

    double c = 10 * distance;
    final matrixRotationX = model.getMatrixRotationX();
    final matrixRotationY = model.getMatrixRotationY();
    final matrixRotationZ = model.getMatrixRotationZ();
    final matrixScale = model.getMatrixScale();
    final matrixMoving = model.getMatrixMoving();

    for (int i = 0; i < points3D.length; i++) {
      List<double> vector = [points3D[i].dx, points3D[i].dy, points3D[i].dz, 1];
      vector = multipleMatrix(matrixRotationZ, vector);
      vector = multipleMatrix(matrixRotationX, vector);
      vector = multipleMatrix(matrixRotationY, vector);
      vector = multipleMatrix(matrixScale, vector);
      vector = multipleMatrix(matrixMoving, vector);

      double x = vector[0] / (1 - vector[2] / c);
      double y = vector[1] / (1 - vector[2] / c);

      if (x < xMin) {
        xMin = x;
      } else if (x > xMax) {
        xMax = x;
      }
      if (y < yMin) {
        yMin = y;
      } else if (y > yMax) {
        yMax = y;
      }

      points2D.add(Offset(toScreenX(x), toScreenY(y)));
    }
    double t = yMin;
    yMin = yMax;
    yMax = t;
    xMax = toScreenX(xMax);
    xMin = toScreenX(xMin);
    yMax = toScreenY(yMax);
    yMin = toScreenY(yMin);

    matrix = List.generate(
      (yMax - yMin).toInt(),
      (_) => List.filled(
        (xMax - xMin).toInt(),
        Colors.white,
      ),
    );
    _drawObject(canvas, paintSide, paintBack);

    _drawPolygon([points2D[0], points2D[1]]);

    canvas.drawPoints(PointMode.points, points2D, paintFace);
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10;
    for (int i = 0; i < matrix.length; i++) {
      List<Offset> list = [];
      for (int j = 0; j < matrix[i].length; j++) {
        if (matrix[i][j] == Colors.black) {
          list.add(Offset((i + yMin).toDouble(), (j + xMin).toDouble()));
        }
      }
      canvas.drawPoints(PointMode.points, list, paint);
    }
    // print(points2D.length);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  List<double> multipleMatrix(List<List<double>> matrix, List<double> vector) {
    final newX = matrix[0][0] * vector[0] +
        matrix[0][1] * vector[1] +
        matrix[0][2] * vector[2] +
        matrix[0][3] * vector[3];
    final newY = matrix[1][0] * vector[0] +
        matrix[1][1] * vector[1] +
        matrix[1][2] * vector[2] +
        matrix[1][3] * vector[3];
    final newZ = matrix[2][0] * vector[0] +
        matrix[2][1] * vector[1] +
        matrix[2][2] * vector[2] +
        matrix[2][3] * vector[3];

    return [newX, newY, newZ, 1];
  }

  void paintLines(
    List<int> indexList,
    Canvas canvas,
    Paint paintFront,
    Paint paintBackground,
  ) {
    for (int i = 0; i < indexList.length - 1; i++) {
      canvas.drawLine(
          points2D[indexList[i]], points2D[indexList[i + 1]], paintFront);
      canvas.drawLine(points2D[indexList[i] + points2D.length ~/ 2],
          points2D[indexList[i + 1] + points2D.length ~/ 2], paintFront);
    }
    indexList.clear();
  }

  void _paintBorderLines(List<int> indexList, Canvas canvas, Paint paint) {
    for (int i = 0; i < indexList.length; i++) {
      canvas.drawLine(points2D[indexList[i]],
          points2D[indexList[i] + points2D.length ~/ 2], paint);
    }
    indexList.clear();
  }

  double toScreenX(double x) {
    const xMin = -10.0;
    const xMax = 10.0;
    return (x - xMin) * width / (xMax - xMin) + 0;
  }

  double toScreenY(double y) {
    const yMin = -10.0;
    const yMax = 10.0;
    return (height - (y - yMin) * height / (yMax - yMin));
  }

  void _drawObject(Canvas canvas, Paint paintSide, Paint paintBack) {
    List<int> indexes = [];
    // contour
    indexes.addAll(
      [0, 4, 11, 14, 16, 20, 37, 40, 44, 46, 53, 50, 48, 42, 33, 29, 21, 9, 0],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    // front lights
    indexes.addAll(
      [5, 12, 8, 1],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    // rear lights
    indexes.addAll(
      [51, 49, 47, 52],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    // bumper
    indexes.addAll(
      [2, 6, 7, 3],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    // front wheel
    indexes.addAll(
      [11, 10, 13, 15, 19, 20],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    indexes.addAll(
      [55, 56, 57, 54, 55, 14, 16, 56],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    // rear wheel
    indexes.addAll(
      [37, 36, 39, 43, 45, 46],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    indexes.addAll(
      [59, 60, 61, 58, 59, 40, 44, 60],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    // decor
    indexes.addAll(
      [17, 18, 22, 17],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    // windows
    indexes.addAll(
      [23, 30, 34, 41, 38, 23, 31, 34],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    // doors
    indexes.addAll(
      [23, 24, 35, 38, 31, 32],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    // side mirror
    indexes.addAll(
      [25, 26, 28, 27, 25],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    indexes.addAll(
      [62, 63, 64, 65, 62, 26, 25, 63, 64, 27, 28, 65],
    );
    paintLines(indexes, canvas, paintSide, paintBack);
    //
    indexes.addAll(
      [52, 66, 67, 51],
    );
    paintLines(indexes, canvas, paintSide, paintBack);

    // borders
    indexes.addAll(
      [11, 20, 37, 46, 53, 50, 48, 42, 33, 29, 21, 9],
    );
    _paintBorderLines(indexes, canvas, paintSide);
  }

  void _drawPolygon(List<Offset> points) {
    for (int i = 0; i < points.length - 1; i++) {
      _drawLine(
        points[i],
        points[i + 1],
      );
    }
  }

  void _drawLine(
    Offset start,
    Offset end,
  ) {
    int x1 = start.dx.toInt(), x2 = end.dx.toInt();
    int y1 = start.dy.toInt(), y2 = end.dy.toInt();

    int xErr = 0, yErr = 0;
    int incX = 0, incY = 0;
    int d = 0;
    int dx = x2 - x1;
    int dy = y2 - y1;

    if (dx > 0) {
      incX = 1;
    } else if (dx == 0) {
      incX = 0;
    } else if (dx < 0) {
      incX = -1;
    }

    if (dy > 0) {
      incY = 1;
    } else if (dy == 0) {
      incY = 0;
    } else if (dy < 0) {
      incY = -1;
    }
    // dx = module(dx);
    // dy = module(dy);
    d = dx > dy ? dx : dy;

    int x = x1;
    int y = y1;
    // points.add(Offset(x.toDouble(), y.toDouble()));
    matrix[y - yMin.toInt()][x - xMin.toInt()] = Colors.black;

    for (int i = 0; i < d; i++) {
      xErr += dx;
      yErr += dy;

      if (xErr > d) {
        xErr -= d;
        x += incX;
      }
      if (yErr > d) {
        yErr -= d;
        y += incY;
      }
      // points.add(Offset(x.toDouble(), y.toDouble()));
      matrix[y - yMin.toInt()][x - xMin.toInt()] = Colors.black;
    }
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
