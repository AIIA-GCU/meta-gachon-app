///
/// 메타가천 메인 파일
/// - 앱 초기화
/// - 메인 레이아웃
///

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/reservation.dart';

///기기의 화면 크기와 우리의 디자인 사이의 비율
late double ratio;
late Size screenSize;
// 앱 실행 및 초기화
void main() => runApp(App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    ///기기 스크린의 크기
    screenSize = MediaQuery.of(context).size;
    ///너비 비율계산
    ratio = screenSize.width / 390;
    print(screenSize.width);
    print(ratio);
    return MaterialApp(
      title: "메타가천",
      theme: ThemeData(
        scaffoldBackgroundColor: MGcolor.base7,
        appBarTheme: AppBarTheme(
          backgroundColor: MGcolor.base7,
          elevation: 0,
          foregroundColor: MGcolor.base4,
          toolbarHeight: 56
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedLabelStyle: TextStyle(color: MGcolor.base2, fontSize: 11, fontWeight: FontWeight.w400, fontFamily: 'Ko'),
          selectedIconTheme: IconThemeData(size: 24, color: MGcolor.btn_active),
          unselectedLabelStyle: TextStyle(color: MGcolor.base2, fontSize: 11, fontWeight: FontWeight.w400, fontFamily: 'Ko'),
          unselectedIconTheme: IconThemeData(size: 24, color: MGcolor.btn_inactive),
          showSelectedLabels: true,
          showUnselectedLabels: true,
        )
      ),
      /*home: MainFrame(),*/
      home: TestMain(), ///그냥 바로 "예약하기"창으로 이동
    );
  }
}

class TestMain extends StatelessWidget {
  const TestMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 여기에서 Navigator.push를 호출합니다
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Reservation()),
            );
          },
          child: Text('Go to New Screen'),
        ),
      ),
    );
  }
}


/*
class MainFrame extends StatefulWidget {
  const MainFrame({super.key});

  @override
  State<MainFrame> createState() => _MainFrameState();
}
class _MainFrameState extends State<MainFrame> {

  int currentPageIndex = 0;

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
          SizedBox(width: 16,)
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text(currentPageIndex.toString()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() => currentPageIndex = index);
        },
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
*/
