import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/animation.dart';
import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';

class Alarm extends StatefulWidget {
  const Alarm({super.key});

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  static List<String> messages = [
    "예약을 완료했습니다!\n1월3일 13:00-15:00\n404-1호",
    "아직 인증을 올리지 않았습니다.\n어서 강의실 이용 사진을 올려주세요!",
    "사용중인 회의실의 이후 예약자가 없습니다!\n1시간을 추가 예약하시겠습니까?"
  ];
  
  late List<Widget> msgs;
  
  @override
  void initState() {
    super.initState();
    msgs = notifis.map((e) => msg(notifi: e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(AppinIcon.back, color: MGcolor.base4),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
              onPressed: () => setState(() {
                  notifis.add(Notifi('예약', messages[Random().nextInt(2)]));
                  msgs.add(msg(notifi: notifis.last));
                }),
              icon: Icon(
                Icons.add,
                color: Colors.black,
              )
          )
        ],
      ),
      body: msgs.isEmpty
          ? Center(
              child: Text(
                '아직 알림이 없어요!',
                style: KR.subtitle3.copyWith(
                  color: MGcolor.base3,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ratio.width * 16,
                vertical: ratio.height * 16
              ),
              child: Column(
                children: List.generate(msgs.length, (index) => msgs[index]),
              ),
            ),
    );
  }
}

//메세지 위젯
class msg extends StatelessWidget {
  const msg({super.key, required this.notifi});
  
  final Notifi notifi;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ratio.height * 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomPaint(
            painter: Triangle(),
            size: Size(
              ratio.width * 20,
              ratio.height * 20
            ), // 삼각형 크기
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10
            ),
            decoration: BoxDecoration(
              color: MGcolor.brand_orig,
              borderRadius: BorderRadiusDirectional.only(
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
                Text(notifi.message, style: KR.chat),
              ],
            ),
          ),

          /// 시간 메세지에 추가
          Padding(
            padding: EdgeInsets.only(
              left: ratio.width * 5,
              bottom: ratio.height * 2
            ),
            child: Text(
              MDHm_format.format(DateTime.now()),
              style: KR.chattime,
            ),
          )
        ],
      ),
    );
  }
}

class Triangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = MGcolor.brand_orig
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height); // 좌하단
    path.lineTo(size.width, size.height); // 우하단
    path.lineTo(size.width, 0); // 우상단 (대각선의 시작점)
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
