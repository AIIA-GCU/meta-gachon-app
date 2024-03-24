///
/// shader.dart
/// 2024.03.07
/// by. @protaku
///
/// Change
/// - Added comments
///
/// Content
/// [*] Function
///   - hazySide
///

import 'package:flutter/material.dart';

///
/// Shader hazySide
///
/// The effect that top&bottom edge blur
/// It's used in [TermPage]
///
/// Parameter:
/// - rect(Rect)
///
/// Return:
/// - Shader made from [LinearGradient]
///
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