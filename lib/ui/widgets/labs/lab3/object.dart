import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphics/ui/widgets/labs/lab3/points.dart';

class CustomPaintObject extends CustomPainter {
  late List<List<Point>> matrix;
  List<Point> points = [];

  @override
  void paint(Canvas canvas, Size size) {
    matrix = List.generate((size.height + 1).toInt(),
        (index) => List.filled((size.width + 1).toInt(), Point.zero));

    _drawElements();
    _showObject(canvas);
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
    if (point.dz > matrix[y][x].dz) {
      matrix[y][x] = point;
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
      if (point.dz > matrix[y][x].dz) {
        matrix[y][x] = point;
        points.add(point);
      }
      listPoints.add(point);
    }

    return listPoints;
  }

  void _showObject(Canvas canvas) {
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

  void _drawPolygon(List<Point> listPoints) {
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
      } else if (count == 4) {
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

  double _toScreenX(double x) {
    const xMin = -30.0;
    const xMax = 30.0;
    const width = 300;
    return (x - xMin) * width / (xMax - xMin);
  }

  double _toScreenY(double y) {
    const yMin = -30.0;
    const yMax = 30.0;
    const height = 300;
    return (height - (y - yMin) * height / (yMax - yMin));
  }

  void _drawElements() {
    _drawElement(Colors.black, Points.wheels);
    _drawElement(Colors.blue, Points.body);
  }

  void _drawElement(Color color, List<List<List<double>>> list) {
    for (int i = 0; i < list.length; i++) {
      final polygon = Polygon(
        [_toScreenX(list[i][0][0]), _toScreenY(list[i][0][1]), list[i][0][2]],
        [_toScreenX(list[i][1][0]), _toScreenY(list[i][1][1]), list[i][1][2]],
        [_toScreenX(list[i][2][0]), _toScreenY(list[i][2][1]), list[i][2][2]],
        color,
      );
      _drawPolygon(
          [polygon.first, polygon.second, polygon.third, polygon.first]);
    }
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

  double get dx => _dx;

  double get dy => _dy;

  double get dz => _dz;

  Color get color => _color;
}

class Polygon {
  final Point _first;
  final Point _second;
  final Point _third;
  final Color _color;

  Polygon(
    List<double> point1,
    List<double> point2,
    List<double> point3,
    Color color,
  )   : _first = Point(point1[0], point1[1], point1[2], color),
        _second = Point(point2[0], point2[1], point2[2], color),
        _third = Point(point3[0], point3[1], point3[2], color),
        _color = color,
        assert(
          point1.length == 3,
          'Length point1 coordinators of polygon != 3',
        ),
        assert(
          point2.length == 3,
          'Length point2 coordinators of polygon != 3',
        ),
        assert(
          point3.length == 3,
          'Length point3 coordinators of polygon != 3',
        );

  Point get first => _first;

  Point get second => _second;

  Point get third => _third;

  Color get color => _color;
}
