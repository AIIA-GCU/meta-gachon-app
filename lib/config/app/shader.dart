import 'package:flutter/material.dart';

Shader hazySide(Rect rect) {
  return const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF4F5F8),
      Colors.transparent,
      Colors.transparent,
      Color(0xFFF4F5F8)
    ],
    stops: [0.0, 0.121212, 0.878787, 1.0],
  ).createShader(rect);
}