import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';

import '../config/server/session.dart';
import '../widgets/button.dart';
import '../widgets/layout.dart';
import 'sign_in_page.dart';
import '../widgets/popup_widgets.dart';
import '../widgets/small_widgets.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}
class _SettingPageState extends State<SettingPage> {
  bool _loading = false;
  bool _alarmOnOff = false;
  // bool _temp2 = false;
  
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
                  style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.padded
                  ),
                  icon: Icon(
                    MGIcon.back,
                    size: ratio.width * 24,
                    color: MGColor.base4
                  ),
                ),
                SizedBox(width: ratio.width * 8),
                Text('설정', style: KR.subtitle1.copyWith(color: Colors.black))
              ])
            )
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ratio.width * 16,),
              child: Column(children: [
                TileButtonCard(items: [
                  /// 알림 설정
                  TileButton(
                    padding: EdgeInsets.symmetric(
                      // vertical: ratio.height * 10,
                      horizontal: ratio.width * 22,
                      vertical: ratio.height * 3
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('알림', style: KR.subtitle2),
                        Switch(
                          value: _alarmOnOff,
                          activeColor: Colors.white,
                          activeTrackColor: MGColor.brandPrimary,
                          inactiveTrackColor: MGColor.base6,
                          inactiveThumbColor: Colors.white,
                          onChanged: (val) {
                            setState(() => _alarmOnOff = val);
                          }
                        ),
                      ]
                    )

                  ),

                  // TileButton(
                  //     padding: EdgeInsets.symmetric(
                  //       // vertical: ratio.height * 10,
                  //         horizontal: ratio.width * 22
                  //     ),
                  //     child: Row(
                  //         mainAxisSize: MainAxisSize.max,
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text('다크 모드', style: KR.subtitle2),
                  //           Switch(
                  //               value: _alarmOnOff,
                  //               activeColor: Colors.white,
                  //               activeTrackColor: MGColor.brandPrimary,
                  //               inactiveTrackColor: MGColor.base6,
                  //               inactiveThumbColor: Colors.white,
                  //               onChanged: (val) {
                  //                 setState(() => _alarmOnOff = val);
                  //               }
                  //           )
                  //         ]
                  //     )
                  // ),


                ]),


              ])
            ),
          )
        ),

        if (_loading)
          const ProgressScreen()
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
