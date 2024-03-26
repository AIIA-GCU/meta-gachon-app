import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/app/my_page_icons.dart';
import 'package:mata_gachon/config/server/_export.dart';
import 'package:mata_gachon/pages/sign_in_page.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'term_page.dart';
import 'setting_page.dart';
import '../config/server/session.dart';
import 'my_admission_list_page.dart';
import '../widgets/button.dart';
import '../widgets/layout.dart';
import '../widgets/popup_widgets.dart';




class MyPage extends StatefulWidget {
  const MyPage({super.key, required this.moveToReserList});

  final VoidCallback moveToReserList;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(ratio.width * 16, 0,
          ratio.width * 16, ratio.height * 23),
      child: Column(children: [
        /// 프로필
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
              children: [
            /// 이미지
            /// Todo: 바꿀 필요 있음
            Image.asset('assets/images/mypage.png', width: ratio.width * 120, height: ratio.height * 120,),

            SizedBox(width: ratio.width * 10),

            /// 텍스트
            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ratio.height * 10),
                  Text(myInfo.name, style: KR.title2),
                  SizedBox(height: ratio.height * 11),
                  Text(myInfo.stuNum.toString(),
                      style: KR.subtitle4.copyWith(color: MGColor.base3)),
                  Text('AI소프트웨어학부',
                      style: KR.subtitle4.copyWith(
                          color: MGColor.base3, letterSpacing: 0.32)),
                  SizedBox(height: ratio.height * 20),

                ])
          ]),
        ),
        Row(
          children: [
            TileButtonCard(items: [
              ///내 예약
              TileButton(
                  onTap: widget.moveToReserList,
                  padding: EdgeInsets.symmetric(
                      vertical: 2, horizontal: ratio.width * 33),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(MGIcon.res,
                        color: MGColor.brandPrimary,
                          size: ratio.width * 26),


                      SizedBox(width: ratio.width * 16),
                      SizedBox(height: ratio.height * 10),
                      Text('내 예약',
                          style: KR.subtitle4.copyWith(color: MGColor.base2))
                    ],
                  )),
            ]),
            SizedBox(width: ratio.width * 12),
            TileButtonCard(items: [
              ///내 인증
              TileButton(
                  onTap: () => _floatMyAdmissionPage(context),
                  padding: EdgeInsets.symmetric(
                      vertical: 2, horizontal: ratio.width * 33),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(My_page.mycertification,
                        color: MGColor.brandPrimary,
                        size: ratio.width * 26,),
                      SizedBox(width: ratio.width * 16),
                      SizedBox(height: ratio.height * 10),
                      Text('내 인증',
                          style: KR.subtitle4.copyWith(color: MGColor.base2))
                    ],
                  ))
            ]),
            SizedBox(width: ratio.width * 12),
            TileButtonCard(items: [
              ///내 등급
              TileButton(
                  onTap: () => _showGradePopup(context),
                  padding: EdgeInsets.symmetric(
                      vertical: 2, horizontal: ratio.width * 33),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        My_page.mygrade,
                        color: MGColor.brandPrimary,
                        size: ratio.width * 26,
                      ),
                      SizedBox(width: ratio.width * 16),
                      SizedBox(height: ratio.height * 10),
                      Text('내 등급',
                          style: KR.subtitle4.copyWith(color: MGColor.base2))
                    ],
                  ))
            ]),
          ],
        ),
        SizedBox(height: ratio.height * 22),
        TileButton(
            onTap: () =>
                launchUrl(Uri.parse('https://www.gachon.ac.kr/kor/index.do')),
            padding:
            EdgeInsets.fromLTRB(ratio.width * 13, 12, ratio.width * 18, 12),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              Icon(
               My_page.homepage,
                color: MGColor.base3,
              ),
              SizedBox(width: ratio.width * 16),
              Text('학교 홈페이지 바로가기',
                  style: KR.subtitle3.copyWith(color: MGColor.base3)),
              Spacer(),
              Transform.rotate(
                  angle: pi,
                  child: Icon(MGIcon.back,
                      size: ratio.width * 24, color: MGColor.base4))
            ])),
        TileButton(
            onTap: () =>
                launchUrl(Uri.parse('https://www.gachon.ac.kr/kor/index.do')),
            padding:
            EdgeInsets.fromLTRB(ratio.width * 13, 12, ratio.width * 18, 12),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              Icon(My_page.cybercampus, color: MGColor.base3),

              SizedBox(width: ratio.width * 16),
              Text('사이버 캠퍼스 바로가기',
                  style: KR.subtitle3.copyWith(color: MGColor.base3)),
              Spacer(),
              Transform.rotate(
                  angle: pi,
                  child: Icon(MGIcon.back,
                      size: ratio.width * 24, color: MGColor.base4))
            ])),

        /// 설정
        TileButton(
            onTap: () => _floatSettingPage(context),
            padding: EdgeInsets.fromLTRB(ratio.width * 13, 12, ratio.width * 18, 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  My_page.setting,
                  color: MGColor.base3,
                ),
                SizedBox(width: ratio.width * 16),
                Text('설정', style: KR.subtitle3.copyWith(color: MGColor.base3)),
                Spacer(),
                Transform.rotate(
                    angle: pi,
                    child: Icon(MGIcon.back,
                        size: ratio.width * 24, color: MGColor.base4))
              ],
            )),
        TileButton(
            onTap: () => _trySignOut(context),
            padding: EdgeInsets.fromLTRB(ratio.width * 13, 12, ratio.width * 18, 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  My_page.logout,
                  color: MGColor.base3,
                ),
                SizedBox(width: ratio.width * 16),
                Text('로그아웃', style: KR.subtitle3.copyWith(color: MGColor.base3)),
                Spacer(),
                Transform.rotate(
                    angle: pi,
                    child: Icon(MGIcon.back,
                        size: ratio.width * 24, color: MGColor.base4))
              ],
            )),
        SizedBox(height: ratio.height * 16),
        Divider(
          thickness: 0.3,
          color: MGColor.base3,
        ),
        SizedBox(height: ratio.height * 16),


        /// 앱 정보
        TileButton(
          onTap: () => _floatTermPage(context, Term.usingService),
          alignment: Alignment.centerLeft,
          padding:
          EdgeInsets.symmetric(vertical: 7, horizontal: ratio.width * 3),
          child: Text('이용약관', style: KR.parag2.copyWith(color: MGColor.base3)),
        ),
        TileButton(
            onTap: () =>
                _floatTermPage(context, Term.personalInfomationCollection),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
                vertical: 11, horizontal: ratio.width * 3),
            child: Text('개인정보 수집 및 이용',
                style: KR.parag2.copyWith(color: MGColor.base3))),
        TileButton(
          padding:
          EdgeInsets.symmetric(vertical: 11, horizontal: ratio.width * 3),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('버전', style: KR.parag2.copyWith(color: MGColor.base3)),
              Text('1.1.0', style: EN.parag2.copyWith(color: MGColor.base3)),
            ],
          ),
        ),
        SizedBox(height: ratio.height * 30),

      ]),
    );
  }

  void _showGradePopup(BuildContext context) {
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.25),
        builder: (context) => const GradePopup());
  }

  void _floatMyAdmissionPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MyAdmissionPage()));
  }

  void _floatSettingPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SettingPage()));
  }

  void _floatTermPage(BuildContext context, Term term) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => TermPage(term: term)));
  }

  void _trySignOut(BuildContext context) {
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.25),
        builder: (context) => AlertPopup(
            title: '로그아웃 하시겠습니까?',
            agreeMsg: '로그아웃',
            onAgreed: () async {
              setState(() {
                _loading = true;
                Navigator.pop(context);
              });

              late Future func;
              try {
                if (!await Session().clear()) {
                  throw Exception('\n[Error] about Session');
                }
                func = showDialog(
                    context: context,
                    barrierColor: Colors.black.withOpacity(0.25),
                    builder: (ctx) => CommentPopup(
                        title: "로그아웃 되었습니다!",
                        onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => SignInPage()),
                                (route) => false
                        )
                    )
                );
              } catch(_) {
                func = showDialog(
                    context: context,
                    barrierColor: Colors.black.withOpacity(0.25),
                    builder: (context) => CommentPopup(
                        title: "[400] 서버 통신에 문제가 있습니다",
                        onPressed: () => Navigator.pop(context)
                    )
                );
              }

              setState(() {
                _loading = false;
                func;
              });
            }
        )
    );
  }
}

