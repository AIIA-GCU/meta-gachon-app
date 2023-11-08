///
/// 인증하기 페이지
///

import 'package:flutter/material.dart';

import 'package:mata_gachon/config/animation.dart';
import 'package:mata_gachon/config/function.dart';
import 'package:mata_gachon/config/variable.dart';

import 'admission_page.dart';

class Certificate extends StatelessWidget {

  final int currentPageIndex = 0;
  final bool isExist = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 26,
        leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(AppinIcon.back, size: 24),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(
                PageRouteBuilder(
                  transitionsBuilder: slideRigth2Left,  // animation
                  pageBuilder: (context, animation, secondaryAnimation)
                  => CertificationPage(),
                  fullscreenDialog: false,  // No Dialog
                ),
              );
            }
        ),
        title: Text(
          '강의실 인증하기',
          style: TextStyle(
              fontSize: flexibleSize(context, Size.fromHeight(18)).height,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: "KR"
          ),
        )
      )
    );
  }
}