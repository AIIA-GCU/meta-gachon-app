import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

import 'sign_up_page.dart';
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
  final FToast fToast = FToast();

  bool _isShownToast = false;
  bool _buttonEnabled = false;
  bool isPasswordVisible = false;
  String errorMessage = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    idController.addListener(_updateLoginButtonState);
    pwController.addListener(_updateLoginButtonState);
    fToast.init(context);
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
                        SizedBox(
                          width: ratio.width * 230,
                          child: Form(
                            key: key,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
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
                                    decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: MGColor.base6),
                                  ),
                                  child: Stack(
                                    children: [
                                      TextField(
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
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: GestureDetector(
                                          onTapDown: (tapDetails) => setState(
                                              () => isPasswordVisible = true),
                                          onTapUp: (tapDetails) => setState(
                                              () => isPasswordVisible = false),
                                          onTapCancel: () => setState(
                                              () => isPasswordVisible = false),
                                          behavior: HitTestBehavior.translucent,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: ratio.width * 12,
                                                vertical: 14),
                                            child: Icon(
                                              isPasswordVisible
                                                  ? MGIcon.eyeOn
                                                  : MGIcon.eyeOff,
                                              color: MGColor.base4,
                                              size: ratio.width * 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: ratio.height * 4),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(errorMessage,
                                      style: KR.label2
                                          .copyWith(color: MGColor.systemError)),
                                ),
                              ],
                            ),
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
                                          ? 30
                                          : 75)),
                        ),

                        /// button
                        CustomButtons.bottomButton(
                            '로그인',
                            MGColor.brandPrimary,
                            () => _buttonEnabled ? trySignIn() : null,
                            disableBackground: MGColor.base6,
                            width: 240,
                            borderRadius: 30
                        ),

                        SizedBox(height: ratio.height * 13),

                        Center(
                          child: Container(
                            width: ratio.width * 275,
                            height: ratio.height * 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: showToast,
                                  child: const Text(
                                    '아이디 찾기',
                                    style: TextStyle(color: Color(0xff797979)),
                                  ),
                                ),
                                Container(
                                  child: const Text("|",
                                      style:
                                          TextStyle(color: Color(0xff797979))),
                                ),
                                GestureDetector(
                                  onTap: showToast,
                                  child: const Text('비밀번호 찾기',
                                      style: TextStyle(color: Color(0xff797979))),
                                ),
                                Container(
                                  child: const Text("|",
                                      style:
                                      TextStyle(color: Color(0xff797979))),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => const SignUpFrame()),
                                    );
                                  },
                                  child: const Text('회원 가입',
                                      style:
                                          TextStyle(color: Color(0xff1762DB))),
                                ),
                              ],
                            ),
                          ),
                        )
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

  showToast() {
    if (_isShownToast) return;
    _isShownToast = true;
    Future.delayed(const Duration(seconds: 2)).then((_) => _isShownToast = false);

    double bottom = MediaQuery.of(context).viewInsets.bottom;
    if (bottom == 0) bottom = 60;
    else bottom += 20;
    fToast.showToast(
      positionedToastBuilder: (context, widget) {
        return Positioned(
          bottom: bottom,
          width: MediaQuery.of(context).size.width,
          child: widget,
        );
      },
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 6, horizontal: ratio.width * 16
          ),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(100)
          ),
          child: const Text(
              '아직 이용할 수 없는 서비스 입니다.',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white
              )
          ),
        ),
      )
    );
  }
}
