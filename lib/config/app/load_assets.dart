///
/// load_assets.dart
/// 2024.03.07
/// by. @protaku
///
/// Change
/// - Added comments
///
/// Content
/// [*] Class:
///   - MGIcon
///   - MGLogo
///   - ImgPath
///

import 'package:flutter/material.dart';

class MGIcon {
  MGIcon._();

  static const _kFontFam = 'MGIcon';
  static const String? _kFontPkg = null;

  // 수정 아이콘
  static const IconData edit = IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // 비밀번호 보호 (안 보이는 상태)
  static const IconData eyeOff = IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // 비밀번호 보호 (보이는 상태)
  static const IconData eyeOn = IconData(0xe805, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // 앞으로가기 아이콘
  static const IconData go = IconData(0xe806, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // 홈 페이지 아이콘
  static const IconData home = IconData(0xe807, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // 마이 페이지 아이콘
  static const IconData my = IconData(0xe808, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // 알림 아이콘
  static const IconData not = IconData(0xe809, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // 추가 아이콘
  static const IconData plus = IconData(0xe80a, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // 예약 리스트 페이지 아이콘
  static const IconData res = IconData(0xe80b, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // 설정 아이콘
  static const IconData setting = IconData(0xe80c, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // 뒤로가기 아이콘
  static const IconData back = IconData(0xe80d, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // 카메라 아이콘
  static const IconData camera = IconData(0xe80e, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // 인증 아이콘
  static const IconData cert = IconData(0xe80f, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // 취소 아이콘
  static const IconData cross = IconData(0xe811, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}

class MGLogo {
  MGLogo._();

  static const _kFontFam = 'MGIcon';
  static const String? _kFontPkg = null;

  // 앱 로고 + 타이틀 (가로 배치)
  static const IconData logoTypoHori = IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // 앱 로고 + 타이틀 (세로 배치)
  static const IconData logoTypoVert = IconData(0xe810, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // 타이틀만
  static const IconData typo = IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // 로고만
  static const IconData logo = IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}

class ImgPath {
  ImgPath._();

  // 온보딩 이미지
  static const String onBoarding = "assets/images/on_boarding.png";

  // AIIA 심볼 (색상)
  static const String aiiaColor = "assets/images/aiia_color.png";

  // 학교 심볼
  static const String schoolSymbol = "assets/images/school_symbol.png";

  // 서비스 선택 버튼 이미지
  static const String lecture = "assets/images/lecture.png";
  static const String aiSpace = "assets/images/aispace.png";
  static const String computer = "assets/images/computer.png";

  // 회원 등급
  static const String grayLv = "assets/images/warning.png";
  static const String stoneLv = "assets/images/caution.png";
  static const String cobaltLv = "assets/images/default.png";
  static const String skyLv = "assets/images/good.png";
  static const String aquaLv = "assets/images/vip.png";

  // 홈 페이지에 사용되는 이미지
  static const String home1 = "assets/images/home_img1.png";
  static const String home2 = "assets/images/home_img2.png";
  static const String home3 = "assets/images/home_img3.png";
  static const String home4 = "assets/images/home_img4.png";
  static const String home5 = "assets/images/home_img5.png";

  // 예약 페이지 팝업 이미지
  static const String reserve1 = "assets/images/graphic_class.png";
  static const String reserve2 = "assets/images/graphic_gpu.png";
  static const String reserve3 = "assets/images/graphic_meta.png";
}

