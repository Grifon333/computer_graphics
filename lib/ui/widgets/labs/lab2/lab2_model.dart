import 'dart:math';

import 'package:flutter/material.dart';

class Lab2Model extends ChangeNotifier {
  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.lightBlue,
    Colors.blue,
    Colors.purple,
    Colors.grey,
    Colors.black,
    Colors.white,
  ];

  double _scaleName = 1.0;
  double _scaleYear = 1.0;
  double _angleName = 0;
  double _angleYear = 0;
  Offset _offsetName = Offset.zero;
  Offset _offsetYear = Offset.zero;
  Offset _anchorPointName = Offset.zero;
  Offset _anchorPointYear = Offset.zero;
  Color _color = Colors.orange;

  void setColor(Color color) {
    if (_color == color) return;
    _color = color;
    notifyListeners();
  }

  void setScaleName(double value) {
    double correctValue = value / 100.0;
    if (_scaleName == correctValue) return;
    _scaleName = correctValue;
    notifyListeners();
  }

  void setScaleYear(double value) {
    double correctValue = value / 100.0;
    if (_scaleYear == correctValue) return;
    _scaleYear = correctValue;
    notifyListeners();
  }

  void setAngleName(double value) {
    double correctValue = value;
    if (_angleName == correctValue) return;
    _angleName = correctValue;
    notifyListeners();
  }

  void setAngleYear(double value) {
    double correctValue = value;
    if (_angleYear == correctValue) return;
    _angleYear = correctValue;
    notifyListeners();
  }

  void setAnchorPointName(Offset position) {
    if (_anchorPointName == position) return;
    _anchorPointName = position;
    notifyListeners();
  }

  void setAnchorPointYear(Offset position) {
    if (_anchorPointYear == position) return;
    _anchorPointYear = position;
    notifyListeners();
  }

  void setOffsetName(Offset position) {
    if (_offsetName == position) return;
    _offsetName = position;
    notifyListeners();
  }

  void setOffsetYear(Offset position) {
    if (_offsetYear == position) return;
    _offsetYear = position;
    notifyListeners();
  }

  Color get color => _color;

  double get scaleName => _scaleName;

  double get scaleYear => _scaleYear;

  double get angleName => _angleName;

  double get angleYear => _angleYear;

  Matrix4 getMatrixRotationName() {
    return _getMatrixRotation(_angleName);
  }

  Matrix4 getMatrixRotationYear() {
    return _getMatrixRotation(_angleYear);
  }

  Matrix4 _getMatrixRotation(double angle) {
    final radians = angle * pi / 180;

    Matrix4 result = Matrix4.zero();
    result[0] = cos(radians);
    result[1] = -sin(radians);
    result[4] = sin(radians);
    result[5] = cos(radians);
    result[10] = 1;
    result[15] = 1;
    return result;
  }

  Matrix4 getMatrixScaleName() {
    return _getMatrixScale(_scaleName);
  }

  Matrix4 getMatrixScaleYear() {
    return _getMatrixScale(_scaleYear);
  }

  Matrix4 _getMatrixScale(double scale) {
    Matrix4 result = Matrix4.zero();
    result[0] = scale;
    result[5] = scale;
    result[10] = 1;
    result[15] = 1;
    return result;
  }

  Matrix4 getMatrixOffsetName() {
    return _getMatrixOffset(_offsetName);
  }

  Matrix4 getMatrixOffsetYear() {
    return _getMatrixOffset(_offsetYear);
  }

  Matrix4 _getMatrixOffset(Offset position) {
    Matrix4 result = Matrix4.zero();
    result[12] = position.dx;
    result[13] = position.dy;
    result[0] = 1;
    result[5] = 1;
    result[10] = 1;
    result[15] = 1;
    return result;
  }

  Offset get anchorPointName => _anchorPointName;

  Offset get anchorPointYear => _anchorPointYear;

  Offset get offsetName => _offsetName;

  Offset get offsetYear => _offsetYear;

  void reset() {
    _scaleName = 1.0;
    _scaleYear = 1.0;
    _angleName = 0;
    _angleYear = 0;
    _offsetName = Offset.zero;
    _offsetYear = Offset.zero;
    _anchorPointName = Offset.zero;
    _anchorPointYear = Offset.zero;
    notifyListeners();
  }
}
