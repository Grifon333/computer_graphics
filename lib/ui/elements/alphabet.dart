import 'package:flutter/material.dart';
import 'package:graphics/ui/elements/custom_symbol_painter.dart';

class Alphabet {
  CustomPainter d(Color color) {
    List<Offset> outPoints = [
      const Offset(0.2, 0.1),
      const Offset(0.7, 0.2),
      const Offset(0.6, 0.7),
      const Offset(0.75, 0.7),
      const Offset(0.65, 0.9),
      const Offset(0.65, 0.8),
      const Offset(0.35, 0.8),
      const Offset(0.35, 0.9),
      const Offset(0.25, 0.7),
      const Offset(0.4, 0.7),
    ];

    List<Offset> innerPoints = [
      const Offset(0.4, 0.25),
      const Offset(0.55, 0.3),
      const Offset(0.5, 0.55),
    ];

    return CustomSymbolPainter(
      color: color,
      outerPointsList: outPoints,
      innerPointsList: innerPoints,
      startColorFill: const Offset(0.3, 0.3),
    );
  }

  CustomPainter a(Color color) {
    List<Offset> outPoints = [
      const Offset(0.6, 0.05),
      const Offset(0.75, 0.9),
      const Offset(0.65, 0.9),
      const Offset(0.6, 0.8),
      const Offset(0.25, 0.9),
    ];

    List<Offset> innerPoints = [
      const Offset(0.55, 0.4),
      const Offset(0.6, 0.65),
      const Offset(0.45, 0.7),
    ];

    return CustomSymbolPainter(
      color: color,
      outerPointsList: outPoints,
      innerPointsList: innerPoints,
      startColorFill: const Offset(0.5, 0.7),
    );
  }

  CustomPainter n(Color color) {
    List<Offset> outPoints = [
      const Offset(0.2, 0.1),
      const Offset(0.4, 0.1),
      const Offset(0.4, 0.35),
      const Offset(0.6, 0.35),
      const Offset(0.6, 0.1),
      const Offset(0.8, 0.1),
      const Offset(0.7, 0.9),
      const Offset(0.6, 0.9),
      const Offset(0.6, 0.5),
      const Offset(0.4, 0.5),
      const Offset(0.4, 0.9),
      const Offset(0.3, 0.9),
    ];

    return CustomSymbolPainter(
      color: color,
      outerPointsList: outPoints,
      // innerPointsList: innerPoints,
      startColorFill: const Offset(0.3, 0.3),
    );
  }

  CustomPainter ya(Color color) {
    List<Offset> outPoints = [
      const Offset(0.2, 0.1),
      const Offset(0.75, 0.1),
      const Offset(0.75, 0.9),
      const Offset(0.6, 0.9),
      const Offset(0.6, 0.65),
      const Offset(0.45, 0.9),
      const Offset(0.25, 0.9),
      const Offset(0.45, 0.6),
      const Offset(0.2, 0.4),
    ];

    List<Offset> innerPoints = [
      const Offset(0.35, 0.2),
      const Offset(0.6, 0.2),
      const Offset(0.6, 0.55),
      const Offset(0.35, 0.35),
    ];

    return CustomSymbolPainter(
      color: color,
      outerPointsList: outPoints,
      innerPointsList: innerPoints,
      startColorFill: const Offset(0.25, 0.25),
    );
  }
}