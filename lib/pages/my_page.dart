import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/app/my_page_icons.dart';
import 'package:mata_gachon/config/server/_export.dart';
import 'package:mata_gachon/pages/sign_in_page.dart';
import 'package:mata_gachon/widgets/small_widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late final SharedPreferences preferences;
  late bool sameDate, seeGradeExplanation;
  bool _loading = false;

  @override
  void initState() {
    getSavedDate();
    super.initState();
  }

  Future<void> getSavedDate() async {
    preferences = await SharedPreferences.getInstance();
    var str = preferences.getString("today") ?? "";
    debugPrint("saved data = $str");
    if (str.isEmpty) {
      sameDate = false;
      seeGradeExplanation = true;
    } else {
      var list = str.split(',');
      seeGradeExplanation = list[0] == '1';
      sameDate = list[1] == today;
      if (!sameDate) {
        seeGradeExplanation = true;
        preferences.setString("today", "1,$today");
      }
    }
    debugPrint("sameDate = $sameDate");
    debugPrint("seeGradeExplanation = $seeGradeExplanation");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(ratio.width * 16, 0,
              ratio.width * 16, ratio.height * 23),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            /// 프로필
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Row(
                  children: [
                /// 이미지
                Container(
                  width: ratio.width * 120,
                  height: ratio.width * 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    image: const DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage(ImgPath.profile)
                    )
                  )
                ),

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

            /// <내 예약> & <내 인증> & <내 등급>
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _button(
                  label: "내 예약",
                  iconSrc: MGIcon.res,
                  onPressed: widget.moveToReserList
                ),
                _button(
                  label: "내 인증",
                  iconSrc: My_page.mycertification,
                  onPressed: () => _floatMyAdmissionPage(context)
                ),
                _button(
                  label: "내 등급",
                  iconSrc: My_page.mygrade,
                  onPressed: () => _showGradeExplainPopup(context)
                ),
              ],
            ),

            SizedBox(height: ratio.height * 22),

            /// <학교 홈페이지 바로가기> & <사이버 캠퍼스 바로가기>
            /// & <설정> & <로그아웃>
            TileButton(
                onTap: () => launchUrl(
                    Uri.parse('https://www.gachon.ac.kr/kor/index.do')),
                padding:
                EdgeInsets.fromLTRB(ratio.width * 13, 12, ratio.width * 18, 12),
                child: Row(mainAxisSize: MainAxisSize.max, children: [
                  const Icon(
                   My_page.homepage,
                    color: MGColor.base3,
                  ),
                  SizedBox(width: ratio.width * 16),
                  Text('학교 홈페이지 바로가기',
                      style: KR.subtitle3.copyWith(color: MGColor.base3)),
                  const Spacer(),
                  Transform.rotate(
                      angle: pi,
                      child: Icon(MGIcon.back,
                          size: ratio.width * 24, color: MGColor.base4))
                ])),
            TileButton(
                onTap: () =>
                    launchUrl(Uri.parse('https://cyber.gachon.ac.kr/')),
                padding:
                EdgeInsets.fromLTRB(ratio.width * 13, 12, ratio.width * 18, 12),
                child: Row(mainAxisSize: MainAxisSize.max, children: [
                  const Icon(My_page.cybercampus, color: MGColor.base3),
                  SizedBox(width: ratio.width * 16),
                  Text('사이버 캠퍼스 바로가기',
                      style: KR.subtitle3.copyWith(color: MGColor.base3)),
                  const Spacer(),
                  Transform.rotate(
                      angle: pi,
                      child: Icon(MGIcon.back,
                          size: ratio.width * 24, color: MGColor.base4))
                ])),
            // TileButton(
            //     onTap: () => _floatSettingPage(context),
            //     padding: EdgeInsets.fromLTRB(ratio.width * 13, 12, ratio.width * 18, 12),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.max,
            //       children: [
            //         Icon(
            //           My_page.setting,
            //           color: MGColor.base3,
            //         ),
            //         SizedBox(width: ratio.width * 16),
            //         Text('설정', style: KR.subtitle3.copyWith(color: MGColor.base3)),
            //         Spacer(),
            //         Transform.rotate(
            //             angle: pi,
            //             child: Icon(MGIcon.back,
            //                 size: ratio.width * 24, color: MGColor.base4))
            //       ],
            //     )),
            TileButton(
                onTap: () => _trySignOut(context),
                padding: EdgeInsets.fromLTRB(ratio.width * 13, 12, ratio.width * 18, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Icon(
                      My_page.logout,
                      color: MGColor.base3,
                    ),
                    SizedBox(width: ratio.width * 16),
                    Text('로그아웃', style: KR.subtitle3.copyWith(color: MGColor.base3)),
                    const Spacer(),
                    Transform.rotate(
                        angle: pi,
                        child: Icon(MGIcon.back,
                            size: ratio.width * 24, color: MGColor.base4))
                  ],
                )),

            SizedBox(height: ratio.height * 16),
            const Divider(
              thickness: 0.3,
              color: MGColor.base3,
            ),
            SizedBox(height: ratio.height * 16),

            /// 앱 정보
            TileButton(
              onTap: () => _floatTermPage(context, Term.usingService),
              // alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: ratio.width * 3),
              child: SizedBox(
                  width: double.infinity,
                  child: Text('이용약관', style: KR.parag2.copyWith(color: MGColor.base3))),
            ),
            TileButton(
                onTap: () =>
                    _floatTermPage(context, Term.personalInfomationCollection),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                    vertical: 11, horizontal: ratio.width * 3),
                child: SizedBox(
                  width: double.infinity,
                  child: Text('개인정보 수집 및 이용',
                      style: KR.parag2.copyWith(color: MGColor.base3)),
                )),
            TileButton(
              padding:
              EdgeInsets.symmetric(vertical: 11, horizontal: ratio.width * 3),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('버전', style: KR.parag2.copyWith(color: MGColor.base3)),
                  Text(packageInfo.version, style: EN.parag2.copyWith(color: MGColor.base3)),
                ],
              ),
            ),
            SizedBox(height: ratio.height * 30),

          ]),
        ),

        if (_loading)
          const ProgressScreen()
      ],
    );
  }

  Widget _button({
    required String label,
    required IconData iconSrc,
    required VoidCallback onPressed
  }) => InkWell(
    onTap: onPressed,
    child: Container(
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: ratio.width * 35
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(iconSrc,
              color: MGColor.brandPrimary,
              size: ratio.width * 26),
          const SizedBox(height: 10),
          Text(label, style: KR.parag2)
        ],
      ),
    ),
  );

  void _showGradeExplainPopup(BuildContext context) {
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.25),
        builder: (context) => GradeExplainPopup(
          preferences: preferences,
          hideForDay: () {},
        )
    );
    // if (seeGradeExplanation) {
    //   showDialog(
    //       context: context,
    //       barrierColor: Colors.black.withOpacity(0.25),
    //       builder: (context) => GradeExplainPopup(
    //         preferences: preferences,
    //         hideForDay: () {
    //           seeGradeExplanation = false;
    //           debugPrint("seeGradeExplanation = $seeGradeExplanation");
    //         },
    //       )
    //   );
    // } else {
    //   showDialog(
    //       context: context,
    //       barrierColor: MGColor.barrier,
    //       builder: (_) => const GradePopup()
    //   );
    // }
  }

  void _floatMyAdmissionPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MyAdmissionPage()));
  }

  // void _floatSettingPage(BuildContext context) {
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (context) => const SettingPage()));
  // }

  void _floatTermPage(BuildContext context, Term term) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => TermPage(term: term)));
  }

  void _trySignOut(BuildContext context1) {
    showDialog(
        context: context1,
        barrierColor: Colors.black.withOpacity(0.25),
        builder: (context2) => AlertPopup(
            title: '로그아웃 하시겠습니까?',
            agreeMsg: '로그아웃',
            onAgreed: () async {
              setState(() {
                _loading = true;
                Navigator.pop(context2);
              });

              late Future func;
              try {
                if (!await Session().clear()) {
                  setState(() => _loading = false);
                  throw Exception('\n[Error] about Session');
                }
                setState(() => _loading = false);

                showDialog(
                    context: context1,
                    barrierColor: Colors.black.withOpacity(0.25),
                    builder: (context3) => CommentPopup(
                        title: "로그아웃 되었습니다!",
                        onPressed: () => Navigator.pop(context3)
                    )
                ).then((_) => Navigator.of(context1).pushAndRemoveUntil(
                    PageRouteBuilder(
                        fullscreenDialog: false,
                        transitionsBuilder: slideRigth2Left,
                        pageBuilder: (_, __, ___) => const SignInPage()
                    ), (route) => false
                ));
              } catch(_) {
                showDialog(
                    context: context1,
                    barrierColor: Colors.black.withOpacity(0.25),
                    builder: (context3) => CommentPopup(
                        title: "[400] 서버 통신에 문제가 있습니다",
                        onPressed: () => Navigator.pop(context3)
                    )
                );
              }
            }
        )
    );
  }
}

