import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/main/frame.dart';
import 'user_credentials.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // 사용자명 및 비밀번호 입력 컨트롤러
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // 로그인 버튼 활성화 여부, 비밀번호 가시성, 에러 메시지, 로딩 상태 관리 변수
  bool isLoginButtonEnabled = false;
  bool isPasswordVisible = false;
  String errorMessage = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // 사용자명과 비밀번호 입력 필드 내용이 변경될 때마다 로그인 버튼 상태를 업데이트함
    idController.addListener(updateLoginButtonState);
    passwordController.addListener(updateLoginButtonState);
  }

  void updateLoginButtonState() {
    // 사용자명과 비밀번호 모두 입력되면 로그인 버튼 활성화
    setState(() {
      isLoginButtonEnabled =
          idController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  // 로그인 성공 팝업창 표시
  void showLoginPopup({String message = '로그인 되었습니다!'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: 326,
            height: 156,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: Text(
                        message,
                        style: KR.subtitle3,
                      ),
                    ),
                  ),
                  SizedBox(height: 7),
                  ElevatedButton(
                    onPressed: () {
                      // 로그인 팝업 확인 버튼을 누르면 메인 프레임으로 이동하고 이전 화면들을 제거
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MainFrame()),
                            (route) => route.isFirst,
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
        // 다른 곳을 터치하면 키보드 숨김
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                color: MGcolor.base7,
              ),
              Container(
                margin: EdgeInsets.only(left: logoX - 60, top: logoY + 35),
                child: Icon(MGLogo.logo, color: MGcolor.btn_active, size: 79.99),
              ),
              Container(
                margin: EdgeInsets.only(left: logoX - 60, top: logoY + 130),
                child: Text(
                  '안녕하세요.',
                  style: KR.subtitle2,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: logoX - 60, top: logoY + 155),
                child: Text(
                  '메타 가천에 오신 것을 환영합니다.',
                  style: KR.subtitle2,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: logoX - 60, top: logoY + 190),
                child: Text(
                  '앱을 이용하기 위해 가천대학교 아이디로 로그인을 해주세요.',
                  style: KR.label1.copyWith(
                    color: MGcolor.base3,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: logoX - 60, top: logoY + 280),
                child: Container(
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
              ),
              Container(
                margin: EdgeInsets.only(left: logoX - 60, top: logoY + 340),
                child: Container(
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
              ),
              Container(
                margin: EdgeInsets.only(left: logoX - 50, top: logoY + 395),
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: logoX - 60, top: logoY + 470),
                child: ElevatedButton(
                  onPressed: isLoginButtonEnabled
                      ? () {
                    setState(() {
                      isLoading = true;
                      errorMessage = '';
                    });
                    Future.delayed(Duration(seconds: 2), () {
                      if (idController.text ==
                          UserCredentials.correctId &&
                          passwordController.text ==
                              UserCredentials.correctPassword) {
                        showLoginPopup(message: '로그인되었습니다!');
                      } else {
                        setState(() {
                          errorMessage =
                          '아이디 혹은 비밀번호가 맞지 않습니다.';
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
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              if (isLoading)
                Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
