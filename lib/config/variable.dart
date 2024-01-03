///
/// 앱의 기초 설정
/// - 색상
/// - 텍스트 스타일
/// - 앱 내부의 아이콘 및 이미지
/// - 앱 로고 및 아이콘
///
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 비율
late double ratio;

///
/// 색깔
///
class MGcolor {
  MGcolor._();

  static const Color brand_deep = Color(0xFF0B3199);
  static const Color brand_orig = Color(0xFF1762DB);
  static const Color brand_light = Color(0xFF4AB6F2);

  static const Color system_error = Color(0xFFE03616);
  static const Color system_ok = Color(0xFF00AF54);

  static const Color base1 = Color(0xFF000000);
  static const Color base2 = Color(0xFF333232);
  static const Color base3 = Color(0xFF7C7C7C);
  static const Color base4 = Color(0xFFABABAB);
  static const Color base5 = Color(0xFFDDDDDD);
  static const Color base6 = Color(0xFFEDEEF1);
  static const Color base7 = Color(0xFFE7E7E7);
  static const Color base8 = Color(0xFFF4F5F8);

  static const Color btn_active = Color(0xFF1762DB);
  static const Color btn_inactive = Color(0xFFE3EDFD);
}

///
/// 텍스트 스타일
/// - 크기(size), 가중치(weight), 종류(family)
///
class KR {
  KR._();

  static const TextStyle title1 = TextStyle(fontSize: 28, fontWeight: FontWeight.w500, fontFamily: 'Ko');
  static const TextStyle title2 = TextStyle(fontSize: 22, fontWeight: FontWeight.w400, fontFamily: 'Ko');
  static const TextStyle subtitle1 = TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'Ko');
  static const TextStyle subtitle2 = TextStyle(fontSize: 18, fontWeight: FontWeight.w400, fontFamily: 'Ko');
  static const TextStyle subtitle3 = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Ko');
  static const TextStyle subtitle4 = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Ko');
  static const TextStyle parag1 = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Ko');
  static const TextStyle parag2 = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Ko');
  static const TextStyle label1 = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'Ko');
  static const TextStyle label2 = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Ko');
  static const TextStyle label3 = TextStyle(fontSize: 11, fontWeight: FontWeight.w400, fontFamily: 'Ko');
}
class EN {
  EN._();

  static const TextStyle title1 = TextStyle(fontSize: 28, fontWeight: FontWeight.w500, fontFamily: 'En');
  static const TextStyle title2 = TextStyle(fontSize: 22, fontWeight: FontWeight.w400, fontFamily: 'En');
  static const TextStyle subtitle1 = TextStyle(fontSize: 18, fontWeight: FontWeight.w400, fontFamily: 'En');
  static const TextStyle subtitle2 = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'En');
  static const TextStyle parag1 = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'En');
  static const TextStyle parag2 = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'En');
  static const TextStyle label1 = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'En');
  static const TextStyle label2 = TextStyle(fontSize: 11, fontWeight: FontWeight.w400, fontFamily: 'En');
}

///
/// 앱 내부의 아이콘 및 이미지
///
class AppinIcon {
  AppinIcon._();

  static const _kFontFam = 'MGIcon';
  static const String? _kFontPkg = null;

  static const IconData home = IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData res = IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cert = IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData back = IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData my = IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData edit = IconData(0xe805, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData eye_off = IconData(0xe806, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData setting = IconData(0xe807, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData eye_on = IconData(0xe809, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData not = IconData(0xe80a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
class ImgPath {
  ImgPath._();

  static const String on_boarding = "assets/images/on_boarding.png";

  static const String lv_warning = "assets/images/warning.png";
  static const String lv_caution = "assets/images/caution.png";
  static const String lv_default = "assets/images/default.png";
  static const String lv_good = "assets/images/good.png";
  static const String lv_vip = "assets/images/vip.png";

  static const String home_img1 = "assets/images/home_img1.png";
  static const String home_img2 = "assets/images/home_img2.png";
  static const String home_img3 = "assets/images/home_img3.png";
  static const String home_img4 = "assets/images/home_img4.png";
  static const String home_img5 = "assets/images/home_img5.png";
}

///
/// 앱 로고
///
class MGLogo {
  MGLogo._();

  static const _kFontFam = 'MGIcon';
  static const String? _kFontPkg = null;

  static const IconData logo_typo_hori = IconData(0xe80b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData logo_typo_vert = IconData(0xe80c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData logo_typo_only = IconData(0xe80d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData logo = IconData(0xe80e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}

///
/// Date Format
///
final yMdE_format = DateFormat('y.M.d EEE');
final Hm_format = DateFormat('H:m');