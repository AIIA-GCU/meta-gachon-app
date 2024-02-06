///
/// 앱의 기초 설정
/// - 색상
/// - 텍스트 스타일
/// - 앱 내부의 아이콘 및 이미지
/// - 앱 로고 및 아이콘
///
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';

/// 비율
late Size ratio;

/// 오늘 날짜
late final String today;

/// 카메라
late final CameraDescription camera;

/// 학교 바코드
const String BARCODE = "12016091019242582042";

///
/// 색깔
///
class MGcolor {
  MGcolor._();

  static const Color brandDeep = Color(0xFF0B3199);
  static const Color brandOrig = Color(0xFF1762DB);
  static const Color brandLight = Color(0xFF4AB6F2);

  static const Color systemError = Color(0xFFE03616);
  static const Color systemOk = Color(0xFF00AF54);
  static const Color barrier = Color(0x40000000);

  static const Color base1 = Color(0xFF000000);
  static const Color base2 = Color(0xFF333232);
  static const Color base3 = Color(0xFF7C7C7C);
  static const Color base4 = Color(0xFFABABAB);
  static const Color base5 = Color(0xFFC9C9C9);
  static const Color base6 = Color(0xFFDDDDDD);
  static const Color base7 = Color(0xFFEDEEF1);
  static const Color base8 = Color(0xFFE7E7E7);
  static const Color base9 = Color(0xFFF4F5F8);
  static const Color base10 = Color(0xFFEDEEF1);

  static const Color btn_active = Color(0xFF1762DB);
  static const Color btn_inactive = Color(0xFFE3EDFD);
}

///
/// 텍스트 스타일
/// - 크기(size), 가중치(weight), 종류(family)
///
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

///
/// 앱 내부의 아이콘 및 이미지
///
class AppinIcon {
  AppinIcon._();

  static const _kFontFam = 'MGIcon';
  static const String? _kFontPkg = null;

