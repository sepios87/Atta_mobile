import 'package:flutter/material.dart';

extension WidgetExt on Widget {
  Widget withPadding(EdgeInsetsGeometry padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }
}
