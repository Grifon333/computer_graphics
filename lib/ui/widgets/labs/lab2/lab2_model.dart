import 'package:flutter/material.dart';

class Lab2Model extends ChangeNotifier {
  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.lightBlue,
    Colors.blue,
    Colors.purple
  ];

  Color _color = Colors.orange;

  void setColor(Color color) {
    _color = color;
    notifyListeners();
  }

  Color get color => _color;
}
