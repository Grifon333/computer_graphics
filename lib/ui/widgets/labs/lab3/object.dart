import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';

class CustomPaintObject extends CustomPainter {
  late List<List<Point>> matrix;
  List<Point> points = [];
  double xMin = 100000, xMax = -100000;
  double yMin = 100000, yMax = -100000;

  @override
  void paint(Canvas canvas, Size size) {
    // final paint = Paint()
    //   ..color = Colors.red
    //   ..strokeWidth = 2;

    xMin = _toScreenX(-10);
    xMax = _toScreenX(10);
    yMin = _toScreenY(-10);
    yMax = _toScreenY(10);
    double t = yMin;
    yMin = yMax;
    yMax = t;

    matrix = List.generate((yMax - yMin + 1).toInt(),
        (index) => List.filled((xMax - xMin + 1).toInt(), Point.zero));

    // _drawLine(
    //   Point(_toScreenX(-10), _toScreenY(-10), 3, Colors.green),
    //   Point(_toScreenX(10), _toScreenY(10), -5, Colors.green),
    // );
    // _drawLine(
    //   Point(_toScreenX(-10), _toScreenY(10), 1, Colors.black),
    //   Point(_toScreenX(10), _toScreenY(-10), 1, Colors.black),
    // );
    _drawPolygon(Colors.blue, [
      Point(_toScreenX(-10), _toScreenY(-10), 3, Colors.blue),
      Point(_toScreenX(8), _toScreenY(10), 3, Colors.blue),
      // Point(_toScreenX(-1), _toScreenY(10), 3, Colors.blue),
      Point(_toScreenX(0), _toScreenY(8), 3, Colors.blue),
      Point(_toScreenX(-10), _toScreenY(-10), 3, Colors.blue),
    ]);

    _drawObject(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  List<Point> _drawLine(
    Point start,
    Point end,
  ) {
    List<Point> listPoints = [];
    int x1 = start.dx.toInt(), x2 = end.dx.toInt();
    int y1 = start.dy.toInt(), y2 = end.dy.toInt();
    int z1 = start.dz.toInt(), z2 = end.dz.toInt();
    Color color = start.color;

    int xErr = 0, yErr = 0, zErr = 0;
    int incX = 0, incY = 0, incZ = 0;
    int d = 0;
    int dx = x2 - x1;
    int dy = y2 - y1;
    int dz = z2 - z1;

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
    if (dz > 0) {
      incZ = 1;
    } else if (dz == 0) {
      incZ = 0;
    } else if (dz < 0) {
      incZ = -1;
    }
    dx = _module(dx);
    dy = _module(dy);
    dz = _module(dz);
    if (dx >= dy && dx >= dz) {
      d = dx;
    } else if (dy >= dx && dy >= dz) {
      d = dy;
    } else {
      d = dz;
    }

    int x = x1;
    int y = y1;
    int z = z1;
    Point point = Point(x.toDouble(), y.toDouble(), z.toDouble(), color);
    if (point.dz > matrix[y - yMin.toInt()][x - xMin.toInt()].dz) {
      matrix[y - yMin.toInt()][x - xMin.toInt()] = point;
      points.add(point);
    }
    listPoints.add(point);

    for (int i = 0; i < d; i++) {
      xErr += dx;
      yErr += dy;
      zErr += dz;
      if (xErr > d) {
        xErr -= d;
        x += incX;
      }
      if (yErr > d) {
        yErr -= d;
        y += incY;
      }
      if (zErr > d) {
        zErr -= d;
        z += incZ;
      }
      point = Point(x.toDouble(), y.toDouble(), z.toDouble(), color);
      if (point.dz > matrix[y - yMin.toInt()][x - xMin.toInt()].dz) {
        matrix[y - yMin.toInt()][x - xMin.toInt()] = point;
        points.add(point);
      }
      listPoints.add(point);
    }

    return listPoints;
  }

  double _toScreenX(double x) {
    const xMin = -10.0;
    const xMax = 10.0;
    const width = 300;
    return (x - xMin) * width / (xMax - xMin) + 0;
  }

  double _toScreenY(double y) {
    const yMin = -10.0;
    const yMax = 10.0;
    const height = 300;
    return (height - (y - yMin) * height / (yMax - yMin));
  }

  void _drawObject(Canvas canvas) {
    for (int i = 0; i < points.length; i++) {
      Paint paint = Paint()
        ..color = points[i].color
        ..strokeWidth = 1;
      canvas.drawPoints(
        PointMode.points,
        [Offset(points[i].dx, points[i].dy)],
        paint,
      );
    }
  }

  int _module(int value) {
    return value < 0 ? value * -1 : value;
  }

  void _drawPolygon(Color color, List<Point> listPoints) {
    Map<double, Set<Point>> mapCoordinates = {};
    for (int i = 0; i < listPoints.length - 1; i++) {
      final list = _drawLine(listPoints[i], listPoints[i + 1]);
      for (int k = 0; k < list.length; k++) {
        if (k > 1 && list[k].dx == list[k - 1].dx) continue;
        Set<Point> l = mapCoordinates[list[k].dx] ?? {};
        l.add(list[k]);
        l = SplayTreeSet.from(l, (a, b) => a.dy.compareTo(b.dy));
        mapCoordinates[list[k].dx] = l;
      }
    }
    for (final item in mapCoordinates.entries) {
      int count = item.value.length;
      if (count == 2 || count == 3) {
        _drawLine(
          item.value.first,
          item.value.last,
        );
      }
      else if (count == 4) {
        _drawLine(
          item.value.elementAt(0),
          item.value.elementAt(1),
        );
        _drawLine(
          item.value.elementAt(2),
          item.value.elementAt(3),
        );
      }
    }

    // for (final item in mapCoordinates.values) {
    //   print('(${item.map((e) => '${e.dx}, ${e.dy}, ${e.dz}').join(';  ')})');
    // }
  }
}

class Point {
  final double _dx;
  final double _dy;
  final double _dz;
  final Color _color;

  const Point(double dx, double dy, double dz, Color color)
      : _dx = dx,
        _dy = dy,
        _dz = dz,
        _color = color;

  static const Point zero = Point(0, 0, 0, Colors.white);

  set color(Color color) => _color;

  double get dx => _dx;

  double get dy => _dy;

  double get dz => _dz;

  Color get color => _color;
}
