import 'package:flutter/material.dart';

enum WindowWidthSizeClass { compact, medium, exanded }

WindowWidthSizeClass getWindowWidthSizeClass(BoxConstraints constraints) {
  return constraints.maxWidth <= 600
      ? WindowWidthSizeClass.compact
      : constraints.maxWidth <= 840
          ? WindowWidthSizeClass.medium
          : WindowWidthSizeClass.exanded;
}
