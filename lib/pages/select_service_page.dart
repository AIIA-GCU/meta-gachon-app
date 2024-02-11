import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/pages/main_frame.dart';

class SelectingServicePage extends StatelessWidget {
  const SelectingServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ratio.width * 16),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이용하실 예약 서비스를\n선택해주세요.',
              style: KR.title3,
            ),

            SizedBox(height: ratio.height * 68),

            _button(context, ServiceType.lectureRoom),

            SizedBox(height: ratio.height * 20),

            _button(context, ServiceType.aiSpace),

            SizedBox(height: ratio.height * 20),
            
            _button(context, ServiceType.computer)
          ]
        ),
      ),
    );
  }
  
  Widget _button(BuildContext context, ServiceType type) {
    late String path, name;
    switch (type) {
      case ServiceType.aiSpace:
        path = ImgPath.ai_space;
        name = "AI 스페이스";
        break;
      case ServiceType.lectureRoom:
        path = ImgPath.lecture;
        name = "강의실";
        break;
      case ServiceType.computer:
        path = ImgPath.computer;
        name = "GPU 컴퓨터";
        break;
    }
    return InkWell(
      onTap: () {
        service = type;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainFrame()));
      },
      splashColor: Colors.white.withOpacity(0.6),
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        height: ratio.height * 140,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
                image: AssetImage(path),
                fit: BoxFit.fitWidth
            )
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'Ko',
              color: Colors.white,
              fontWeight: FontWeight.w700,
            )
          ),
        ),
      ),
    );
  }
}
