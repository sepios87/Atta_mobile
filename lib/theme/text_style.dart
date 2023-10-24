import 'package:flutter/material.dart';

class AttaTextStyle {
  static TextStyle get header => const TextStyle(
        fontFamily: 'WorkSans',
        fontWeight: FontWeight.w600,
        fontSize: 20,
        height: 1.2,
        color: Colors.black,
      );

  static TextStyle get subHeader => const TextStyle(
        fontFamily: 'WorkSans',
        fontWeight: FontWeight.w600,
        fontSize: 15,
        height: 1.2,
        color: Colors.black,
      );

  static TextStyle get content => const TextStyle(
        fontFamily: 'WorkSans',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.2,
        color: Colors.black,
      );

  static TextStyle get label => const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 16,
      );

  static TextStyle get caption => const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 13,
      );
}
