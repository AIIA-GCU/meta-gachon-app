///
/// 내 인증 확인하기 페이지
///

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:mata_gachon/config/animation.dart';
import 'package:mata_gachon/config/function.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/main/admission.dart';
import 'package:mata_gachon/widget/certificate_widget.dart';

class MyCertification extends StatefulWidget {
  const MyCertification({super.key});

  @override
  State<MyCertification> createState() => _MyCertificationState();
}

class _MyCertificationState extends State<MyCertification> {
  bool isExist = false;

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
                  transitionsBuilder: slideRigth2Left, // animation
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      CertificationPage(),
                  fullscreenDialog: false, // No Dialog
                ),
              );
            }),
        title: Text(
          '내 인증',
          style: TextStyle(
              fontSize: flexibleSize(context, Size.fromHeight(18)).height,
              fontWeight: FontWeight.w500,
              color: MGcolor.base1,
              fontFamily: "KR"),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExist = !isExist; //테스트 버튼 테스트
              });
            },
            child: Icon(AppinIcon.not, size: 24),
          ),
          SizedBox(
            width: 16,
          )
        ],
      ),
      body: isExist
          ? Center(
              child: Container(
                child: ShaderMask(
                  shaderCallback: (Rect rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        MGcolor.base7,
                        MGcolor.base7,
                      ],
                      stops: [
                        0.80,
                        0.93,
                        1.0
                      ], // 10% purple, 80% transparent, 10% purple
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: ScrollConfiguration(
                    behavior: ScrollBehavior(),
                    child: ListView(children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                flexibleSize(context, Size.fromWidth(16))
                                    .width),
                        child: ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (context, index) => AnotherGuyWidget(
                              where: '404 - ${index + 1}',
                              name: '김가천',
                              date: '2024.03.2${index}',
                              time: '15:${index}0 ~ 18:0${index}'),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            )
          : Transform.translate(
              offset: Offset(0, -1 * AppBar().preferredSize.height),
              // 디바이스의 정 중앙에 배치
              child: Center(
                child: AutoSizeText(
                  '아직 인증이 없어요!',
                  style: TextStyle(
                    fontSize: flexibleSize(context, Size.fromHeight(16)).height,
                    color: MGcolor.base3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
    );
  }
}
