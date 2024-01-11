import 'package:flutter/material.dart';
import 'package:mata_gachon/config/animation.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/hotload/login.dart';

class OnBoarding extends StatelessWidget {
  late final Size screenSize;

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
                colors: [MGcolor.base7, MGcolor.base8],
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
                  onPressed: () => onPress(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MGcolor.btn_active,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    minimumSize: Size(ratio.width * 358, ratio.height * 48),
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
            ),
          ],
        ),
      ),
    );
  }

  void onPress(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0))),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: screenSize.height * 0.75,
          child: Stack(
            children: [
              Positioned(
                top: ratio.height * 138,
                width: screenSize.width,
                child: Text('약관 동의 내용', textAlign: TextAlign.center),
              ),
              Positioned(
                bottom: ratio.height * 80,
                width: screenSize.width,
                child: Center(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    Login(),
                            transitionsBuilder: slideLeft2Right));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MGcolor.btn_active,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        minimumSize: Size(ratio.width * 358, ratio.height * 48),
                      ),
                      child: Text(
                        '동의하기',
                        style: EN.subtitle2.copyWith(
                          fontWeight: FontWeight.w700,
                          color: MGcolor.base8,
                        ),
                      )),
                ),
              ),
              Positioned(
                bottom: ratio.height * 30,
                width: screenSize.width,
                child: Center(
                  child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          minimumSize:
                              Size(ratio.width * 358, ratio.height * 48)),
                      child: Text('닫기',
                          style: TextStyle(color: MGcolor.btn_active))),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
