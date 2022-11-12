import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphics/Library/Widgets/Inherited/provider.dart';
import 'package:graphics/ui/widgets/labs/lab3/lab3_model.dart';
import 'package:graphics/ui/widgets/labs/lab3/points.dart';

class CustomPaintObject extends CustomPainter {
  late List<List<Point>> matrix;
  List<Point> points = [];
  final BuildContext context;

  CustomPaintObject(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    matrix = List.generate((size.height + 1).toInt() + 300,
        (index) => List.filled((size.width + 1).toInt() + 300, Point.zero));

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
    if (point.dz > matrix[y + 150][x + 150].dz) {
      matrix[y + 150][x + 150] = point;
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
      if (point.dz > matrix[y + 150][x + 150].dz) {
        matrix[y + 150][x + 150] = point;
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
    const xMin = -40.0;
    const xMax = 40.0;
    const width = 300;
    return (x - xMin) * width / (xMax - xMin);
  }

  double _toScreenY(double y) {
    const yMin = -40.0;
    const yMax = 40.0;
    const height = 300;
    return (height - (y - yMin) * height / (yMax - yMin));
  }

  void _drawElements() {
    _drawElement(Colors.black, Points.wheels());
    _drawElement(Colors.blue, Points.body());
    _drawElement(Colors.blue, Points.front);
    _drawElement(Colors.black, Points.frontBumper);
  }

  void _drawElement(Color color, List<List<List<double>>> list) {
    final model = NotifierProvider.watch<Lab3Model>(context);
    if (model == null) return;

    final matrixRotationX = model.getMatrixRotationX();
    final matrixRotationY = model.getMatrixRotationY();
    final matrixRotationZ = model.getMatrixRotationZ();
    final matrixScale = model.getMatrixScale();
    final matrixMoving = model.getMatrixMoving();

    for (int i = 0; i < list.length; i++) {
      double x1 = list[i][0][0];
      double y1 = list[i][0][1];
      double z1 = list[i][0][2];
      double x2 = list[i][1][0];
      double y2 = list[i][1][1];
      double z2 = list[i][1][2];
      double x3 = list[i][2][0];
      double y3 = list[i][2][1];
      double z3 = list[i][2][2];
      double c = 50;

      List<double> vector1 = [x1, y1, z1, 1];
      vector1 = multipleMatrix(matrixRotationZ, vector1);
      vector1 = multipleMatrix(matrixRotationX, vector1);
      vector1 = multipleMatrix(matrixRotationY, vector1);
      vector1 = multipleMatrix(matrixScale, vector1);
      vector1 = multipleMatrix(matrixMoving, vector1);
      x1 = vector1[0] / (1 - vector1[2] / c);
      y1 = vector1[1] / (1 - vector1[2] / c);
      z1 = vector1[2] / (1 - vector1[2] / c);

      List<double> vector2 = [x2, y2, z2, 1];
      vector2 = multipleMatrix(matrixRotationZ, vector2);
      vector2 = multipleMatrix(matrixRotationX, vector2);
      vector2 = multipleMatrix(matrixRotationY, vector2);
      vector2 = multipleMatrix(matrixScale, vector2);
      vector2 = multipleMatrix(matrixMoving, vector2);
      x2 = vector2[0] / (1 - vector2[2] / c);
      y2 = vector2[1] / (1 - vector2[2] / c);
      z2 = vector2[2] / (1 - vector2[2] / c);

      List<double> vector3 = [x3, y3, z3, 1];
      vector3 = multipleMatrix(matrixRotationZ, vector3);
      vector3 = multipleMatrix(matrixRotationX, vector3);
      vector3 = multipleMatrix(matrixRotationY, vector3);
      vector3 = multipleMatrix(matrixScale, vector3);
      vector3 = multipleMatrix(matrixMoving, vector3);
      x3 = vector3[0] / (1 - vector3[2] / c);
      y3 = vector3[1] / (1 - vector3[2] / c);
      z3 = vector3[2] / (1 - vector3[2] / c);

      final polygon = Polygon(
        [_toScreenX(x1), _toScreenY(y1), z1],
        [_toScreenX(x2), _toScreenY(y2), z2],
        [_toScreenX(x3), _toScreenY(y3), z3],
        color,
      );
      _drawPolygon(
          [polygon.first, polygon.second, polygon.third, polygon.first]);
    }
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

  static const Point zero = Point(0, 0, -100, Colors.white);

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
