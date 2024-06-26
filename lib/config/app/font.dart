import 'package:flutter/material.dart';

import 'interface.dart';

/// 한글 폰트
/// - NotoSansKR
class KR {
  KR._();

  static TextStyle title1 = TextStyle(fontSize: ratio.height * 28, fontWeight: FontWeight.w500, fontFamily: 'Ko');
  static TextStyle title2 = TextStyle(fontSize: ratio.height * 24, fontWeight: FontWeight.w500, fontFamily: 'Ko');
  static TextStyle title3 = TextStyle(fontSize: ratio.height * 22, fontWeight: FontWeight.w400, fontFamily: 'Ko');
  static TextStyle subtitle0 = TextStyle(fontSize: ratio.height * 18, fontWeight: FontWeight.w700, fontFamily: 'Ko');
  static TextStyle subtitle1 = TextStyle(fontSize: ratio.height * 18, fontWeight: FontWeight.w500, fontFamily: 'Ko');
  static TextStyle subtitle2 = TextStyle(fontSize: ratio.height * 18, fontWeight: FontWeight.w400, fontFamily: 'Ko');
  static TextStyle subtitle3 = TextStyle(fontSize: ratio.height * 16, fontWeight: FontWeight.w500, fontFamily: 'Ko');
  static TextStyle subtitle4 = TextStyle(fontSize: ratio.height * 16, fontWeight: FontWeight.w400, fontFamily: 'Ko');
  static TextStyle parag1 = TextStyle(fontSize: ratio.height * 14, fontWeight: FontWeight.w500, fontFamily: 'Ko');
  static TextStyle parag2 = TextStyle(fontSize: ratio.height * 14, fontWeight: FontWeight.w400, fontFamily: 'Ko');
  static TextStyle label1 = TextStyle(fontSize: ratio.height * 12, fontWeight: FontWeight.w500, fontFamily: 'Ko');
  static TextStyle label2 = TextStyle(fontSize: ratio.height * 12, fontWeight: FontWeight.w400, fontFamily: 'Ko');
  static TextStyle label3 = TextStyle(fontSize: ratio.height * 11, fontWeight: FontWeight.w400, fontFamily: 'Ko');
  static TextStyle chattitle = TextStyle(fontSize: ratio.height * 16, fontWeight: FontWeight.w600, fontFamily: 'Ko', color: Colors.white);
  static TextStyle chat = TextStyle(fontSize: ratio.height * 14, fontWeight: FontWeight.w400, fontFamily: 'Ko', color: Colors.white);
  static TextStyle chattime = TextStyle(fontSize: ratio.height * 12, fontFamily: 'Ko', color: Colors.grey);
}

/// 영문 & 숫자 폰트
/// - Inter
class EN {
  EN._();

  static TextStyle title1 = TextStyle(fontSize: ratio.height * 28, fontWeight: FontWeight.w500, fontFamily: 'En');
  static TextStyle title2 = TextStyle(fontSize: ratio.height * 22, fontWeight: FontWeight.w400, fontFamily: 'En');
  static TextStyle subtitle1 = TextStyle(fontSize: ratio.height * 18, fontWeight: FontWeight.w400, fontFamily: 'En');
  static TextStyle subtitle2 = TextStyle(fontSize: ratio.height * 16, fontWeight: FontWeight.w400, fontFamily: 'En');
  static TextStyle parag1 = TextStyle(fontSize: ratio.height * 14, fontWeight: FontWeight.w500, fontFamily: 'En');
  static TextStyle parag2 = TextStyle(fontSize: ratio.height * 14, fontWeight: FontWeight.w400, fontFamily: 'En');
  static TextStyle label1 = TextStyle(fontSize: ratio.height * 12, fontWeight: FontWeight.w400, fontFamily: 'En');
  static TextStyle label2 = TextStyle(fontSize: ratio.height * 11, fontWeight: FontWeight.w400, fontFamily: 'En');
}