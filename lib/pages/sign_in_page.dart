import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';
import 'package:mata_gachon/widgets/button.dart';

import 'main_frame.dart';
import '../widgets/popup_widgets.dart';
import '../widgets/small_widgets.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

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
    idController.addListener(_updateLoginButtonState);
    pwController.addListener(_updateLoginButtonState);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Scaffold(
            body: SafeArea(
              child: Center(
                child: Container(
                  width: ratio.width > 1
                      ? 390 : MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// logo & text
                        Padding(
                          padding: EdgeInsets.only(bottom: ratio.height * 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(ImgPath.aiiaColor),
                              const Text('Login',
                                  style: TextStyle(
                                    height: 1.8,
                                    fontSize: 40,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  )),
                              Text(
                                '가천대학교 아이디로 로그인을 해주세요.',
                                style: KR.label2.copyWith(color: MGColor.base4),
                              ),
                            ],
                          ),
                        ),

                        AnimatedSize(
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 100),
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                              height: ratio.height *
                                  (MediaQuery.of(context).viewInsets.bottom > 0
                                      ? 10
                                      : 70)),
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
                                  border: Border.all(color: MGColor.base6),
                                ),
                                child: TextFormField(
                                  controller: idController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: ratio.width * 12,
                                        vertical: ratio.height * 12),
                                    hintText: '아이디 입력',
                                    hintStyle: KR.subtitle3.copyWith(
                                      color: MGColor.base4,
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
                                  border: Border.all(color: MGColor.base6),
                                ),
                                child: TextField(
                                  controller: pwController,
                                  obscureText: !isPasswordVisible,
                                  decoration: InputDecoration(
                                    hintText: '비밀번호 입력',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: ratio.width * 12,
                                        vertical: ratio.height * 12),
                                    hintStyle: KR.subtitle3.copyWith(
                                      color: MGColor.base4,
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTapDown: (tapDetails) {
                                        setState(() => isPasswordVisible = true);
                                      },
                                      onTapUp: (tapDetails) {
                                        setState(() => isPasswordVisible = false);
                                      },
                                      onTapCancel: () {
                                        setState(() => isPasswordVisible = false);
                                      },
                                      onLongPressStart: (tapDetails) {
                                        setState(() => isPasswordVisible = true);
                                      },
                                      onLongPressEnd: (tapDetails) {
                                        setState(() => isPasswordVisible = false);
                                      },
                                      behavior: HitTestBehavior.translucent,
                                      child: Icon(
                                        isPasswordVisible
                                            ? MGIcon.eyeOn
                                            : MGIcon.eyeOff,
                                        color: MGColor.base4,
                                      ),
                                    )
                                  ),
                                ),
                              ),
                              SizedBox(height: ratio.height * 4),
                              Text(errorMessage,
                                  style: KR.label2
                                      .copyWith(color: MGColor.systemError)),
                            ],
                          ),
                        ),

                        AnimatedSize(
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 100),
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                              height: ratio.height *
                                  (MediaQuery.of(context).viewInsets.bottom > 0
                                      ? 10
                                      : errorMessage.isEmpty
                                          ? 42
                                          : 75)),
                        ),

                        /// button
                        CustomButtons.bottomButton('로그인', MGColor.brandPrimary,
                            () => _buttonEnabled ? trySignIn() : null,
                            disableBackground: MGColor.base6)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isLoading) const ProgressScreen()
        ],
      ),
    );
  }

  void _updateLoginButtonState() {
    setState(() {
      _buttonEnabled =
          idController.text.isNotEmpty && pwController.text.isNotEmpty;
    });
  }

  /// try sign-in method
  Future<void> trySignIn() async {
    setState(() {
      FocusScope.of(context).unfocus();
      isLoading = true;
    });
    try {
      // // try sign in
      // final fcmToken = await FCM.getToken();
      User? user = await RestAPI.signIn(
          id: idController.text, pw: pwController.text, token: 'fcmToken');

      // if sign-in success
      if (user != null) {
        // save data
        myInfo = user;
        reserves = await RestAPI.getRemainReservation() ?? [];
        admits = await RestAPI.getAllAdmission() ?? [];
        myAdmits = await RestAPI.getMyAdmission() ?? [];

        // appear main frame
        setState(() => isLoading = false);
        Navigator.of(context).pushReplacement(PageRouteBuilder(
            fullscreenDialog: false,
            transitionsBuilder: slideRigth2Left,
            pageBuilder: (_, __, ___) => const MainFrame()));
      } else {
        // show error message
        setState(() {
          errorMessage = "아이디 혹은 비밀번호가 맞지 않습니다.";
          isLoading = false;
        });
      }
    } on TimeoutException {
      setState(() => isLoading = false);
      showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.25),
          builder: (context) => CommentPopup(
            title: '통신 속도가 너무 느립니다!',
            onPressed: () => Navigator.pop(context)
          )
      );
    } catch (e) {
      debugPrint(e.toString());
      setState(() => isLoading = false);
      showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.25),
        builder: (context) => ErrorPopup(error: e.toString())
      );
    }
  }
}
