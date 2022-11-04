import 'package:flutter/material.dart';
import 'package:graphics/Library/Widgets/Inherited/provider.dart';
import 'package:graphics/ui/widgets/labs/lab3/3d_object.dart';
import 'package:graphics/ui/widgets/labs/lab3/lab3_model.dart';

class Lab3Widget extends StatelessWidget {
  const Lab3Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab3'),
        backgroundColor: Colors.green,
      ),
      body: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<Lab3Model>(context);
    if (model == null) return const SizedBox.shrink();

    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 300,
            width: 300,
            child: CustomPaint(
              painter: MyCustomPainter(distance: model.distance),
            ),
          ),
          Slider.adaptive(
            value: model.distance * 100,
            onChanged: (value) => model.setDistance(value),
            min: 50,
            max: 1000,
            activeColor: Colors.blue[800],
          ),
        ],
      ),
    );
  }
}
