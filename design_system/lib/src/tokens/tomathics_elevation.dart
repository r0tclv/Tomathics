import 'package:flutter/material.dart';

/// Small shadow vocabulary; borders remain the primary surface separator.
abstract final class TomathicsElevation {
  static const List<BoxShadow> none = [];

  static const List<BoxShadow> panel = [
    BoxShadow(
      color: Color(0x0A071329),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x18071128),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static List<BoxShadow> focus(Color color) => [
    BoxShadow(color: color.withValues(alpha: 0.18), blurRadius: 18),
  ];
}
