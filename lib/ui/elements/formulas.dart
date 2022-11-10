import 'dart:collection';
import 'dart:math';
import 'dart:ui';

class Formulas {
  void drawLine(
    List<Offset> _points,
    List<List<int>> _matrix,
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

  void drawPolygon(
    List<Offset> _points,
    List<List<int>> _matrix,
    Offset _start,
    List<Offset> points,
    bool closedLoop,
  ) {
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
      drawBezier(_points, _matrix, p1, p2, p3);

      drawLine(_points, _matrix, start, end);
      start = p3;
    }

    if (closedLoop) {
      end = margin(points[points.length - 1], _start);
      p1 = end;
      p2 = _start;
      p3 = startP;
      drawBezier(_points, _matrix, p1, p2, p3);
      drawLine(_points, _matrix, start, end);
    }
  }

  Offset margin(Offset start, Offset end) {
    double k = 0.2;

    return Offset(
        end.dx + k * (start.dx - end.dx), end.dy + k * (start.dy - end.dy));
  }

  void drawBezier(
    List<Offset> _points,
    List<List<int>> _matrix,
    Offset p1,
    Offset p2,
    Offset p3,
  ) {
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
      drawLine(_points, _matrix, Offset(x0.toDouble(), y0.toDouble()),
          Offset(x.toDouble(), y.toDouble()));
      x0 = x;
      y0 = y;
    }

