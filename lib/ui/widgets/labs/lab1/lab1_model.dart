import 'package:flutter/material.dart';

class Lab1Model extends ChangeNotifier {
  double _start = -5;
  double _end = 5;
  double _rating = 0.5;
  double? _scaleStart;
  double? _scaleEnd;

  void setStart(String value) {
    final correctValue = checkValue(value);
    if (_start == correctValue) return;
    _start = correctValue;
  }

  void setEnd(String value) {
    final correctValue = checkValue(value);
    if (_end == correctValue) return;
    _end = correctValue;
  }

  void setRating(double value) {
    double correctValue = value / 100.0;
    if (_rating == correctValue) return;
    _rating = correctValue;
    scaleGraph();
  }

  double get start => _start;

  double get end => _end;

  double get rating => _rating;

  double? get scaleStart => _scaleStart;

  double? get scaleEnd => _scaleEnd;

  double checkValue(String value) {
    final String correctValue;
    if (value == '.') {
      correctValue = '0.';
    } else if (value == '-.') {
      correctValue = '-0.';
    } else {
      correctValue = value;
    }
    return double.parse(correctValue);
  }

  void showGraph() {
    _scaleStart = null;
    _scaleEnd = null;
    _rating = 0.5;
    notifyListeners();
  }

  void scaleGraph() {
    double scale = 1;
    if (_rating == 0) return;
    scale = calculateScale();

    final oldRange = _end - _start;
    final newRange = oldRange * scale;
    if (oldRange == newRange) return;

    if (newRange > oldRange) {
      final difference = newRange - oldRange;
      _scaleStart = _start - difference / 2;
      _scaleEnd = _end + difference / 2;
    } else if (newRange < oldRange) {
      final difference = oldRange - newRange;
      _scaleStart = _start + difference / 2;
      _scaleEnd = _end - difference / 2;
    }
    notifyListeners();
  }

  double calculateScale() {
    const double ratingMin = 0;
    const double ratingMax = 1;
    const double scaleMin = 0;
    const double scaleMax = 2;
    return ((_rating - ratingMin) * (scaleMax - scaleMin)) /
            (ratingMax - ratingMin) +
        scaleMin;
  }
}
