import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/hotload/on_boarding.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    //3초 후에 다음 화면으로 이동
    Timer(Duration(seconds: 3), () {
     Navigator.push(
       context,MaterialPageRoute(builder:(context)=>OnBoarding())
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // 현재 화면의 크기 및 비율 가져오기
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    // 로고 이미지를 표시할 위치 계산
    final double logoWidth = screenWidth * 0.38;
    final double logoHeight = logoWidth * 1.5;
    final double logoX = (screenWidth - logoWidth) / 2;
    final double logoY = (screenHeight - logoHeight) / 2;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              color: MGcolor.base7,
            ),
            Positioned(
              left: logoX,
              top: logoY,
              child: Icon(MGLogo.logo, color: MGcolor.btn_active, size: 120),
            ),
            Positioned(
              left: logoX - 45,
              top: logoY + 160,
              child: Icon(MGLogo.logo_typo_only, color: MGcolor.btn_active, size: 29),
            ),
            Positioned(
              left: logoX + 44,
              top: logoY + 330,
              child: Text(
                'ver. 1.1.0',
                style: TextStyle(
                  color: MGcolor.base3,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
