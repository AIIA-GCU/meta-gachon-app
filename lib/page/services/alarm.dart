import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';

// 알람 페이지를 위한 StatefulWidget
class Alarm extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

// 알람 페이지를 위한 State 클래스
class _AlarmPageState extends State<Alarm> {
  List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    // 화면 크기 가져오기
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MGcolor.base6, // 배경색과 일치
        leading: IconButton(
          icon: Icon(AppinIcon.back, color: MGcolor.base4),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            color: MGcolor.base6,
          ),
          // AppBar 아래에 ListView로 메시지 표시
          Positioned(
            top: screenHeight / 4 - 200, // 채팅 올라오는 listview 크기 조절
            right: 0,
            left: screenWidth / 2 - 180,
            bottom: 0,
            child: messages.isEmpty
                ? Center(
                    child: Text(
                      '아직 알림이 없어요!',
                      style: KR.subtitle3.copyWith(
                        color: MGcolor.base3,
                      ),
                    ),
                  )
                : ListView(
                    children: messages
                        .map((message) => SpeechBubble(
                              title: '예약', //title 제목은 예약 고정
                              content: message, dateTime: '11/16 17:00',
                            ))
                        .toList(),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 버튼을 누르면 새로운 메시지 추가
          setState(() {
            messages.add('예약을 완료했습니다!'); // 메시지 내용
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// 말풍선을 위한 위젯
class SpeechBubble extends StatelessWidget {
  final String title;
  final String content;
  final String dateTime; // 날짜와 시간을 위한 새로운 변수 추가

  SpeechBubble({
    required this.title,
    required this.content,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Stack(
        children: [
          CustomPaint(
            painter: SpeechBubblePainter(),
            child: Padding(
              padding: EdgeInsets.only(left: 14.0, top: 10),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: KR.subtitle3.copyWith(
                        color: MGcolor.btn_inactive,
                      ),
                    ),
                    SizedBox(height: 27.0),
                    Text(
                      content,
                      style: KR.label1.copyWith(
                        color: MGcolor.btn_inactive,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 150,
            top: 60,
            child: Text(
              dateTime, //말풍선 외부에 날짜와 시간 표시
              style: KR.label1.copyWith(
                color: MGcolor.base3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//말풍선 꾸미기를 위한 CustomPainter 클래스
class SpeechBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MGcolor.btn_active
      ..style = PaintingStyle.fill;

    final tailLength = 40.0;
    //주의!!!: 25 , 48은 3개 똑같이 작성해야 삼각형이 깨지지 않음
    final path = Path()
      ..moveTo(24, size.height + 4) // Starting point at the bottom-left corner
      ..lineTo(
          -tailLength + 24, size.height + 4) // Extend left to create the tail
      ..lineTo(
          24,
          size.height -
              tailLength +
              4) // Move up for the tail (forming a right-angled triangle)
      ..close();

    // 말풍선의 본문을 나타내는 둥근 사각형 그리기
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromPoints(
            Offset(0, 0), Offset(size.width * 1.0 + 10, size.height * 3 - 130)),
        topLeft: Radius.circular(12.0),
        topRight: Radius.circular(12.0),
        bottomLeft: Radius.circular(12.0),
        bottomRight: Radius.circular(12.0),
      ),
      paint,
    );
    // 말풍선의 삼각형 꼬리 그리기
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
