import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

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
    drawPolygon(points);
    points.clear();

    // draw inline border
    if (innerPointsList != null) {
      moveToStart(Offset(w * innerPointsList![0].dx, h * innerPointsList![0].dy));
      for (int i = 1; i < innerPointsList!.length; i++) {
        points.add(Offset(w * innerPointsList![i].dx, h * innerPointsList![i].dy));
      }
      drawPolygon(points);
      points.clear();
    }

    // color fill
    colorFill(Offset(startColorFill.dx * w, startColorFill.dy * h));

    // showing
    canvas.drawPoints(PointMode.points, _pouring, paintFill);
    canvas.drawPoints(PointMode.points, _points, paintBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void colorFill(Offset start) {
    final stack = Queue<Offset>();
    stack.addLast(start);

    while (stack.isNotEmpty) {
      final p = stack.last;
      stack.removeLast();
      _matrix[p.dx.toInt()][p.dy.toInt()] = 1;

      final pLeft = Offset(p.dx - 1, p.dy);
      final pRight = Offset(p.dx + 1, p.dy);
      final pTop = Offset(p.dx, p.dy - 1);
      final pBottom = Offset(p.dx, p.dy + 1);
      if (checkBorder(pLeft)) {
        stack.addLast(pLeft);
      } else {
        _pouring.add(pLeft);
      }
      if (checkBorder(pRight)) {
        stack.addLast(pRight);
      } else {
        _pouring.add(pRight);
      }
      if (checkBorder(pTop)) {
        stack.addLast(pTop);
      } else {
        _pouring.add(pTop);
      }
      if (checkBorder(pBottom)) {
        stack.addLast(pBottom);
      } else {
        _pouring.add(pBottom);
      }
      _pouring.add(Offset(p.dx, p.dy));
    }
  }

  bool checkBorder(Offset point) {
    int element = _matrix[point.dx.toInt()][point.dy.toInt()];
    if (element == 0) {
      return true;
    } else {
      return false;
    }
  }

  void drawLine(Offset start, Offset end) {
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

    dx = module(dx);
    dy = module(dy);

    d = dx > dy ? dx : dy;

    int x = x1;
    int y = y1;
    _points.add(Offset(x.toDouble(), y.toDouble()));
    _matrix[x][y] = -1;

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

      _points.add(Offset(x.toDouble(), y.toDouble()));
      _matrix[x][y] = -1;
    }
  }

  void moveToStart(Offset pos) {
    _start = pos;
  }

  void drawPolygon(List<Offset> points) {
    Offset p1, p2, p3;

    Offset startP = margin(points[0], _start);
    Offset start = startP;
    Offset end;
    for (int i = 0; i < points.length; i++) {
      end = margin(start, points[i]);
      p1 = end;
      p2 = Offset(points[i].dx, points[i].dy);
      if (i < points.length - 1) {
        p3 = margin(points[i + 1], points[i]);
      } else {
        p3 = margin(_start, points[i]);
      }
      drawBezier(p1, p2, p3);

      drawLine(start, end);
      start = p3;
    }

    end = margin(points[points.length - 1], _start);
    p1 = end;
    p2 = _start;
    p3 = startP;
    drawBezier(p1, p2, p3);
    drawLine(start, end);
  }

  Offset margin(Offset start, Offset end) {
    double k = 0.2;

    return Offset(
        end.dx + k * (start.dx - end.dx), end.dy + k * (start.dy - end.dy));
  }

  void drawBezier(Offset p1, Offset p2, Offset p3) {
    double t = 0;
    int x, y;
    int x0 = p1.dx.toInt();
    int y0 = p1.dy.toInt();
    double step = max(max(p1.dx, p3.dx) - min(p1.dx, p3.dx),
        max(p1.dy, p3.dy) - min(p1.dy, p3.dy));
    step = 2 / step;

    for (; t <= 1; t += step) {
      x = ((1 - t) * (1 - t) * p1.dx + 2 * (1 - t) * t * p2.dx + t * t * p3.dx)
          .toInt();
      y = ((1 - t) * (1 - t) * p1.dy + 2 * (1 - t) * t * p2.dy + t * t * p3.dy)
          .toInt();

      // _points.add(Offset(x, y));
      drawLine(Offset(x0.toDouble(), y0.toDouble()),
          Offset(x.toDouble(), y.toDouble()));
      x0 = x;
      y0 = y;
    }

    int xL = p3.dx.toInt();
    int yL = p3.dy.toInt();
    drawLine(Offset(x0.toDouble(), y0.toDouble()),
        Offset(xL.toDouble(), yL.toDouble()));
  }

  int module(int value) {
    return value < 0 ? value * -1 : value;
  }
}
