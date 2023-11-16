
import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/main/Second.dart';
import 'package:mata_gachon/page/main/home.dart';
import 'package:mata_gachon/page/main/admission.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({super.key});

  @override
  State<MainFrame> createState() => _MainFrameState();
}
class _MainFrameState extends State<MainFrame> {

  /**
   * 페이지 이동 관련
   *
   * 1. variables
   *  - currentPageIndex: 현재 Page 인덱스
   *  - _children: 페이지 List
   *  - pageController: 페이지 controller
   *
   * 2. functions
   *  - onTap:
   *      BottomNavigationBar의 아이템을 눌렀을 때 실행되는 함수
   *      페이지가 애니메이션 없이 바뀜
   *  - onPageChanged:
   *      rebuild되는 함수
   */
  int currentPageIndex = 0;
  final List<Widget> _children = [Home(),Fourth(),CertificationPage(), Fourth()];
  final pageController = PageController();

  void onTap(int index) {
    pageController.jumpToPage(index);
  }
  void onPageChanged(int index) {
    setState(() => currentPageIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Icon(MGLogo.logo_typo_hori, color: MGcolor.base4, size: 24),
          actions: [
            Center(
              child: GestureDetector(
                onTap: () {},
                child: Stack(children: [
                  Icon(AppinIcon.not, color: MGcolor.base4, size: 24),
                  // 읽지 않은 알림이 있을 때, 보이기
                  Positioned(
                      top: 1,
                      left: 1,
                      child: CircleAvatar(
                          radius: 4,
                          backgroundColor: MGcolor.base7,
                          child: CircleAvatar(
                            radius: 3,
                            backgroundColor: MGcolor.system_error,
                          )
                      )
                  )
                ]),
              ),
            ),
            SizedBox(width: 16)
          ],
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: _children,
          physics: NeverScrollableScrollPhysics(), // No sliding
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentPageIndex,
            onTap: onTap,
            items: [
              BottomNavigationBarItem(icon: Icon(AppinIcon.home), label: "홈"),
              BottomNavigationBarItem(icon: Icon(AppinIcon.res), label: "예약"),
              BottomNavigationBarItem(icon: Icon(AppinIcon.cert), label: "인증"),
              BottomNavigationBarItem(icon: Icon(AppinIcon.my), label: "마이")
            ]
        )
    );
  }
}