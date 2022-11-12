import 'package:flutter/material.dart';
import 'package:graphics/Library/Widgets/Inherited/provider.dart';
import 'package:graphics/ui/widgets/labs/lab3/lab3_model.dart';
import 'package:graphics/ui/widgets/labs/lab3/object.dart';

class Lab3Widget extends StatelessWidget {
  const Lab3Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<Lab3Model>(context);
    if (model == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab3'),
        backgroundColor: Colors.green,
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
      body: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          _3DObjectWidget(),
          SizedBox(height: 16),
          _SettingsWidget(),
        ],
      ),
    );
  }
}

class _3DObjectWidget extends StatelessWidget {
  const _3DObjectWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<Lab3Model>(context);
    if (model == null) return const SizedBox.shrink();
    const double height = 300, width = 300;

    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: DecoratedBox(
          // decoration: const BoxDecoration(color: Colors.black12),
          decoration: const BoxDecoration(color: Colors.transparent),
          child: CustomPaint(
            // painter: MyCustomPainter(
            //   distance: model.distance,
            //   context: context,
            //   height: height,
            //   width: width,
            // ),
            painter: CustomPaintObject(context),
          ),
        ),
      ),
    );
  }
}

class _SettingsWidget extends StatelessWidget {
  const _SettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<Lab3Model>(context);
    if (model == null) return const SizedBox.shrink();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              'Rotation',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        _SliderWidget(
          message: 'X',
          value: model.angleX,
          onChange: model.setAngleX,
          min: -180,
          max: 180,
        ),
        _SliderWidget(
          message: 'Y',
          value: model.angleY,
          onChange: model.setAngleY,
          min: -180,
          max: 180,
        ),
        _SliderWidget(
          message: 'Z',
          value: model.angleZ,
          onChange: model.setAngleZ,
          min: -180,
          max: 180,
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              'Scale',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        Slider.adaptive(
          value: model.scale,
          onChanged: (value) => model.setScale(value),
          min: 0.5,
          max: 1,
          activeColor: Colors.blue[800],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              'Moving',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        _SliderWidget(
          message: 'X',
          value: model.movingX,
          onChange: model.setMovingX,
          min: -10,
          max: 10,
        ),
        _SliderWidget(
          message: 'Y',
          value: model.movingY,
          onChange: model.setMovingY,
          min: -10,
          max: 10,
        ),
        _SliderWidget(
          message: 'Z',
          value: model.movingZ,
          onChange: model.setMovingZ,
          min: -10,
          max: 10,
        ),
      ],
    );
  }
}

class _SliderWidget extends StatelessWidget {
  final String message;
  final double value;
  final void Function(double) onChange;
  final double min;
  final double max;

  const _SliderWidget({
    Key? key,
    required this.message,
    required this.value,
    required this.onChange,
    required this.min,
    required this.max,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 48,
          child: Slider.adaptive(
            value: value,
            onChanged: (value) => onChange(value),
            min: min,
            max: max,
            activeColor: Colors.blue[800],
          ),
        ),
      ],
    );
  }
}
