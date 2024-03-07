///
/// animation.dart
/// 2024.03.07
/// by. @protaku
///
/// Animations using in app
///
/// Change
/// - Add comment
///
/// Content
/// [*] Function
///   - slideLeft2Right
///   - slideRight2Left
///

import 'package:flutter/material.dart';

///
/// Widget slideLeft2Right
///
/// This function return [SlideTransition].
/// The slide effect look like moving a widget from left to right
///
/// Parameter
/// - context([BuildContext]):
///   Parent widget's one
/// - animation([Animation]<double\>):
///   normal animation
/// - secondaryAnimation([Animation]<double\>):
///   animation's reverse.
///   using to back to the prior state.
/// - child(Widget):
///   The widget to adapt an animation
///
/// ### Return
/// - [SlideTransition]:
///   the widget applied slide animation
///
Widget slideLeft2Right(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child
    ) {
  return SlideTransition(
      position: animation.drive(
          Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.ease))
      ),
      child: child
  );
}

///
/// Widget slideRight2Left
///
/// This function return [SlideTransition].
/// The slide effect look like moving a widget from right to left
///
/// Parameter
/// - context([BuildContext]):
///   Parent widget's one
/// - animation([Animation]<double\>):
///   normal animation
/// - secondaryAnimation([Animation]<double\>):
///   animation's reverse.
///   using to back to the prior state.
/// - child(Widget):
///   The widget to adapt an animation
///
/// ### Return
/// - [SlideTransition]:
///   the widget applied slide animation
///
Widget slideRigth2Left(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child
    ) {
  return SlideTransition(
      position: animation.drive(
          Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.ease))
      ),
      child: child
  );
}