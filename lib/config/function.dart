///
/// 유용한 함수들 모음
///

import 'package:flutter/cupertino.dart';

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