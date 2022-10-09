import 'dart:math';

import 'package:flutter/material.dart';

class Lab2Model extends ChangeNotifier {
  Color _color = Color.fromRGBO(
      Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1);

  void setColor(Color color) {
    _color = color;
    notifyListeners();
  }

  Color get color => _color;
}
