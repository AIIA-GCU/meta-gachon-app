import 'package:flutter/material.dart';
import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/widgets/small_widgets.dart';

class Alarm extends StatefulWidget {
  const Alarm({super.key});

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(AppinIcon.back, color: MGcolor.base4),
          onPressed: () => Navigator.of(context).pop(),
        )
      ),
      body: FutureBuilder<List<Notice>?>(
        future: RestAPI.getNotices(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return ProgressWidget();
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                        '통신 속도가 너무 느려요!',
                        style: KR.subtitle4.copyWith(color: MGcolor.base3)
                    )
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data!
                        .map((e) => Message(notifi: e))
                        .toList()
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    '아직 알림이 없어요!',
                    style: KR.subtitle4.copyWith(color: MGcolor.base3)
                  )
                );
              }
          }
        }
      )
    );
  }
}

//메세지 위젯
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
              color: MGcolor.brandOrig,
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
                Text(notifi.content, style: KR.chat),
              ],
            ),
          ),

          /// 시간 메세지에 추가
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

class Triangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = MGcolor.brandOrig
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height); // 좌하단
    path.lineTo(size.width, size.height); // 우하단
    path.lineTo(size.width, 0); // 우상단 (대각선의 시작점)
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
