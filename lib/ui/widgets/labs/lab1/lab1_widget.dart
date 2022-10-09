import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import 'package:graphics/Library/Widgets/Inherited/provider.dart';
import 'package:graphics/ui/widgets/labs/lab1/lab1_model.dart';

class Lab1Widget extends StatelessWidget {
  const Lab1Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Graph',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: const [
              SizedBox(height: 10),
              _GraphWidget(),
              SizedBox(height: 20),
              _IntervalWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _GraphWidget extends StatelessWidget {
  const _GraphWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
            width: 2,
          ),
        ),
        child: const _CustomPainterWidget(),
      ),
    );
  }
}

class _CustomPainterWidget extends StatelessWidget {
  const _CustomPainterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<Lab1Model>(context);
    if (model == null) return const SizedBox.shrink();

    double heightParent = 300;
    double widthParent = MediaQuery.of(context).size.width - 32;
    double start, end;
    if (model.scaleStart != null && model.scaleEnd != null) {
      start = model.scaleStart ?? -5;
      end = model.scaleEnd ?? 5;
    } else {
      start = model.start;
      end = model.end;
    }
    final width = end - start;
    final height = heightParent * width / widthParent;
    final up = height / 2;
    final down = -up;

    return ClipRect(
      child: SizedBox(
        height: heightParent,
        width: widthParent,
        child: CustomPaint(
          painter: _MyPainter(
            sizeScreen: Size(widthParent, heightParent),
            start: start,
            end: end,
            up: up,
            down: down,
          ),
        ),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  final Size sizeScreen;
  final double start;
  final double end;
  final double up;
  final double down;

  _MyPainter({
    required this.sizeScreen,
    required this.start,
    required this.end,
    required this.up,
    required this.down,
  });

  @override
  void paint(Canvas canvas, Size size) {
    drawCoordinateX(size, canvas);
    drawCoordinateY(canvas, size);
    drawGrid(canvas);
    drawGraph(size, canvas);
  }

  void drawGraph(Size size, Canvas canvas) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black
      ..strokeWidth = 1.8;

    List<Offset> list = [];
    final xMin = pow(1.2, 1.0 / 3);
    for (double i = start; i <= end; i += 0.01) {
      double x = i;
      double y;
      if (x <= xMin) {
        y = 0;
      } else {
        y = ((log(x * x * x - 1.2) / log(10)) / (x * x + cos(x)));
      }
      final point = Offset(x, y);
      list.add(point);
    }

    for (int i = 0; i < list.length - 1; i++) {
      final xStart = toScreenX(list[i].dx, start, end);
      var yStart = toScreenY(list[i].dy, down, up);
      final xEnd = toScreenX(list[i + 1].dx, start, end);
      final yEnd = toScreenY(list[i + 1].dy, down, up);
      if (list[i].dx <= xMin && list[i + 1].dx <= xMin) continue;
      if (list[i].dx <= xMin && list[i + 1].dx > xMin) {
        yStart = 1000;
      }
      canvas.drawLine(Offset(xStart, yStart), Offset(xEnd, yEnd), paint);
    }
  }

  void drawCoordinateX(Size size, Canvas canvas) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black
      ..strokeWidth = 1;

    final xStart = toScreenX(start, start, end);
    final xEnd = toScreenX(end, start, end);
    final y = toScreenY(0, down, up);
    canvas.drawLine(
      Offset(xStart, y),
      Offset(xEnd, y),
      paint,
    );
  }

  void drawCoordinateY(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black
      ..strokeWidth = 1;

    final yStart = toScreenY(up, down, up);
    final yEnd = toScreenY(down, down, up);
    final x = toScreenX(0, start, end);
    canvas.drawLine(
      Offset(x, yStart),
      Offset(x, yEnd),
      paint,
    );
  }

  void drawGrid(Canvas canvas) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey;
    final yStart = toScreenY(up, down, up);
    final yEnd = toScreenY(down, down, up);
    double x;
    for (int i = start.toInt(); i <= end; i++) {
      x = toScreenX(i.toDouble(), start, end);
      canvas.drawLine(
        Offset(x, yStart),
        Offset(x, yEnd),
        paint,
      );
    }
    final xStart = toScreenX(start, start, end);
    final xEnd = toScreenX(end, start, end);
    double y;
    for (int i = down.toInt(); i <= end; i++) {
      y = toScreenY(i.toDouble(), down, up);
      canvas.drawLine(
        Offset(xStart, y),
        Offset(xEnd, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  double toScreenX(
    double x,
    double xMin,
    double xMax, [
    double screenXMin = 0.0,
  ]) {
    return (x - xMin) * (sizeScreen.width - screenXMin) / (xMax - xMin) +
        screenXMin;
  }

  double toScreenY(
    double y,
    double yMin,
    double yMax, [
    double screenYMin = 0.0,
  ]) {
    return (sizeScreen.height -
        (y - yMin) * (sizeScreen.height - screenYMin) / (yMax - yMin));
  }
}

class _IntervalWidget extends StatelessWidget {
  const _IntervalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<Lab1Model>(context);
    if (model == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Start:   ',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              width: 45,
              height: 30,
              child: TextField(
                onChanged: (value) => {
                  value.isEmpty || value == '-' ? null : model.setStart(value),
                },
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^[-]?\d*\.?\d*')),
                ],
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.end,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 6),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            const Text(
              'End:   ',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              width: 45,
              height: 30,
              child: TextField(
                onChanged: (value) => {
                  value.isEmpty || value == '-' ? null : model.setEnd(value),
                },
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^[-]?\d*\.?\d*')),
                ],
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.end,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 6),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => model.showGraph(),
          child: const Text(
            'Show',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Slider.adaptive(
          value: model.rating * 100,
          onChanged: (value) => model.setRating(value),
          min: 0,
          max: 100,
          activeColor: Colors.blue[800],
        ),
        const SizedBox(height: 7),
        SizedBox(
          width: double.infinity,
          child: Text(
            '${((model.rating * 2 - 1) * 100).roundToDouble() / 100}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }
}
