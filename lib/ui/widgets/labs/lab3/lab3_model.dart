import 'package:flutter/cupertino.dart';

class Lab3Model extends ChangeNotifier {
  double _distance = 0.7;

  void setDistance(double value) {
    double correctValue = value / 100.0;
    if (_distance == correctValue) return;
    _distance = correctValue;
    notifyListeners();
  }

  double get distance => _distance;
}