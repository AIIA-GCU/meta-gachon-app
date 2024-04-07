import 'package:flutter/cupertino.dart';
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
                stops: [0.2, 0.5])
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                ImgPath.onBoarding,
                fit: BoxFit.fitHeight,
              ),
            ),
            Positioned(
              top: ratio.height * 552,
              width: screenSize.width,
              child: Center(
                child: Text(
                  '교내 공간을 간편하게 예약해요.',
                  style: KR.subtitle1.copyWith(
                      color: MGColor.brandPrimary),
                ),
              ),
            ),
            Positioned(
              top: ratio.height * 610,
              width: screenSize.width,
              height: ratio.height * 70,
              child: Center(
                child: Text(
                  '언제 어디서든\n 비어있는 회의실 및 강의실,\n 컴퓨터를 예약하고 확인하세요.',
                  style: KR.subtitle4.copyWith(color: MGColor.base3),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              bottom: ratio.height * 30,
              width: screenSize.width,
              child: Center(
                  child: SizedBox(
                    width: ratio.width > 1
                        ? 358 : screenSize.width,
                    child: CustomButtons.bottomButton(
                        '시작하기',
                        MGColor.brandPrimary,
                            () => _onPressed(context)
                    ),
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