import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/hotload/login.dart';

// 온보딩 화면 위젯 정의
class OnBoarding extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // 현재 화면의 크기 및 비율 가져오기
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    // 로고 이미지를 표시할 위치 계산
    final double logoWidth = screenWidth * 0.6;
    final double logoHeight = logoWidth * 0.4;
    final double logoX = (screenWidth - logoWidth) / 2;
    final double logoY = (screenHeight - logoHeight) / 2;

    // 온보딩 화면 구성
    return Scaffold(
      backgroundColor: Color(0xFFE8E8E8),
      body: Center(
        child: Stack(
          children: [
            // 배경 이미지 표시
            Positioned(
              child: Image.asset(
                ImgPath.lv_default,
                width: screenWidth, // 원하는 이미지 너비로 설정
                height: screenHeight, // 원하는 이미지 높이로 설정
              ),
            ),
            // "간편하게 강의실을 예약해요" 텍스트
            Positioned(
              left: logoX + 24,
              top: logoY + 180,
              child: Text(
                '간편하게 강의실을 예약해요.',
                style: KR.subtitle2,
              ),
            ),
            // "언제 어디서든 비어있는 강의실을 예약하고 확인하세요." 텍스트
            Positioned(
              left: logoX - 10,
              top: logoY + 220,
              child: Text(
                '언제 어디서든 비어있는 강의실을 예약하고 확인하세요.',
                style: KR.label1.copyWith(
                    color: MGcolor.base3
                ),
              ),
            ),
            // 약관 동의하기 버튼
            Positioned(
              left: logoX - 60,
              top: logoY + 360,
              child: ElevatedButton(
                onPressed: () {
                  // 약관 동의 팝업 띄우기
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                    ),
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.75, // 팝업창 높이
                        child: Stack(
                          children: [
                            // 약관 동의 내용 텍스트
                            Positioned(
                              left: logoX + 70,
                              top: logoY - 200,
                              child: Text('약관 동의 내용'),
                            ),
                            // "동의하기" 버튼
                            Positioned(
                              left: logoX - 60,
                              top: logoY + 120,
                              child: ElevatedButton(
                                onPressed: () {
                                  // 로그인 화면으로 이동
                                  Navigator.of(context).pushReplacement(PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => Login(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.ease;
                                      final tween = Tween(begin: begin, end: end);
                                      final curvedAnimation = CurvedAnimation(
                                        parent: animation,
                                        curve: curve,
                                      );
                                      return SlideTransition(
                                        position: tween.animate(curvedAnimation),
                                        child: child,
                                      );
                                    },
                                  ));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MGcolor.btn_active,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  minimumSize: Size(358, 48),
                                ),
                                child: Text(
                                  '동의하기',
                                  style: EN.subtitle2.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: MGcolor.btn_inactive,
                                  ),
                                ),
                              ),
                            ),
                            // "닫기" 버튼
                            Positioned(
                              left: logoX + 85,
                              top: logoY + 175,
                              child: TextButton(
                                onPressed: () {
                                  // 팝업 닫기
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  '닫기',
                                  style: TextStyle(
                                    color: MGcolor.btn_active,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MGcolor.btn_active,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(358, 48),
                ),
                child: Text(
                  '약관 동의하기',
                  style: EN.subtitle2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: MGcolor.btn_inactive,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
