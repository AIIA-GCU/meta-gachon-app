import 'package:flutter/material.dart';
import 'package:mata_gachon/config/animation.dart';
import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/pages/sign_in_page.dart';

class OnBoarding extends StatelessWidget {
  static late Size screenSize;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [MGcolor.base8, MGcolor.base9],
                stops: [0.0, 0.5])),
        child: Stack(
          children: [
            Positioned(
              child: Image.asset(
                ImgPath.on_boarding,
                width: screenSize.width,
                height: ratio.height * 800,
              ),
            ),
            Positioned(
              top: ratio.height * 562,
              width: screenSize.width,
              child: Center(
                child: Text(
                  '간편하게 강의실을 예약해요.',
                  style: KR.subtitle2,
                ),
              ),
            ),
            Positioned(
              top: ratio.height * 593,
              width: screenSize.width,
              child: Center(
                child: Text(
                  '언제 어디서든 비어있는 강의실을 예약하고 확인하세요.',
                  style: KR.label1.copyWith(color: MGcolor.base3),
                ),
              ),
            ),
            Positioned(
              bottom: ratio.height * 30,
              width: screenSize.width,
              child: Center(
                child: ElevatedButton(
                  onPressed: () => _onPressed(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MGcolor.brand1Primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    minimumSize: Size(ratio.width * 358, ratio.height * 48),
                  ),
                  child: Text(
                    '시작하기',
                    style: EN.subtitle2.copyWith(
                      fontWeight: FontWeight.w700,
                      color: MGcolor.tertiaryColor(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    if (await FCM.initialize()) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          fullscreenDialog: false,
          transitionsBuilder: slideRigth2Left,
          pageBuilder: (context, anime, secondAnime) => SignInPage()
        )
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1200),
          content: Text('권한을 허용해 주세요!')
        )
      );
    }
  }
}
