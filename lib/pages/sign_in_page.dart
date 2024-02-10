import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:mata_gachon/config/animation.dart';
import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/pages/sign_up_page.dart';
import 'package:mata_gachon/pages/main_frame.dart';
import 'package:mata_gachon/widgets/popup_widgets.dart';
import 'package:mata_gachon/widgets/small_widgets.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  bool _buttonEnabled = false;
  bool isPasswordVisible = false;
  String errorMessage = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    idController.addListener(updateLoginButtonState);
    pwController.addListener(updateLoginButtonState);
  }

  void updateLoginButtonState() {
    setState(() {
      _buttonEnabled =
          idController.text.isNotEmpty && pwController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          ///
          Scaffold(
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// logo & text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(ImgPath.aiia_color),
                      Text('Login', style: TextStyle(
                        height: 1.8,
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      )),
                      Text(
                        '가천대학교 AIIA 아이디로 로그인을 해주세요.',
                        style: KR.label2.copyWith(color: MGcolor.base4),
                      ),
                    ],
                  ),

                  SizedBox(height: ratio.height * (MediaQuery.of(context).viewInsets.bottom > 0 ? 16 : 72)),

                  /// input
                  Form(
                    key: key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: ratio.width * 358,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: MGcolor.base6),
                          ),
                          child: TextFormField(
                            controller: idController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: ratio.width * 12,
                                vertical: ratio.height * 12
                              ),
                              hintText: '아이디 입력',
                              hintStyle: KR.subtitle3.copyWith(
                                color: MGcolor.base4,
                              ),
                              border: InputBorder.none,
                            ),
                            validator: (val) {
                              return val == null ? '' : null;
                            },
                          ),
                        ),
                        SizedBox(height: ratio.height * 10),
                        Container(
                          width: ratio.width * 358,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: MGcolor.base6),
                          ),
                          child: Stack(
                            children: [
                              TextField(
                                controller: pwController,
                                obscureText: !isPasswordVisible,
                                decoration: InputDecoration(
                                  hintText: '패스워드 입력',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: ratio.width * 12,
                                      vertical: ratio.height * 12
                                  ),
                                  hintStyle: KR.subtitle3.copyWith(
                                    color: MGcolor.base4,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: GestureDetector(
                                  onTapDown: (tapDetails) => setState(() => isPasswordVisible = true),
                                  onTapUp: (tapDetails) => setState(() => isPasswordVisible = false),
                                  onTapCancel: () => setState(() => isPasswordVisible = false),
                                  behavior: HitTestBehavior.translucent,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ratio.width * 12,
                                      vertical: 14
                                    ),
                                    child: Icon(isPasswordVisible
                                          ? AppinIcon.eye_on
                                          : AppinIcon.eye_off,
                                      color: MGcolor.base4,
                                      size: ratio.width * 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: ratio.height * 4),
                        Text(
                            errorMessage,
                            style: KR.label2.copyWith(color: MGcolor.systemError)
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: ratio.height * (MediaQuery.of(context).viewInsets.bottom > 0 ? 16 : 68)),

                  /// button
                  Column(
                    children: [
                      /// 로그인
                      ElevatedButton(
                        onPressed: _buttonEnabled ? tryLogin : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MGcolor.brand1Primary,
                          disabledBackgroundColor: MGcolor.base6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          minimumSize: Size(ratio.width * 358, ratio.height * 56),
                        ),
                        child: Text(
                          '로그인',
                          style: EN.subtitle2.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      SizedBox(height: ratio.height * 12),

                      /// 로그인 외
                      IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// 아이디 찾기
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ratio.width * 10,
                                  vertical: ratio.height * 12
                                ),
                                child: Text(
                                  '아이디 찾기',
                                  style: KR.parag2.copyWith(color: MGcolor.base4),
                                )
                              ),
                            ),

                            VerticalDivider(
                              width: 1,
                              thickness: 1,
                              indent: 15,
                              endIndent: 13,
                              color: MGcolor.base4,
                            ),

                            /// 비밀번호 찾기
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ratio.width * 10,
                                      vertical: ratio.height * 12
                                  ),
                                  child: Text(
                                    '비밀번호 찾기',
                                    style: KR.parag2.copyWith(color: MGcolor.base4),
                                  )
                              ),
                            ),

                            VerticalDivider(
                              width: 1,
                              thickness: 1,
                              indent: 15,
                              endIndent: 13,
                              color: MGcolor.base4,
                            ),

                            /// 회원가입
                            GestureDetector(
                              onTap: _floatSignUpPage,
                              behavior: HitTestBehavior.translucent,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ratio.width * 10,
                                      vertical: ratio.height * 12
                                  ),
                                  child: Text(
                                    '회원가입',
                                    style: KR.parag2.copyWith(color: MGcolor.brand1Primary),
                                  )
                              ),
                            ),
                          ]
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

          ///
          if (isLoading)
            ProgressScreen()
        ],
      ),
    );
  }

  /// using api
  Future<void> tryLogin() async {
    if (_buttonEnabled) {
      setState(() {
        FocusScope.of(context).unfocus();
        isLoading = true;
      });
      try {
        final fcmToken = await FCM.getToken();
        User? user = await RestAPI.signIn(
            id: idController.text, pw: pwController.text, token: fcmToken);
        if (user != null) {
          // save data local
          myInfo = user;
          reservates = await RestAPI.getAllReservation() ?? [];
          admits = await RestAPI.getAllAdmission() ?? [];
          myAdmits = await RestAPI.getMyAdmission() ?? [];

          // appaer popup screen
          setState(() {
            isLoading = false;
            showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.25),
                builder: (BuildContext context) => CommentPopup(
                    title: '로그인되었습니다!',
                    onPressed: () => Navigator.pop(context))).then((_) =>
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainFrame()),
                    (route) => false));
          });
        } else {
          setState(() {
            errorMessage = "아이디 혹은 비밀번호가 맞지 않습니다.";
            isLoading = false;
          });
        }
      } on TimeoutException {
        setState(() {
          isLoading = false;
          showDialog(
              context: context,
              barrierColor: Colors.black.withOpacity(0.25),
              builder: (context) => CommentPopup(
                  title: "통신 속도가 너무 느립니다!",
                  onPressed: () => Navigator.pop(context)
              )
          );
        });
      }
    }
  }

  void _floatSignUpPage() {
    Navigator.of(context).push(
      PageRouteBuilder(
        fullscreenDialog: false,
        transitionsBuilder: slideRigth2Left,
        pageBuilder: (context, anime, secondAnime) => SignUpFrame(),
      )
    );
  }
}
