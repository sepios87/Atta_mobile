import 'package:flutter/material.dart';

extension BorderRadiusExt on BorderRadius {
  static BorderRadius top(double radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    );
  }

  static BorderRadius bottom(double radius) {
    return BorderRadius.only(
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );
  }
}
