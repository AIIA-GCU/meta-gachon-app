///
/// layout.dart
/// 2024.03.07
/// by. @protaku
///
/// Change
/// - Added comments
///
/// Content
/// [*] Class:
///   - CustomContainer
///   - TileButtonCard
///

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';

import 'button.dart';

///
/// CustomContainer
///
/// In widget, title places at top-left and the other places at top-right
///
/// Parameter:
/// - [margin] ([EdgeInsets]):
///   Margin of box
/// - [content] ([Widget]):
///   Content of widget
/// - [additionalContent] ([List]<[Widget]>):
///   this content places at bottom
/// - [title] ([String]):
///   title of widget
/// - [height] ([double]):
///   Height of widget
///
class CustomContainer extends StatelessWidget {
  final EdgeInsets? margin;
  final Widget content;
  final List<Widget>? additionalContent;
  final String title;
  final double height;

  const CustomContainer({
    required this.title,
    required this.height,
    required this.content,
    this.additionalContent,
    this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(bottom: 12 * ratio.height),
      width: 358 * ratio.width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(children: [
        Positioned(
          left: 16 * ratio.width,
          top: 16,
          child: Text(title, style: KR.parag1),
        ),
        Positioned(
            left: 80 * ratio.width,
            top: 10,
            width: 262 * ratio.width,
            height: 32,
            child: content
        ),
        ...?additionalContent
      ]),
    );
  }
}

///
/// TileButtonCard
///
/// Parameter:
/// - [background] ([Color]):
///   Color of box
/// - [shape] ([ShapeBorder]):
///   Shape of box
/// - [margin] ([EdgeInsetsGeometry]):
///   Margin of box
/// - [padding] ([EdgeInsetsGeometry]):
///   Padding of box
/// - [items] ([List]<[String]>):
///   Content of widget
///
class TileButtonCard extends StatelessWidget {
  const TileButtonCard({
    super.key,
    this.background,
    this.shape,
    this.margin,
    this.padding,
    required this.items
  });

  final Color? background;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final List<TileButton> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin != null ? margin!
          : EdgeInsets.symmetric(vertical: ratio.height * 8),
      child: Material(
        color: background ?? Colors.white,
        shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: padding != null ? padding!
              : const EdgeInsets.symmetric(vertical: 8),
          child: Column(children: items),
        ),
      ),
    );
  }
}