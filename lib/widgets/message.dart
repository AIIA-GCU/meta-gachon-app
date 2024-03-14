///
/// message.dart
/// 2024.03.09
/// by. @protaku
///
/// Change
/// - Added comments
///
/// Content
/// [*] Class
///   - Message
///   - _Triangle
///

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';

///
/// [Message]
///
/// To create speech bubble
///
/// Parameter:
/// - [notifi] ([Notice]):
///   Push notification by firebase FCM
///
class Message extends StatelessWidget {
  const Message({super.key, required this.notifi});

  final Notice notifi;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ratio.height * 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // left tail
          CustomPaint(
            painter: _Triangle(),
            size: Size(ratio.width * 20, ratio.height * 20)
          ),

          // round rectangle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: MGColor.brandPrimary,
              borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(12),
                topEnd: Radius.circular(12),
                bottomEnd: Radius.circular(12),
              ),
            ),
            constraints: BoxConstraints(maxWidth: ratio.width * 274),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notifi.category, style: KR.chattitle),
                SizedBox(height: ratio.height * 8),
                Text(notifi.content, style: KR.chat),
              ],
            ),
          ),

          // time
          Padding(
            padding: EdgeInsets.only(
                left: ratio.width * 5,
                bottom: ratio.height * 2
            ),
            child: Text(notifi.time, style: KR.chattime),
          )
        ],
      ),
    );
  }
}

///
/// _Triangle
///
/// To create the [Message]
/// This class draw triangle at bottom-left of [Message]
///
class _Triangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = MGColor.brandPrimary
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
