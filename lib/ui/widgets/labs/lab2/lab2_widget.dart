import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphics/Library/Widgets/Inherited/provider.dart';
import 'package:graphics/ui/elements/alphabet.dart';
import 'package:graphics/ui/elements/numbers.dart';
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
    // int size = MediaQuery.of(context).orientation == Orientation.landscape
    //     ? (MediaQuery.of(context).size.height / 2 - 32).toInt()
    //     : (MediaQuery.of(context).size.width / 2 - 32).toInt();
    int size = ((MediaQuery.of(context).size.width - 32) / 4).toInt();
    return Column(
      children: [
        const _ChangeColorWidget(),
        const SizedBox(height: 30),
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
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: size.toDouble(),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _ShowElementWidget(
                size: size,
                painter: CustomNumbers().two(model.color),
              ),
              _ShowElementWidget(
                size: size,
                painter: CustomNumbers().zero(model.color),
              ),
              _ShowElementWidget(
                size: size,
                painter: CustomNumbers().zero(model.color),
              ),
              _ShowElementWidget(
                size: size,
                painter: CustomNumbers().three(model.color),
              ),
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

    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Colors.lightBlue[100]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(6),
            child: Text(
              'Color:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 36,
            child: ListView.builder(
              itemCount: model.colors.length,
              itemExtent: 48,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => model.setColor(model.colors[index]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(3)),
                        color: model.colors[index],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
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
