import 'package:flutter/material.dart';
import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/main/frame.dart';
import 'package:mata_gachon/widget/popup.dart';
import 'package:mata_gachon/widget/small_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  bool isLoginButtonEnabled = false;
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
      isLoginButtonEnabled =
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
            body: Center(
              child: Container(
                height: ratio.height * 506,
                padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// logo & text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          MGLogo.logo,
                          color: MGcolor.brand_orig,
                          size: ratio.width * 80,
                        ),
                        SizedBox(height: ratio.height * 20),
                        Text(
                            '안녕하세요.\n메타 가천에 오신 것을 환영합니다.',
                            style: KR.subtitle1.copyWith(height: 1.06)
                        ),
                        SizedBox(height: ratio.height * 8),
                        Text(
                          '앱을 이용하기 위해 가천대학교 아이디로 로그인을 해주세요.',
                          style: KR.label1.copyWith(color: MGcolor.base3),
                        ),
                        SizedBox(height: ratio.height * 20),
                      ],
                    ),

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
                              border: Border.all(color: MGcolor.btn_active),
                            ),
                            child: TextFormField(
                              controller: idController,
                              decoration: InputDecoration(
                                hintText: '아이디를 입력하세요',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: ratio.width * 12,
                                    vertical: ratio.height * 12
                                ),
                                hintStyle: KR.subtitle3.copyWith(
                                  color: MGcolor.base4,
                                ),
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
                              border: Border.all(color: MGcolor.btn_active),
                            ),
                            child: Stack(
                              children: [
                                TextField(
                                  controller: pwController,
                                  obscureText: !isPasswordVisible,
                                  decoration: InputDecoration(
                                    hintText: '비밀번호를 입력하세요',
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
                                  right: ratio.width * 3,
                                  child: IconButton(
                                    icon: Icon(
                                      isPasswordVisible
                                          ? AppinIcon.eye_on
                                          : AppinIcon.eye_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() =>
                                      isPasswordVisible = !isPasswordVisible);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: ratio.height * 4),
                          Text(
                              errorMessage,
                              style: KR.label2.copyWith(color: MGcolor.system_error)
                          ),
                        ],
                      ),
                    ),

                    /// button
                    ElevatedButton(
                      onPressed: tryLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MGcolor.btn_active,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        minimumSize: Size(ratio.width * 358, ratio.height * 56),
                      ),
                      child: Text(
                        '로그인',
                        style: EN.subtitle2.copyWith(
                          fontWeight: FontWeight.w700,
                          color: MGcolor.btn_inactive,
                        ),
                      ),
                    )
                  ],
                ),
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
    if (isLoginButtonEnabled) {
      setState(() {
        FocusScope.of(context).unfocus();
        isLoading = true;
      });
      User? user = await RestAPI.login(
        id: idController.text,
        pw: pwController.text
      );
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
                  onPressed: () async {
                    final preference = await SharedPreferences.getInstance();
                    if (preference.getBool('firstTime')! == true) {
                      preference.setBool('firstTime', false);
                      debugPrint("You logined at first!");
                    }
                    Navigator.pop(context);
                  }
              )
          ).then((_) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainFrame()),
                  (route) => false
          ));
        });
      } else {
        setState(() {
          errorMessage = "아이디 혹은 비밀번호가 맞지 않습니다.";
          isLoading = false;
        });
      }
    }
  }
}
