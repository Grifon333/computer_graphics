import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphics/Library/Widgets/Inherited/provider.dart';
import 'package:graphics/ui/widgets/labs/lab2/lab2_model.dart';

class Lab2Widget extends StatelessWidget {
  const Lab2Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lab2'),
        ),
        body:
            // const Center(
            //     child:
            const Padding(
          padding: EdgeInsets.all(16.0),
          child: _BodyWidget(),
        )
        // ),
        );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<Lab2Model>(context);
    if (model == null) return const SizedBox.shrink();

    double size = MediaQuery.of(context).size.width / 2 - 18;
    return Column(
      children: [
        const _ChangeColorWidget(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _ShowElementWidget(
              size: size,
              painter: _SymbolPainter(color: model.color),
            ),
            _ShowElementWidget(
              size: size,
              painter: _NumberPainter(color: model.color),
            ),
          ],
        ),
      ],
    );
  }
}

class _ShowElementWidget extends StatelessWidget {
  final double size;
  final CustomPainter painter;

  const _ShowElementWidget({
    Key? key,
    required this.size,
    required this.painter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Colors.grey[300]),
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: painter,
        ),
      ),
    );
  }
}

class _ChangeColorWidget extends StatelessWidget {
  const _ChangeColorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<Lab2Model>(context);
    if (model == null) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: ListView.builder(
        itemCount: 7,
        itemExtent: 52,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => model.setColor(model.colors[index]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ColoredBox(
                color: model.colors[index],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SymbolPainter extends CustomPainter {
  final Color color;
  final List<Offset> _points = [];
  final List<Offset> _pouring = [];
  List<List<int>> _matrix = [];
  Offset _start = const Offset(0, 0);

  _SymbolPainter({required this.color});

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
    moveToStart(Offset(w * 0.2, h * 0.1));
    points
      ..add(Offset(w * 0.7, h * 0.2))
      ..add(Offset(w * 0.6, h * 0.7))
      ..add(Offset(w * 0.75, h * 0.7))
      ..add(Offset(w * 0.65, h * 0.9))
      ..add(Offset(w * 0.65, h * 0.8))
      ..add(Offset(w * 0.35, h * 0.8))
      ..add(Offset(w * 0.35, h * 0.9))
      ..add(Offset(w * 0.25, h * 0.7))
      ..add(Offset(w * 0.4, h * 0.7));
    drawPolygon(points);
    points.clear();

    // draw inline border
    moveToStart(Offset(w * 0.4, h * 0.25));
    points
      ..add(Offset(w * 0.55, h * 0.3))
      ..add(Offset(w * 0.5, h * 0.55));
    drawPolygon(points);
    points.clear();

    // color fill
    colorFill(Offset(0.3 * w, 0.3 * h));

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

class _NumberPainter extends CustomPainter {
  final Color color;
  final List<Offset> _points = [];
  final List<Offset> _pouring = [];
  List<List<int>> _matrix = [];

  _NumberPainter({required this.color});

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
    _matrix = List.generate(h, (_) => List.filled(w, 0));

    drawCircle(Offset(0.5 * w, 0.3 * h), 0.2 * w, 0, 0.443 * h);
    drawCircle(Offset(0.5 * w, 0.3 * h), 0.1 * w, 0, h.toDouble());
    drawCircle(Offset(0.5 * w, 0.65 * h), 0.25 * w, 0.443 * h, h.toDouble());
    drawCircle(Offset(0.5 * w, 0.65 * h), 0.15 * w, 0, h.toDouble());

    colorFill(Offset(0.4 * h, 0.4 * h));

    canvas.drawPoints(PointMode.points, _pouring, paintFill);
    canvas.drawPoints(PointMode.points, _points, paintBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void sim(Offset center, int x, int y, double minY, double maxY) {
    int xc = center.dx.toInt(), yc = center.dy.toInt();

    if (y + yc <= maxY) {
      _points.add(Offset((x + xc).toDouble(), (y + yc).toDouble()));
      _points.add(Offset((-x + xc).toDouble(), (y + yc).toDouble()));
      _matrix[x + xc][y + yc] = -1;
      _matrix[-x + xc][y + yc] = -1;
    }
    if (-y + yc >= minY) {
      _points.add(Offset((x + xc).toDouble(), (-y + yc).toDouble()));
      _points.add(Offset((-x + xc).toDouble(), (-y + yc).toDouble()));
      _matrix[x + xc][-y + yc] = -1;
      _matrix[-x + xc][-y + yc] = -1;
    }
    if (x + yc <= maxY) {
      _points.add(Offset((y + xc).toDouble(), (x + yc).toDouble()));
      _points.add(Offset((-y + xc).toDouble(), (x + yc).toDouble()));
      _matrix[y + xc][x + yc] = -1;
      _matrix[-y + xc][x + yc] = -1;
    }
    if (-x + yc >= minY) {
      _points.add(Offset((y + xc).toDouble(), (-x + yc).toDouble()));
      _points.add(Offset((-y + xc).toDouble(), (-x + yc).toDouble()));
      _matrix[y + xc][-x + yc] = -1;
      _matrix[-y + xc][-x + yc] = -1;
    }
  }

  void drawCircle(Offset center, double radius, double minY, double maxY) {
    int y = radius.toInt(), x = 0;
    int d = 3 - 2 * y;
    x = 0;

    while (x <= y) {
      sim(center, x, y, minY, maxY);
      if (d < 0) {
        d = d + 4 * x + 6;
      } else {
        d = d + 4 * (x - y) + 6;
        y--;
      }
      x++;
    }
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
}

class _MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0.2 * size.width, 0.1 * size.height, 0.55 * size.width,
        0.8 * size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}
