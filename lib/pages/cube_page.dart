import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';
import 'package:mata_gachon/pages/sign_in_page.dart';
import 'package:mata_gachon/widgets/button.dart';

class CubePage extends StatelessWidget {
  const CubePage({
    super.key,
    required this.title,
    required this.content,
    required this.buttonText,
    this.nextPage,
    this.doPoppingPage = false
  });

  final String title;
  final String content;
  final String buttonText;
  final Widget? nextPage;
  final bool doPoppingPage;

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
              bottom: ratio.height * 70,
              width: screenSize.width,
              child: Image.asset(
                ImgPath.onBoarding,
              ),
            ),
            Positioned(
              top: ratio.height * 552,
              width: screenSize.width,
              child: Center(
                child: Text(title, style: KR.subtitle1),
              ),
            ),
            Positioned(
              top: ratio.height * 610,
              width: screenSize.width,
              height: ratio.height * 70,
              child: Center(
                child: Text(content,
                  style: KR.subtitle4.copyWith(color: MGColor.base3),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              bottom: ratio.height * 30,
              width: screenSize.width,
              child: Center(
                  child: CustomButtons.bottomButton(
                      buttonText,
                      MGColor.brandPrimary,
                      () {
                        if (doPoppingPage) {
                          Navigator.pop(context);
                        } else {
                          _onPressed(context);
                        }
                      }
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onPressed(BuildContext context) {
      Navigator.of(context).pushReplacement(
          PageRouteBuilder(
              fullscreenDialog: false,
              transitionsBuilder: slideRigth2Left,
              pageBuilder: (context, anime, secondAnime) => nextPage!
          )
      );
  }
}