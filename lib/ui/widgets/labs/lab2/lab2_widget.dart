import 'package:flutter/material.dart';
import 'package:graphics/Library/Widgets/Inherited/provider.dart';
import 'package:graphics/ui/elements/alphabet.dart';
import 'package:graphics/ui/elements/numbers.dart';
import 'package:graphics/ui/widgets/labs/lab2/lab2_model.dart';

class Lab2Widget extends StatelessWidget {
  const Lab2Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<Lab2Model>(context);
    if (model == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab2'),
        actions: [
          IconButton(
            onPressed: () => model.reset(),
            icon: const Icon(
              Icons.refresh,
              size: 28,
            ),
          )
        ],
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: _BodyWidget(),
        ),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 560,
          child: Column(
            children: const [
              _ChangeColorWidget(),
              SizedBox(height: 30),
              _NameWidget(),
              SizedBox(height: 20),
              _YearWidget(),
            ],
          ),
        ),
        const _ChangeScoreWidget(),
        const SizedBox(height: 10),
        const _ChangeRotationWidget(),
      ],
    );
  }
}

class _NameWidget extends StatelessWidget {
  const _NameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<Lab2Model>(context);
    if (model == null) return const SizedBox.shrink();

    int size = (MediaQuery.of(context).size.width - 32) ~/ 4;

    return GestureDetector(
      onTapDown: (details) {
        model.setAnchorPointName(details.localPosition);
      },
      onPanUpdate: (details) {
        model.setOffsetName(model.offsetName + details.delta);
      },
      child: Transform(
        origin: model.anchorPointName,
        transform: model.getMatrixOffsetName(),
        child: Transform(
          origin: model.anchorPointName,
          transform: model.getMatrixScaleName(),
          child: Transform(
            origin: model.anchorPointName,
            transform: model.getMatrixRotationName(),
            child: SizedBox(
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
          ),
        ),
      ),
    );
  }
}

class _YearWidget extends StatelessWidget {
  const _YearWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<Lab2Model>(context);
    if (model == null) return const SizedBox.shrink();

    int size = (MediaQuery.of(context).size.width - 32) ~/ 4;

    return GestureDetector(
      onTapDown: (details) {
        model.setAnchorPointYear(details.localPosition);
      },
      onPanUpdate: (details) {
        model.setOffsetYear(model.offsetYear + details.delta);
      },
      child: Transform(
        transform: model.getMatrixOffsetYear(),
        child: Transform(
          origin: model.anchorPointYear,
          transform: model.getMatrixScaleYear(),
          child: Transform(
            origin: model.anchorPointYear,
            transform: model.getMatrixRotationYear(),
            child: SizedBox(
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
          ),
        ),
      ),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
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

class _ChangeScoreWidget extends StatelessWidget {
  const _ChangeScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<Lab2Model>(context);
    if (model == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Scale',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Name',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 80,
              child: Slider.adaptive(
                value: model.scaleName * 100,
                onChanged: (value) => model.setScaleName(value),
                min: 75,
                max: 125,
                activeColor: Colors.blue[800],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Year',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 80,
              child: Slider.adaptive(
                value: model.scaleYear * 100,
                onChanged: (value) => model.setScaleYear(value),
                min: 75,
                max: 125,
                activeColor: Colors.blue[800],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChangeRotationWidget extends StatelessWidget {
  const _ChangeRotationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<Lab2Model>(context);
    if (model == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rotation',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Name',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 80,
              child: Slider.adaptive(
                value: model.angleName,
                onChanged: (value) => model.setAngleName(value),
                min: 0,
                max: 360,
                activeColor: Colors.blue[800],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Year',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 80,
              child: Slider.adaptive(
                value: model.angleYear,
                onChanged: (value) => model.setAngleYear(value),
                min: 0,
                max: 360,
                activeColor: Colors.blue[800],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
