import 'package:flutter/material.dart';

abstract class Styles {
  static const mainColor = Color(0xFFFFE600);
  static const secColor = Color(0xFFF5F5F5);
  static const bgColor = Color(0xFF25364A);

  /// STYLES

  static const mainText = TextStyle(
    color: secColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const subText = TextStyle(
    color: mainColor,
    fontSize: 20,
    fontStyle: FontStyle.italic,
  );
}
