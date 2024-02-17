import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';
import 'package:mata_gachon/pages/sign_in_page.dart';
import 'package:mata_gachon/widgets/button.dart';

class OnBoarding extends StatelessWidget {
  static late Size screenSize;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [MGColor.base8, MGColor.base9],
                stops: [0.0, 0.5])
        ),
        child: Stack(
          children: [
            Positioned(
              child: Image.asset(
                ImgPath.onBoarding,
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
                  style: KR.label1.copyWith(color: MGColor.base3),
                ),
              ),
            ),
            Positioned(
              bottom: ratio.height * 30,
              width: screenSize.width,
              child: Center(
                child: CustomButtons.bottomButton(
                    '시작하기',
                    MGColor.brand1Primary,
                    () => _onPressed(context)
                )
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
        const SnackBar(
          duration: Duration(milliseconds: 1200),
          content: Text('권한을 허용해 주세요!')
        )
      );
    }
  }
}
