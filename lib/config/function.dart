///
/// 유용한 함수들 모음
///

import 'package:flutter/material.dart';

///
/// 유동적으로 위젯 사이즈 바꾸기
///
Size flexibleSize(BuildContext context, Size widgetSize) {
  final Size figmaDivice = Size(390, 895);
  final Size myDivice = MediaQuery.of(context).size;

  return Size(
      myDivice.width * widgetSize.width / figmaDivice.width,
      myDivice.height * widgetSize.height / figmaDivice.height
  );
}

///
/// 리스트 아래가 점점 뿌옇게 변하는 효과
///
Shader hazyBottom(Rect rect) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xFFF4F5F8), Color(0xFFF4F5F8)],
    stops: [0.90, 0.93, 1.0], // 10% purple, 80% transparent, 10% purple
  ).createShader(rect);
}