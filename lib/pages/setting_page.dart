import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/pages/sign_in_page.dart';
import 'package:mata_gachon/widgets/popup_widgets.dart';
import 'package:mata_gachon/widgets/small_widgets.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}
class _SettingPageState extends State<SettingPage> {
  bool _loading = false;
  bool _temp1 = false;
  bool _temp2 = false;
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ///
        Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(
              double.infinity,
              ratio.height * 100
            ),
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(
                left: ratio.width * 8,
                bottom: ratio.height * 38
              ),
              child: Row(children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    AppinIcon.back,
                    size: ratio.width * 24,
                    color: MGcolor.base4
                  ),
                ),
                SizedBox(width: ratio.width * 8),
                Text('설정', style: KR.subtitle1.copyWith(color: Colors.black))
              ])
            )
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
            child: Column(children: [
              TileButtonCard(items: [
                /// 알림 설정
                TileButton(
                  padding: EdgeInsets.symmetric(
                    // vertical: ratio.height * 10,
                    horizontal: ratio.width * 22
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('알림 설정', style: KR.subtitle4),
                      Switch(
                        value: _temp1,
                        activeColor: Colors.white,
                        activeTrackColor: MGcolor.btn_active,
                        inactiveTrackColor: MGcolor.base6,
                        inactiveThumbColor: Colors.white,
                        onChanged: (val) {
                          setState(() => _temp1 = val);
                        }
                      )
                    ]
                  )
                ),
                TileButton(
                    padding: EdgeInsets.symmetric(
                      // vertical: ratio.height * 10,
                        horizontal: ratio.width * 22
                    ),
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              setState(() {
                                SelectTheme.changeblue();  
                              });
                            },
                            child: Text('파란색'),
                          ),
                          ElevatedButton(
                            onPressed: (){
                              setState(() {
                                SelectTheme.changepurple();
                              });
                            },
                            child: Text('보라색'),
                          ),
                          ElevatedButton(
                            onPressed: (){
                              setState(() {
                                SelectTheme.changeblue_green();
                              });
                            },
                            child: Text('청록색'),
                          ),
                        ]
                    )
                ),
                /// 다크 모드
                // TileButton(
                //     padding: EdgeInsets.symmetric(
                //       // vertical: ratio.height * 10,
                //         horizontal: ratio.width * 22
                //     ),
                //     child: Row(
                //         mainAxisSize: MainAxisSize.max,
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text('다크 모드', style: KR.subtitle4),
                //           Switch(
                //               value: _temp2,
                //               activeColor: Colors.white,
                //               activeTrackColor: MGcolor.btn_active,
                //               inactiveTrackColor: MGcolor.base6,
                //               inactiveThumbColor: Colors.white,
                //               onChanged: (val) {
                //                 setState(() => _temp2 = val);
                //               }
                //           )
                //         ]
                //     )
                // ),
              ]),
              TileButtonCard(items: [
                /// 학교 홈페이지로 바로 가기
                TileButton(
                  onTap: () => launchUrl(Uri.parse('https://www.gachon.ac.kr/kor/index.do')),
                    padding: EdgeInsets.fromLTRB(
                      ratio.width * 22,
                      ratio.height * 12,
                      ratio.width * 18,
                      ratio.height * 12
                    ),
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '학교 홈페이지로 바로 가기',
                            style: KR.subtitle4.copyWith(color: MGcolor.brand_orig)
                          ),
                          Transform.rotate(
                            angle: pi,
                            child: Icon(
                                AppinIcon.back,
                                size: ratio.width * 24,
                                color: MGcolor.base4
                            )
                          )
                        ]
                    )
                ),

                /// 사이버 캠퍼스로 바로 가기
                TileButton(
                    onTap: () => launchUrl(Uri.parse('https://www.gachon.ac.kr/kor/index.do')),
                    padding: EdgeInsets.fromLTRB(
                        ratio.width * 22,
                        ratio.height * 12,
                        ratio.width * 18,
                        ratio.height * 12
                    ),
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '사이버 캠퍼스로 바로 가기',
                              style: KR.subtitle4.copyWith(color: MGcolor.brand_orig)
                          ),
                          Transform.rotate(
                              angle: pi,
                              child: Icon(
                                  AppinIcon.back,
                                  size: ratio.width * 24,
                                  color: MGcolor.base4
                              )
                          )
                        ]
                    )
                )
              ]),
              TileButtonCard(
                padding: EdgeInsets.zero,
                items: [
                  /// 로그아웃
                  TileButton(
                    onTap: _trySignOut,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(
                      horizontal: ratio.width * 22,
                      vertical: ratio.height * 16
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Text('로그아웃', style: KR.subtitle4)
                  )
                ]
              )
            ])
          )
        ),

        if (_loading)
          ProgressScreen()
      ],
    );
  }

  void _trySignOut() {
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
            if (!await new Session().clear()) {
              throw Exception('\n[Error] about Session');
            }
            func = showDialog(
              context: context,
              barrierColor: Colors.black.withOpacity(0.25),
              builder: (context) => CommentPopup(
                title: "로그아웃 되었습니다!",
                onPressed: () =>Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SignInPage()),
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
