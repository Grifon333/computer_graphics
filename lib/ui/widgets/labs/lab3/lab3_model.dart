import 'dart:math';

import 'package:flutter/cupertino.dart';

class Lab3Model extends ChangeNotifier {
  final double _distance = 3;
  double _angleX = 0;
  double _angleY = 0;
  double _angleZ = 0;
  double _scale = 1;
  double _movingX = 0;
  double _movingY = 0;
  double _movingZ = 0;

  void setAngleX(double value) {
    if (_angleX == value) return;
    _angleX = value;
    notifyListeners();
  }

  void setAngleY(double value) {
    if (_angleY == value) return;
    _angleY = value;
    notifyListeners();
  }

  void setAngleZ(double value) {
    if (_angleZ == value) return;
    _angleZ = value;
    notifyListeners();
  }

  void setScale(double value) {
    if (_scale == value) return;
    _scale = value;
    notifyListeners();
  }

  void setMovingX(double value) {
    if (_movingX == value) return;
    _movingX = value;
    notifyListeners();
  }

  void setMovingY(double value) {
    if (_movingY == value) return;
    _movingY = value;
    notifyListeners();
  }

  void setMovingZ(double value) {
    if (_movingZ == value) return;
    _movingZ = value;
    notifyListeners();
  }

  List<List<double>> getMatrixRotationX() {
    final radians = _angleX * pi / 180;
    List<List<double>> result = List.generate(4, (_) => List.filled(4, 0));

    result[1][1] = cos(radians);
    result[1][2] = -sin(radians);
    result[2][1] = sin(radians);
    result[2][2] = cos(radians);
    result[0][0] = 1;
    result[3][3] = 1;
    return result;
  }

  List<List<double>> getMatrixRotationY() {
    final radians = _angleY * pi / 180;
    List<List<double>> result = List.generate(4, (_) => List.filled(4, 0));

    result[0][0] = cos(radians);
    result[0][2] = sin(radians);
    result[2][0] = -sin(radians);
    result[2][2] = cos(radians);
    result[1][1] = 1;
    result[3][3] = 1;
    return result;
  }

  List<List<double>> getMatrixRotationZ() {
    final radians = _angleZ * pi / 180;
    List<List<double>> result = List.generate(4, (_) => List.filled(4, 0));

    result[0][0] = cos(radians);
    result[0][1] = -sin(radians);
    result[1][0] = sin(radians);
    result[1][1] = cos(radians);
    result[2][2] = 1;
    result[3][3] = 1;
    return result;
  }

  List<List<double>> getMatrixScale() {
    List<List<double>> result = List.generate(4, (_) => List.filled(4, 0));

    result[0][0] = scale;
    result[1][1] = scale;
    result[2][2] = scale;
    result[3][3] = 1;
    return result;
  }

  List<List<double>> getMatrixMoving() {
    List<List<double>> result = List.generate(4, (_) => List.filled(4, 0));

    result[0][0] = 1;
    result[1][1] = 1;
    result[2][2] = 1;
    result[3][3] = 1;
    result[0][3] = _movingX;
    result[1][3] = _movingY;
    result[2][3] = _movingZ;
    return result;
  }

  void reset() {
    _angleX = 0;
    _angleY = 0;
    _angleZ = 0;
    _scale = 1;
    _movingX = 0;
    _movingY = 0;
    _movingZ = 0;
    notifyListeners();
  }

  double get distance => _distance;

  double get angleX => _angleX;

  double get angleY => _angleY;

  double get angleZ => _angleZ;

  double get scale => _scale;

  double get movingX => _movingX;

  double get movingY => _movingY;

  double get movingZ => _movingZ;
}
