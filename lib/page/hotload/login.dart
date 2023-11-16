import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/main/frame.dart';
import 'user_credentials.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>{
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
  void showLoginPopup( { String message = '로그인 되었습니다!'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center( //중앙에 배치
          child: Container(
            width: 326, // 가로 크기 조절
            height: 156, // 세로 크기 조절
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: Text(
                      message,
                      style: KR.subtitle3,
                    ),
                    ),
                  ),
                  SizedBox(height: 7),// 패딩 추가
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MainFrame()),
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

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    // 로고 이미지를 표시할 위치 계산
    final double logoWidth = screenWidth * 0.6;
    final double logoHeight = logoWidth * 0.4;
    final double logoX = (screenWidth - logoWidth) / 2;
    final double logoY = (screenHeight - logoHeight) / 4;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child:Scaffold(
          body:SingleChildScrollView(
                child: Stack(
                      children: [
                        Container(
                          color: MGcolor.base7,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: logoX-60, top: logoY+35),
                          child: Icon(MGLogo.logo, color: MGcolor.btn_active, size: 79.99),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: logoX-60, top: logoY+130),
                          child: Text(
                            '안녕하세요.',
                            style: KR.subtitle2,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: logoX-60, top: logoY+155),
                          child: Text(
                            '메타 가천에 오신 것을 환영합니다.',
                            style: KR.subtitle2
                            ),
                          ),
                        Container(
                          margin: EdgeInsets.only(left: logoX-60, top: logoY+190),
                          child: Text(
                            '앱을 이용하기 위해 가천대학교 아이디로 로그인을 해주세요.',
                            style: KR.label1.copyWith(
                                color:MGcolor.base3
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: logoX-60, top: logoY+280),
                          child: Container(
                            width: 358,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color:MGcolor.btn_active),// 둥근 테두리를 적용
                            ),
                            child: TextField(
                              controller: idController,
                              decoration: InputDecoration(
                                hintText:'아이디를 입력하세요',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12),
                                hintStyle: KR.subtitle3.copyWith(
                                  color:MGcolor.base4,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: logoX-60, top: logoY+340),
                           // 비밀번호 입력 필드의 위치 조정
                          child: Container(
                            width: 358,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color:MGcolor.btn_active),// 둥근 테두리를 적용
                            ),
                            child: Stack(
                              children: [
                                TextField(controller: passwordController,
                              obscureText: !isPasswordVisible, // 비밀번호를 숨길 때 사용
                              decoration: InputDecoration(
                                hintText: '비밀번호를 입력하세요',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12),
                                hintStyle: KR.subtitle3.copyWith(
                                  color:MGcolor.base4,
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
                        ),
                        Container(
                          margin: EdgeInsets.only(left: logoX-50, top: logoY+395),
                           // 에러 메시지 위치 조정
                          child: Text(
                            errorMessage, // 에러 메시지 표시
                            style: TextStyle(
                              color: Colors.red, // 에러 메시지 색상
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: logoX-60, top: logoY+470),
                          child: ElevatedButton(
                            onPressed: isLoginButtonEnabled
                                ? () {
                              setState(() {
                                isLoading = true;
                                errorMessage = '';
                              });
                              Future.delayed(Duration(seconds: 2), ()
                              {
                                if (idController.text == UserCredentials.correctId &&
                                    passwordController.text == UserCredentials.correctPassword) {
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
                            :null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MGcolor.btn_active,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: Size(358, 48),
                            ),
                            child:Text(
                              '로그인',
                              style: EN.subtitle2.copyWith(
                                fontWeight: FontWeight.w700,
                                color: MGcolor.btn_inactive,
                              ),
                            ),
                          ),
                        ),
                        if (isLoading)
                          Container(
                            color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                          ),
                        if (isLoading)
                          Positioned.fill(
                            child:Center(
                              child: CircularProgressIndicator(), // 로딩 중에는 중앙에 CircularProgressIndicator 표시
                            ),
                          ),
                        ],
                  ),
            ),
          ),
    );
  }
}