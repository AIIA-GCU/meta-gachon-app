import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/pages/on_boarding_page.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    //3초 후에 다음 화면으로 이동
    Timer(const Duration(milliseconds: 1000), () {
     Navigator.push(
       context, MaterialPageRoute(builder:(context)=>OnBoarding())
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

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: logoX,
            top: logoY,
            child: Icon(MGLogo.logo, color: MGColor.primaryColor(), size: 120),
          ),
          Positioned(
            left: logoX - 45,
            top: logoY + 160,
            child: Icon(MGLogo.typo, color: MGColor.primaryColor(), size: 29),
          ),
          Positioned(
            left: logoX + 44,
            top: logoY + 330,
            child: const Text(
              'ver. 1.1.0',
              style: TextStyle(
                color: MGColor.base3,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
