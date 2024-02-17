
import 'package:flutter/material.dart';

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