import 'package:flutter/material.dart';
import 'package:mata_gachon/config/function.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/main/frame.dart';
import 'user_credentials.dart';

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
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 28, bottom: 40),
                    child: Text(message, style: KR.subtitle3),
                  ),
                  SizedBox(height: 7), // 패딩 추가
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MainFrame()),
                          (route) => route.isFirst);
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: flexibleSize(context, Size.fromWidth(16)).width),
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
                        size: flexibleSize(context, Size.fromWidth(80)).width
                      ),
                      SizedBox(height: flexibleSize(context, Size.fromHeight(20)).height),
                      Text(
                        '안녕하세요.\n메타 가천에 오신 것을 환영합니다.',
                        style: KR.subtitle2.copyWith(height: 1.06)
                      ),
                      SizedBox(height: flexibleSize(context, Size.fromHeight(8)).height),
                      Text(
                        '앱을 이용하기 위해 가천대학교 아이디로 로그인을 해주세요.',
                        style: KR.label1.copyWith(color: MGcolor.base3),
                      ),
                      SizedBox(height: flexibleSize(context, Size.fromHeight(20)).height),
                    ],
                  ),
                  SizedBox(height: flexibleSize(context, Size.fromHeight(70)).height),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 358,
                        height: 48,
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
                            contentPadding: EdgeInsets.all(12),
                            hintStyle: KR.subtitle3.copyWith(
                              color: MGcolor.base4,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: flexibleSize(context, Size.fromHeight(10)).height),
                      Container(
                        width: 358,
                        height: 48,
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
                                contentPadding: EdgeInsets.all(12),
                                hintStyle: KR.subtitle3.copyWith(
                                  color: MGcolor.base4,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 3,
                              child: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: flexibleSize(context, Size.fromHeight(4)).height),
                      Text(
                        errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: flexibleSize(context, Size.fromHeight(70)).height),
                  ElevatedButton(
                    onPressed: isLoginButtonEnabled
                        ? () {
                      setState(() {
                        isLoading = true;
                        errorMessage = '';
                      });
                      Future.delayed(Duration(seconds: 2), () {
                        if (idController.text == UserCredentials.correctId &&
                            passwordController.text ==
                                UserCredentials.correctPassword) {
                          showLoginPopup(message: '로그인되었습니다!');
                        } else {
                          setState(() {
                            errorMessage = '아이디 혹은 비밀번호가 맞지 않습니다.';
                            isLoading = false;
                          });
                        }
                        setState(() {
                          isLoading = false;
                        });
                      });
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MGcolor.btn_active,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(358, 48),
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
}
