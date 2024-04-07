import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ratio.height * 100,
      alignment: Alignment.bottomCenter,
      child: SizedBox(
          width: ratio.width * 40,
          height: ratio.width * 40,
          child: const CircularProgressIndicator(color: MGColor.base6)),
    );
  }
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Container(
      width: screen.width,
      height: screen.height,
      color: Colors.black.withOpacity(0.25),
      alignment: Alignment.center,
      child: SizedBox(
          width: ratio.width * 48,
          height: ratio.width * 48,
          child: const CircularProgressIndicator(color: Colors.white)),
    );
  }
}

class NotificationIcon extends StatefulWidget {
  const NotificationIcon({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<NotificationIcon> createState() => _NotificationIconState();
}
class _NotificationIconState extends State<NotificationIcon> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Stack(children: [
        const Icon(MGIcon.not, color: MGColor.base4, size: 24),
        // 읽지 않은 알림이 있을 때, 보이기
        FutureBuilder<bool?>(
          future: RestAPI.hasUnopenedNotice(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!) {
              return const Positioned(
                  top: 1,
                  left: 1,
                  child: CircleAvatar(
                      radius: 4,
                      backgroundColor: MGColor.base9,
                      child: CircleAvatar(
                        radius: 3,
                        backgroundColor: MGColor.systemError,
                      )
                  )
              );
            } else {
              return const SizedBox.shrink();
            }
          }
        )
      ]),
    );
  }
}