  static const IconData edit = IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData eye_off = IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData eye_on = IconData(0xe805, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData go = IconData(0xe806, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData home = IconData(0xe807, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData my = IconData(0xe808, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData not = IconData(0xe809, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData plus = IconData(0xe80a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData res = IconData(0xe80b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData setting = IconData(0xe80c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData back = IconData(0xe80d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData camera = IconData(0xe80e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cert = IconData(0xe80f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cross = IconData(0xe811, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
class ImgPath {
  ImgPath._();

  static const String on_boarding = "assets/images/on_boarding.png";
  static const String aiia_color = "assets/images/aiia_color.png";

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

  static const IconData logo_typo_hori = IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData logo_typo_vert = IconData(0xe810, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData logo_typo_only = IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData logo = IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}

///
/// Date Format
///
final std1_format = DateFormat('yyyy-MM-dd-HH:mm');
final std2_format = DateFormat('yyyy-MM-dd');
final alarm_format = DateFormat('MM/dd HH:mm');
final date1_format = DateFormat('yyyy. MM. dd EEE');
final date2_format = DateFormat('yyyy.MM.dd');
final time_format = DateFormat('HH:mm');

///
/// StreamController
///
final StreamController<StreamType> listListener = StreamController<StreamType>.broadcast();
enum StreamType { reservate, admit }

/// 약관
enum Term { usingService, personalInfomationCollection }
const String USING_SERVICE_TERM = """제 1 조 (목적)

본 약관은 AIIA의 제반 서비스의 이용조건 및 절차에 관한 사항 및 기타 필요한 사항을 규정함을 목적으로 한다.



제 2 조 (용어의 정의)

본 약관에서 사용하는 용어는 다음과 같이 정의한다.

①회원 : 기본 회원 정보를 입력하였고, 회사와 서비스 이용계약을 체결하여 아이디를 부여받은 개인

②아이디(ID) : 회원식별과 회원의 서비스 이용을 위해 회원이 선정하고 회사가 승인하는 문자와 숫자의 조합

③비밀번호(Password) : 회원이 통신상의 자신의 비밀을 보호하기 위해 선정한 문자와 숫자의 조합

④해지 : 회사 또는 회원에 의한 이용계약의 종료



제 3 조 (약관의 공시 및 효력과 변경)

①본 약관은 회원가입 화면에 게시하여 공시하며 회사는 사정변경 및 영업상 중요한 사유가 있을 경우 약관을 변경할 수 있으며 변경된 약관은 공지사항을 통해 공시한다

②본 약관 및 차후 회사사정에 따라 변경된 약관은 이용자에게 공시함으로써 효력을 발생한다.



제 4 조 (약관 외 준칙)

본 약관에 명시되지 않은 사항이 전기통신기본법, 전기통신사업법, 정보통신촉진법, ‘전자상거래등에서의 소비자 보호에 관한 법률’, ‘약관의 규제에관한법률’, ‘전자거래기본법’, ‘전자서명법’, ‘정보통신망 이용촉진등에 관한 법률’, ‘소비자보호법’ 등 기타 관계 법령에 규정되어 있을 경우에는 그 규정을 따르도록 한다.



제 5 조 (이용신청)

①이용신청자가 회원가입 안내에서 본 약관과 개인정보보호정책에 동의하고 등록절차(회사의 소정 양식의 가입 신청서 작성)를 거쳐 '확인' 버튼을 누르면 이용신청을 할 수 있다.

②이용신청자는 반드시 실명과 실제 정보를 사용해야 하며 1개의 생년월일에 대하여 1건의 이용신청을 할 수 있다.

③실명이나 실제 정보를 입력하지 않은 이용자는 법적인 보호를 받을 수 없으며, 서비스 이용에 제한을 받을 수 있다.



제 6 조 (이용신청의 승낙)

①회사는 제5조에 따른 이용신청자에 대하여 제2항 및 제3항의 경우를 예외로 하여 서비스 이용을 승낙한다.

②회사는 아래 사항에 해당하는 경우에 그 제한사유가 해소될 때까지 승낙을 유보할 수 있다.

  가. 서비스 관련 설비에 여유가 없는 경우

  나. 기술상 지장이 있는 경우

  다. 기타 회사 사정상 필요하다고 인정되는 경우

③회사는 아래 사항에 해당하는 경우에 승낙을 하지 않을 수 있다.

  가. 다른 사람의 명의를 사용하여 신청한 경우

  나. 이용자 정보를 허위로 기재하여 신청한 경우

  다. 사회의 안녕질서 또는 미풍양속을 저해할 목적으로 신청한 경우

  라. 기타 회사가 정한 이용신청 요건이 미비한 경우



제 7 조 (회사의 의무)

①회사는 사이트를 안정적이고 지속적으로 운영할 의무가 있다.

②회사는 이용자로부터 제기되는 의견이나 불만이 정당하다고 인정될 경우에는 즉시 처리해야 한다. 단, 즉시 처리가 곤란한 경우에는 이용자에게 그 사유와 처리일정을 공지사항 또는 전자우편을 통해 통보해야 한다.

③제1항의 경우 수사상의 목적으로 관계기관 및 정보통신윤리위원회의 요청이 있거나 영장 제시가 있는 경우, 기타 관계 법령에 의한 경우는 예외로 한다.



제 8 조 (이용자의 의무)

①이용자는 본 약관 및 회사의 공지사항, 사이트 이용안내 등을 숙지하고 준수해야 하며 기타 회사의 업무에 방해되는 행위를 해서는 안된다.

②이용자는 회사의 사전 승인 없이 본 사이트를 이용해 어떠한 영리행위도 할 수 없다.

③이용자는 본 사이트를 통해 얻는 정보를 회사의 사전 승낙 없이 복사, 복제, 변경, 번역, 출판, 방송 및 기타의 방법으로 사용하거나 이를 타인에게 제공할 수 없다.



제 9 조 (서비스 이용)

①이용자는 본 약관의 규정된 사항을 준수해 사이트를 이용한다.

②본 약관에 명시되지 않은 서비스 이용에 관한 사항은 회사가 정해 '공지사항'에 게시하거나 또는 별도로 공지하는 내용에 따른다.



제 10 조 (정보의 제공)

본 사이트는 회원이 서비스 이용 중 필요하다고 인정되는 다양한 정보에 대하여 전자메일이나 서신우편 등의 방법으로 회원에게 정보를 제공할 수 있다.



제 12 조 (서비스 이용의 제한)

본 사이트 이용 및 행위가 다음 각 항에 해당하는 경우 회사는 해당 이용자의 이용을 제한할 수 있다.

①공공질서 및 미풍양속, 기타 사회질서를 해하는 경우

②범죄행위를 목적으로 하거나 기타 범죄행위와 관련된다고 객관적으로 인정되는 경우

③타인의 명예를 손상시키거나 타인의 서비스 이용을 현저히 저해하는 경우

④타인의 의사에 반하는 내용이나 광고성 정보 등을 지속적으로 전송하는 경우

⑤해킹 및 컴퓨터 바이러스 유포 등으로 서비스의 건전한 운영을 저해하는 경우

⑥다른 이용자 또는 제3자의 지적재산권을 침해하거나 지적재산권자가 지적 재산권의 침해를 주장할 수 있다고 판단되는 경우

⑦타인의 아이디 및 비밀번호를 도용한 경우

⑧기타 관계 법령에 위배되는 경우 및 회사가 이용자로서 부적당하다고 판단한 경우



제 12 조 (서비스 제공의 중지)

회사는 다음 각 호에 해당하는 경우 서비스의 전부 또는 일부의 제공을 중지할 수 있다.

①전기통신사업법 상에 규정된 기간통신 사업자 또는 인터넷 망 사업자가 서비스를 중지했을 경우

②정전으로 서비스 제공이 불가능할 경우

③설비의 이전, 보수 또는 공사로 인해 부득이한 경우

④서비스 설비의 장애 또는 서비스 이용의 폭주 등으로 정상적인 서비스 제공이 어려운 경우

⑤전시, 사변, 천재지변 또는 이에 준하는 국가비상사태가 발생하거나 발생할 우려가 있는 경우



제 13 조 (게시물 관리)

회사는 건전한 통신문화 정착과 효율적인 사이트 운영을 위하여 이용자가 게시하거나 제공하는 자료가 제12조에 해당한다고 판단되는 경우에 임의로 삭제, 자료이동, 등록거부를 할 수 있다.



제 14 조 (서비스 이용 책임)

이용자는 회사에서 권한 있는 사원이 서명한 명시적인 서면에 구체적으로 허용한 경우를 제외하고는 서비스를 이용하여 불법상품을 판매하는 영업활동을 할 수 없으며 특히 해킹, 돈벌기 광고, 음란 사이트를 통한 상업행위, 상용 S/W 불법제공 등을 할 수 없다. 이를 어기고 발생한 영업활동의 결과 및 손실, 관계기관에 의한 구속 등 법적 조치 등에 관해서는 회사가 책임을 지지 않는다.



제 15 조 (면책 및 손해배상)

①천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 회사의 서비스 제공 책임이 면제된다.

②회사는 이용자간 또는 이용자와 제3자간의 상호거래 관계에서 발생되는 결과에 대하여 어떠한 책임도 부담하지 않는다.

③회사는 이용자가 게시판에 게재한 정보, 자료, 내용 등에 관하여 사실의 정확성, 신뢰도 등에 어떠한 책임도 부담하지 않으며 이용자는 본인의 책임 아래 본 사이트를 이용해야 한다.

④이용자가 게시 또는 전송한 자료 등에 관하여 손해가 발생하거나 자료의 취사선택, 기타 무료로 제공되는 서비스 이용과 관련해 어떠한 불이익이 발생하더라도 이에 대한 모든 책임은 이용자에게 있다.

⑤아이디와 비밀번호의 관리 및 이용자의 부주의로 인하여 발생되는 손해 또는 제3자에 의한 부정사용 등에 대한 책임은 이용자에게 있다.

⑥이용자가 본 약관의 규정을 위반함으로써 회사에 손해가 발생하는 경우 이 약관을 위반한 이용자는 회사에 발생한 모든 손해를 배상해야 하며 동 손해로부터 회사를 면책시켜야 한다.



제 16 조 (개인신용정보 제공 및 활용에 대한 동의서)

회사가 회원 가입과 관련해 취득한 개인 신용 정보는 신용정보의 이용 및 보호에 관한 법률 제23조의 규정에 따라 타인에게 제공 및 활용 시 이용자의 동의를 얻어야 한다. 이용자의 동의는 회사가 회원으로 가입한 이용자의  신용정보를 신용정보기관, 신용정보업자 및 기타 이용자 등에게 제공해 이용자의 신용을 판단하기 위한 자료로서 활용하거나 공공기관에서 정책자료로 활용하는데 동의하는 것으로 간주한다.



제 17 조 (분쟁의 해결)

①회사와 이용자는 본 사이트 이용과 관련해 발생한 분쟁을 원만하게 해결하기 위하여 필요한 모든 노력을 해야 한다.

②제1항의 규정에도 불구하고 동 분쟁으로 인하여 소송이 제기될 경우 동 소송은 회사의 본사 소재지를 관할하는 법원의 관할로 본다.""";
const String PERSONAL_INFORMATION_COLLECTION_TERM = """이용자 식별 및 본인여부 확인을 위해 이용자의 아이디, 이름, 비밀번호 정보를 회원  탈퇴 시까지 보유한다.

고객서비스 이용에 관한 통지, 이용자 식별을 위해 연락처 (이메일 및 휴대전화번호)를 회원 탈퇴 시까지 보유한다.""";

Shader hazySide(Rect rect) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF4F5F8),
      Colors.transparent,
      Colors.transparent,
      Color(0xFFF4F5F8)
    ],
    stops: [0.0, 0.121212, 0.878787, 1.0],
  ).createShader(rect);
}