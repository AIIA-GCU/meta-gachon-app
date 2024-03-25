import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/app/my_page_icons.dart';
import 'package:mata_gachon/config/server/_export.dart';
import 'package:mata_gachon/pages/sign_in_page.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

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
      padding: EdgeInsets.fromLTRB(ratio.width * 16, ratio.height * 31,
          ratio.width * 16, ratio.height * 23),
      child: Column(children: [
        /// 프로필
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Material(
            color: Colors.white,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              /// 이미지
              /// Todo: 바꿀 필요 있음
              Container(
                width: ratio.width * 170,
                height: ratio.width * 170,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        image: myInfo.ratingImg,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter)),
              ),

              SizedBox(width: ratio.width * 9),

              /// 텍스트
              Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(myInfo.name, style: KR.title3),
                    SizedBox(height: ratio.height * 20),
                    Text('AI소프트웨어학과',
                        style: KR.parag2.copyWith(
                            color: MGColor.base3, letterSpacing: 0.32)),
                    Text(myInfo.stuNum.toString(),
                        style: KR.parag2.copyWith(color: MGColor.base3)),
                    SizedBox(height: ratio.height * 20),
                    Row(children: [
                      Text(myInfo.ratingName,
                          style: KR.parag1.copyWith(color: MGColor.base3)),
                      SizedBox(width: ratio.width * 11),
                      InkWell(
                        onTap: () => _showGradePopup(context),
                        customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: ratio.height * 5,
                              horizontal: ratio.width * 11),
                          decoration: BoxDecoration(
                              color: MGColor.base4.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(100)),
                          child: Text('등급 확인',
                              style: KR.parag2.copyWith(color: Colors.white)),
                        ),
                      )
                    ])
                  ])
            ]),
          ),
        ),
        Row(
          children: [
            TileButtonCard(items: [
              ///내 예약
              TileButton(
                  onTap: widget.moveToReserList,
                  padding: EdgeInsets.symmetric(
                      vertical: 7, horizontal: ratio.width * 33),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(My_page.myreservation,
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
                      vertical: 7, horizontal: ratio.width * 33),
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
                  padding: EdgeInsets.symmetric(
                      vertical: 7, horizontal: ratio.width * 33),
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
        SizedBox(height: ratio.height * 30,),
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
            onTap: () => _trySignOut,
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
        SizedBox(height: ratio.height * 30),

        /// 앱 정보
        TileButton(
          onTap: () => _floatTermPage(context, Term.usingService),
          alignment: Alignment.centerLeft,
          padding:
          EdgeInsets.symmetric(vertical: 7, horizontal: ratio.width * 13),
          child: Text('이용약관', style: KR.parag2.copyWith(color: MGColor.base3)),
        ),
        TileButton(
            onTap: () =>
                _floatTermPage(context, Term.personalInfomationCollection),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
                vertical: 11, horizontal: ratio.width * 13),
            child: Text('개인정보 수집 및 이용',
                style: KR.parag2.copyWith(color: MGColor.base3))),
        TileButton(
          padding:
          EdgeInsets.symmetric(vertical: 11, horizontal: ratio.width * 13),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('버전', style: KR.parag2.copyWith(color: MGColor.base3)),
              Text('1.1.0', style: EN.parag2.copyWith(color: MGColor.base3)),
            ],
          ),
        ),
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
        builder: (ctx) => AlertPopup(
            title: '로그아웃 하시겠습니까?',
            agreeMsg: '로그아웃',
            onAgreed: () async {
              setState(() {
                _loading = true;
                Navigator.pop(ctx);
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
                        onPressed: () => Navigator.of(ctx).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => SignInPage()),
                                (route) => false
                        )
                    )
                );
              } catch(_) {
                func = showDialog(
                    context: context,
                    barrierColor: Colors.black.withOpacity(0.25),
                    builder: (ctx) => CommentPopup(
                        title: "[400] 서버 통신에 문제가 있습니다",
                        onPressed: () => Navigator.pop(ctx)
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

