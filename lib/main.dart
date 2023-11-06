///
/// 메타가천 메인 파일
/// - 앱 초기화
/// - 메인 레이아웃
///

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/%20reservation.dart';
import 'package:mata_gachon/page/First.dart';
import 'package:mata_gachon/page/Second.dart';
import 'package:mata_gachon/page/certificatepage/admissionPage.dart';

// 앱 실행 및 초기화
void main() => runApp(App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "메타가천",
      theme: ThemeData(
          scaffoldBackgroundColor: MGcolor.base7,
          appBarTheme: AppBarTheme(
              backgroundColor: MGcolor.base7,
              elevation: 0,
              foregroundColor: MGcolor.base4,
              toolbarHeight: 56),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedLabelStyle: TextStyle(
                color: MGcolor.base2,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                fontFamily: 'Ko'),
            selectedIconTheme:
                IconThemeData(size: 24, color: MGcolor.btn_active),
            unselectedLabelStyle: TextStyle(
                color: MGcolor.base2,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                fontFamily: 'Ko'),
            unselectedIconTheme:
                IconThemeData(size: 24, color: MGcolor.btn_inactive),
            showSelectedLabels: true,
            showUnselectedLabels: true,
          )),
      home: MainFrame(),
    );
  }
}

class MainFrame extends StatefulWidget {
  const MainFrame({super.key});

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  int currentPageIndex = 0;
  final List<Widget> _children = [First(),Reservation(),admissionPage(), Fourth()];

  void onTap(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Icon(MGLogo.logo_typo_hori, size: 24),
          actions: [
            GestureDetector(
              onTap: () {},
              child: Icon(AppinIcon.not, size: 24),
            ),
            SizedBox(
              width: 16,
            )
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
            ]));
  }
}
