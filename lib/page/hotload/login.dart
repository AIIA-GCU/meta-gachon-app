import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/main/frame.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoginButtonEnabled = false;
  bool isPasswordVisible = false;
  String errorMessage = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    idController.addListener(updateLoginButtonState);
    passwordController.addListener(updateLoginButtonState);
  }

  void updateLoginButtonState() {
    setState(() {
      isLoginButtonEnabled =
          idController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          style: KR.subtitle2.copyWith(height: 1.06)
                      ),
                      SizedBox(height: ratio.height * 8),
                      Text(
                        '앱을 이용하기 위해 가천대학교 아이디로 로그인을 해주세요.',
                        style: KR.label1.copyWith(color: MGcolor.base3),
                      ),
                      SizedBox(height: ratio.height * 20),
                    ],
                  ),
                  SizedBox(height: ratio.height * 70),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: ratio.width * 358,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: MGcolor.btn_active),
                        ),
                        child: TextField(
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
                              controller: passwordController,
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
                                      ? Icons.visibility
                                      : Icons.visibility_off,
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
                  SizedBox(height: ratio.height * 70),
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
            if (isLoading)
              Container(
                  color: MGcolor.base1.withOpacity(0.25),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator()
              )
          ],
        ),
      ),
    );
  }

  Future<void> tryLogin() async {
    if (isLoginButtonEnabled) {
      setState(() {
        FocusScope.of(context).unfocus();
        isLoading = true;
      });
      final loginAPI = APIRequest('user');
      await loginAPI.send(
          HTTPMethod.POST,
          params: {
            "ID": idController.text,
            "PW": passwordController.text
          }).then((response) {
            if (idController.text == response['ID']
                && passwordController.text == response['PW']) {
              showLoginPopup();
            } else errorMessage = "아이디 혹은 비밀번호가 맞지 않습니다.";
            setState(() => isLoading = false);
      });
    }
  }

  //로그인되었습니다 팝업창
  void showLoginPopup({String message = '로그인 되었습니다!'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(ratio.width * 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: ratio.height * 28,
                        bottom: ratio.height * 40
                    ),
                    child: Text(message, style: KR.subtitle3),
                  ),
                  SizedBox(height: ratio.height * 7), // 패딩 추가
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => MainFrame()),
                              (route) => route.isFirst
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MGcolor.btn_active,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(302, 40),
                    ),
                    child: Text(
                      '확인',
                      style: KR.parag2.copyWith(
                        fontWeight: FontWeight.w700,
                        color: MGcolor.btn_inactive,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