    int xL = p3.dx.toInt();
    int yL = p3.dy.toInt();
    drawLine(_points, _matrix, Offset(x0.toDouble(), y0.toDouble()),
        Offset(xL.toDouble(), yL.toDouble()));
  }

  void colorFill(
    List<List<int>> _matrix,
    List<Offset> _pouring,
    Offset start,
  ) {
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
      if (checkBorder(_matrix, pLeft)) {
        stack.addLast(pLeft);
      } else {
        _pouring.add(pLeft);
      }
      if (checkBorder(_matrix, pRight)) {
        stack.addLast(pRight);
      } else {
        _pouring.add(pRight);
      }
      if (checkBorder(_matrix, pTop)) {
        stack.addLast(pTop);
      } else {
        _pouring.add(pTop);
      }
      if (checkBorder(_matrix, pBottom)) {
        stack.addLast(pBottom);
      } else {
        _pouring.add(pBottom);
      }
      _pouring.add(Offset(p.dx, p.dy));
    }
  }

  bool checkBorder(
    List<List<int>> _matrix,
    Offset point,
  ) {
    int element = _matrix[point.dx.toInt()][point.dy.toInt()];
    if (element == 0) {
      return true;
    } else {
      return false;
    }
  }

  void sim(
    List<Offset> _points,
    List<List<int>> _matrix,
    Offset center,
    int x,
    int y,
    double minY,
    double maxY,
  ) {
    int xc = center.dx.toInt(), yc = center.dy.toInt();

    if (y + yc < maxY) {
      _points.add(Offset((x + xc).toDouble(), (y + yc).toDouble()));
      _points.add(Offset((-x + xc).toDouble(), (y + yc).toDouble()));
      _matrix[x + xc][y + yc] = -1;
      _matrix[-x + xc][y + yc] = -1;
    }
    if (-y + yc > minY) {
      _points.add(Offset((x + xc).toDouble(), (-y + yc).toDouble()));
      _points.add(Offset((-x + xc).toDouble(), (-y + yc).toDouble()));
      _matrix[x + xc][-y + yc] = -1;
      _matrix[-x + xc][-y + yc] = -1;
    }
    if (x + yc < maxY) {
      _points.add(Offset((y + xc).toDouble(), (x + yc).toDouble()));
      _points.add(Offset((-y + xc).toDouble(), (x + yc).toDouble()));
      _matrix[y + xc][x + yc] = -1;
      _matrix[-y + xc][x + yc] = -1;
    }
    if (-x + yc > minY) {
      _points.add(Offset((y + xc).toDouble(), (-x + yc).toDouble()));
      _points.add(Offset((-y + xc).toDouble(), (-x + yc).toDouble()));
      _matrix[y + xc][-x + yc] = -1;
      _matrix[-y + xc][-x + yc] = -1;
    }
  }

  void simForThree1(
    List<Offset> _points,
    List<List<int>> _matrix,
    Offset center,
    int x,
    int y,
    double minY,
    double maxY,
  ) {
    int xc = center.dx.toInt(), yc = center.dy.toInt();

    if (y + yc < maxY) {
      _points.add(Offset((x + xc).toDouble(), (y + yc).toDouble()));
      _points.add(Offset((-x + xc).toDouble(), (y + yc).toDouble()));
      _matrix[x + xc][y + yc] = -1;
      _matrix[-x + xc][y + yc] = -1;
    }
    if (-y + yc > minY) {
      _points.add(Offset((x + xc).toDouble(), (-y + yc).toDouble()));
      _matrix[x + xc][-y + yc] = -1;
    }
    if (x + yc < maxY) {
      _points.add(Offset((y + xc).toDouble(), (x + yc).toDouble()));
      _points.add(Offset((-y + xc).toDouble(), (x + yc).toDouble()));
      _matrix[y + xc][x + yc] = -1;
      _matrix[-y + xc][x + yc] = -1;
    }
    if (-x + yc > minY) {
      _points.add(Offset((y + xc).toDouble(), (-x + yc).toDouble()));
      _matrix[y + xc][-x + yc] = -1;
    }
  }

  void simForThree2(
    List<Offset> _points,
    List<List<int>> _matrix,
    Offset center,
    int x,
    int y,
    double minY,
    double maxY,
  ) {
    int xc = center.dx.toInt(), yc = center.dy.toInt();

    if (y + yc < maxY) {
      _points.add(Offset((x + xc).toDouble(), (y + yc).toDouble()));
      _matrix[x + xc][y + yc] = -1;
    }
    if (-y + yc > minY) {
      _points.add(Offset((x + xc).toDouble(), (-y + yc).toDouble()));
      _points.add(Offset((-x + xc).toDouble(), (-y + yc).toDouble()));
      _matrix[x + xc][-y + yc] = -1;
      _matrix[-x + xc][-y + yc] = -1;
    }
    if (x + yc < maxY) {
      _points.add(Offset((y + xc).toDouble(), (x + yc).toDouble()));
      _matrix[y + xc][x + yc] = -1;
    }
    if (-x + yc > minY) {
      _points.add(Offset((y + xc).toDouble(), (-x + yc).toDouble()));
      _points.add(Offset((-y + xc).toDouble(), (-x + yc).toDouble()));
      _matrix[y + xc][-x + yc] = -1;
      _matrix[-y + xc][-x + yc] = -1;
    }
  }

  void drawCircle(
    List<Offset> _points,
    List<List<int>> _matrix,
    Offset center,
    double radius,
    double minY,
    double maxY,
    Function(List<Offset>, List<List<int>>, Offset, int, int, double, double)
        symmetrical,
  ) {
    int y = radius.toInt(), x = 0;
    int d = 3 - 2 * y;
    x = 0;

    while (x <= y) {
      symmetrical(_points, _matrix, center, x, y, minY, maxY);
      if (d < 0) {
        d = d + 4 * x + 6;
      } else {
        d = d + 4 * (x - y) + 6;
        y--;
      }
      x++;
    }
  }

  void drawEllipse(
    List<Offset> _points,
    List<List<int>> _matrix,
    Offset center,
    int a,
    int b,
  ) {
    int x = 0;
    int y = b;
    int aSqr = a * a;
    int bSqr = b * b;
    int delta = 4 * bSqr * ((x + 1) * (x + 1)) +
        aSqr * ((2 * y - 1) * (2 * y - 1)) -
        4 * aSqr * bSqr;
    while (aSqr * (2 * y - 1) > 2 * bSqr * (x + 1)) {
      pixel4(_points, _matrix, center, x, y);
      if (delta < 0) {
        x++;
        delta += 4 * bSqr * (2 * x + 3);
      } else {
        x++;
        delta = delta - 8 * aSqr * (y - 1) + 4 * bSqr * (2 * x + 3);
        y--;
      }
    }
    delta = bSqr * ((2 * x + 1) * (2 * x + 1)) +
        4 * aSqr * ((y + 1) * (y + 1)) -
        4 * aSqr * bSqr;
    while (y + 1 != 0) {
      pixel4(_points, _matrix, center, x, y);
      if (delta < 0) {
        y--;
        delta += 4 * aSqr * (2 * y + 3);
      } else {
        y--;
        delta = delta - 8 * bSqr * (x + 1) + 4 * aSqr * (2 * y + 3);
        x++;
      }
    }
  }

  void pixel4(
    List<Offset> _points,
    List<List<int>> _matrix,
    Offset center,
    int x,
    int y,
  ) {
    int xc = center.dx.toInt();
    int yc = center.dy.toInt();
    _points.add(Offset((xc + x).toDouble(), (yc + y).toDouble()));
    _points.add(Offset((xc + x).toDouble(), (yc - y).toDouble()));
    _points.add(Offset((xc - x).toDouble(), (yc + y).toDouble()));
    _points.add(Offset((xc - x).toDouble(), (yc - y).toDouble()));
    _matrix[xc + x][yc + y] = -1;
    _matrix[xc + x][yc - y] = -1;
    _matrix[xc - x][yc + y] = -1;
    _matrix[xc - x][yc - y] = -1;
  }

  int module(int value) {
    return value < 0 ? value * -1 : value;
  }

  double _toScreenX(double x, double xMin, double xMax, double width) {
    return (x - xMin) * width / (xMax - xMin) + 0;
  }

  double _toScreenY(double y, double yMin, double yMax, double height) {
    return (height - (y - yMin) * height / (yMax - yMin));
  }
}
