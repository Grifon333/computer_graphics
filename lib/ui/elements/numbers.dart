import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphics/ui/elements/formulas.dart';

class CustomNumbers {
  CustomPainter two(Color color) {
    return _TwoPainter(color: color);
  }

  CustomPainter zero(Color color) {
    return _ZeroPainter(color: color);
  }

  CustomPainter three(Color color) {
    return _ThreePainter(color: color);
  }

  CustomPainter nine(Color color) {
    return _NinePainter(color: color);
  }
}

class _ZeroPainter extends CustomPainter {
  final Color color;
  final List<Offset> _points = [];
  final List<Offset> _pouring = [];
  List<List<int>> _matrix = [];

  _ZeroPainter({required this.color});

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
    _matrix = List.generate(h, (_) => List.filled(w, 0));

    formulas.drawEllipse(
      _points,
      _matrix,
      Offset(0.5 * w, 0.5 * h),
      (0.3 * w).toInt(),
      (0.4 * h).toInt(),
    );
    formulas.drawEllipse(
      _points,
      _matrix,
      Offset(0.5 * w, 0.5 * h),
      (0.15 * w).toInt(),
      (0.3 * h).toInt(),
    );

    formulas.colorFill(_matrix, _pouring, Offset(0.5 * h, 0.15 * h));

    canvas.drawPoints(PointMode.points, _pouring, paintFill);
    canvas.drawPoints(PointMode.points, _points, paintBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _TwoPainter extends CustomPainter {
  final Color color;
  final List<Offset> _points = [];
  final List<Offset> _pouring = [];
  List<List<int>> _matrix = [];

  _TwoPainter({required this.color});

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
    _matrix = List.generate(h, (_) => List.filled(w, 0));

    formulas.drawCircle(
      _points,
      _matrix,
      Offset(0.5 * w, 0.3 * h),
      0.2 * w,
      0,
      0.4 * h,
      formulas.sim,
    );
    formulas.drawCircle(
      _points,
      _matrix,
      Offset(0.5 * w, 0.3 * h),
      0.1 * w,
      0,
      0.36 * h,
      formulas.sim,
    );

    List<Offset> points = [];
    points.add(Offset(0.673 * w, 0.4 * h));
    points.add(Offset(0.4 * w, 0.8 * h));
    points.add(Offset(0.7 * w, 0.8 * h));
    points.add(Offset(0.7 * w, 0.9 * h));
    points.add(Offset(0.3 * w, 0.9 * h));
    points.add(Offset(0.3 * w, 0.8 * h));
    points.add(Offset(0.59 * w, 0.34 * h));
    for (int i = 0; i < points.length - 1; i++) {
      Offset start = points[i];
      Offset end = points[i + 1];
      formulas.drawLine(_points, _matrix, start, end);
    }
    points.clear();

    points.add(Offset(0.33 * w, 0.4 * h));
    points.add(Offset(0.435 * w, 0.35 * h));
    for (int i = 0; i < points.length - 1; i++) {
      Offset start = points[i];
      Offset end = points[i + 1];
      formulas.drawLine(_points, _matrix, start, end);
    }
    points.clear();

    formulas.colorFill(_matrix, _pouring, Offset(0.5 * h, 0.85 * h));

    canvas.drawPoints(PointMode.points, _pouring, paintFill);
    canvas.drawPoints(PointMode.points, _points, paintBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _ThreePainter extends CustomPainter {
  final Color color;
  final List<Offset> _points = [];
  final List<Offset> _pouring = [];
  List<List<int>> _matrix = [];

  _ThreePainter({required this.color});

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
    _matrix = List.generate(h, (_) => List.filled(w, 0));

    formulas.drawCircle(
      _points,
      _matrix,
      Offset(0.5 * w, 0.3 * h),
      0.2 * w,
      0,
      0.443 * h,
      formulas.simForThree2,
    );
    formulas.drawCircle(
      _points,
      _matrix,
      Offset(0.5 * w, 0.3 * h),
      0.1 * w,
      0,
      h.toDouble(),
      formulas.simForThree2,
    );
    formulas.drawCircle(
      _points,
      _matrix,
      Offset(0.5 * w, 0.65 * h),
      0.25 * w,
      0.43 * h,
      h.toDouble(),
      formulas.simForThree1,
    );
    formulas.drawCircle(
      _points,
      _matrix,
      Offset(0.5 * w, 0.65 * h),
      0.15 * w,
      0,
      h.toDouble(),
      formulas.simForThree1,
    );

    formulas.drawLine(
      _points,
      _matrix,
      Offset(0.31 * w, 0.3 * h),
      Offset(0.42 * w, 0.3 * h),
    );
    formulas.drawLine(
      _points,
      _matrix,
      Offset(0.26 * w, 0.65 * h),
      Offset(0.37 * w, 0.65 * h),
    );
    formulas.drawLine(
      _points,
      _matrix,
      Offset(0.5 * w, 0.4 * h),
      Offset(0.5 * w, 0.51 * h),
    );

    formulas.colorFill(_matrix, _pouring, Offset(0.55 * h, 0.45 * h));

    canvas.drawPoints(PointMode.points, _pouring, paintFill);
    canvas.drawPoints(PointMode.points, _points, paintBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _NinePainter extends CustomPainter {
  final Color color;
  final List<Offset> _points = [];
  final List<Offset> _pouring = [];
  List<List<int>> _matrix = [];

  _NinePainter({required this.color});

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
    _matrix = List.generate(h, (_) => List.filled(w, 0));

    formulas.drawCircle(
      _points,
      _matrix,
      Offset(0.5 * w, 0.3 * h),
      0.2 * w,
      0,
      0.443 * h,
      formulas.sim,
    );
    formulas.drawCircle(
      _points,
      _matrix,
      Offset(0.5 * w, 0.3 * h),
      0.1 * w,
      0,
      h.toDouble(),
      formulas.sim,
    );
    formulas.drawCircle(
      _points,
      _matrix,
      Offset(0.5 * w, 0.65 * h),
      0.25 * w,
      0.443 * h,
      h.toDouble(),
      formulas.sim,
    );
    formulas.drawCircle(
      _points,
      _matrix,
      Offset(0.5 * w, 0.65 * h),
      0.15 * w,
      0,
      h.toDouble(),
      formulas.sim,
    );

    formulas.colorFill(_matrix, _pouring, Offset(0.5 * h, 0.15 * h));

    canvas.drawPoints(PointMode.points, _pouring, paintFill);
    canvas.drawPoints(PointMode.points, _points, paintBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
