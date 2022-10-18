import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphics/Library/Widgets/Inherited/provider.dart';
import 'package:graphics/ui/elements/alphabet.dart';
import 'package:graphics/ui/widgets/labs/lab2/lab2_model.dart';

class Lab2Widget extends StatelessWidget {
  const Lab2Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab2'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: _BodyWidget(),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<Lab2Model>(context);
    if (model == null) return const SizedBox.shrink();

    // double size = MediaQuery.of(context).size.width / 2 - 18;
    int size = MediaQuery.of(context).orientation == Orientation.landscape
        ? (MediaQuery.of(context).size.height / 2 - 32).toInt()
        : (MediaQuery.of(context).size.width / 2 - 32).toInt();
    return Column(
      children: [
        const _ChangeColorWidget(),
        const SizedBox(height: 20),
        SizedBox(
          height: size.toDouble(),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _ShowElementWidget(
                size: size,
                painter: Alphabet().d(model.color),
              ),
              _ShowElementWidget(
                size: size,
                painter: Alphabet().a(model.color),
              ),
              _ShowElementWidget(
                size: size,
                painter: Alphabet().n(model.color),
              ),
              _ShowElementWidget(
                size: size,
                painter: Alphabet().ya(model.color),
              ),

              // Container(
              //   child: FittedBox(
              //     fit: BoxFit.fitWidth,
              //     child: ClipRect(
              //       clipper: _MyClipper(),
              //       child: _ShowElementWidget(
              //         size: size,
              //         painter: Alphabet().d(model.color),
              //       ),
              //     ),
              //   ),
              // ),

              // Container( // just a parent
              //   child: Align( // important
              //     alignment: Alignment.center,
              //     child: SizedBox(
              //       width: 100,  // final width of cropped portion
              //       height: 100,  // final height of cropped portion
              //       child: ClipRect(
              //         clipper: _MyClipper(),// this is a custom clipper i made of type CustomClipper<Rect>
              //         child: _ShowElementWidget(
              //           size: size,
              //           painter: Alphabet().a(model.color),
              //         ),
              //       ),
              //     ),
              //   ),
              // )

              // Crop(
              //   controller: controller,
              //   child: _ShowElementWidget(
              //     size: size,
              //     painter: Alphabet().d(model.color),
              //   ),
              //   shape: BoxShape.rectangle,
              // ),

              // _ShowElementWidget(
              //   size: size,
              //   painter: Alphabet().a(model.color),
              // ),
              // _ShowElementWidget(
              //   size: size,
              //   painter: Alphabet().n(model.color),
              // ),
              // _ShowElementWidget(
              //   size: size,
              //   painter: Alphabet().ya(model.color),
              // ),
              // _ShowElementWidget(
              //   size: size,
              //   painter: _NumberPainter(color: model.color),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShowElementWidget extends StatelessWidget {
  final int size;
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
        width: size.toDouble(),
        height: size.toDouble(),
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
    return Rect.fromLTRB(0.2 * size.width, 0.1 * size.height, 0.8 * size.width,
        0.9 * size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}
