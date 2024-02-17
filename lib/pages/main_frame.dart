
import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';

import 'home_page.dart';
import 'admission_list_page.dart';
import 'my_page.dart';
import 'reservation_list_page.dart';
import 'alarm_page.dart';
import 'my_admission_list_page.dart';
import '../widgets/small_widgets.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({super.key});

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {

  /// 페이지 이동 관련
  ///
  /// 1. variables
  ///  - currentPageIndex: 현재 Page 인덱스
  ///  - _children: 페이지 List
  ///  - pageController: 페이지 controller
  ///
  /// 2. functions
  ///  - onTap:
  ///      BottomNavigationBar의 아이템을 눌렀을 때 실행되는 함수
  ///      페이지가 애니메이션 없이 바뀜
  ///  - onPageChanged:
  ///      rebuild되는 함수
  ///  - movetoReserList:
  ///      예약 리스트 페이지로 이동하는 callback
  ///  - movetoAdmisList:
  ///      인증 리스트 페이지로 이동하는 callback
  late int currentPageIndex;
  late final List<Widget> _children;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    currentPageIndex = 0;
    _children = [
      HomePage(
        movetoReserList: movetoReserList,
        movetoAdmisList: movetoAdmisList
      ),
      const ReservationListPage(),
      const AdmissionListPage(),
      MyPage(
        manager: false,
        moveToReserList: movetoReserList,
      )
    ];
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Icon(MGLogo.logoTypoHori, color: MGColor.base4, size: 24),
          actions: [
            /// alarm
            NotificationIcon(onPressed: movetoAlarm),
            SizedBox(width: ratio.width * 16)
          ],
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: const PageScrollPhysics(),
          children: _children,
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentPageIndex,
            onTap: onTap,
            items: const [
              BottomNavigationBarItem(icon: Icon(MGIcon.home), label: "홈"),
              BottomNavigationBarItem(icon: Icon(MGIcon.res), label: "예약"),
              BottomNavigationBarItem(icon: Icon(MGIcon.cert), label: "인증"),
              BottomNavigationBarItem(icon: Icon(MGIcon.my), label: "마이")
            ],
            selectedIconTheme: IconThemeData(
              size: 24, color: MGColor.primaryColor())
        )
    );
  }

  void movetoAlarm() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const Alarm()));

  void onTap(int index) => pageController
      .animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);

  void onPageChanged(int index) => setState(() => currentPageIndex = index);

  void movetoReserList() => pageController
      .animateToPage(1, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);

  void movetoAdmisList() => pageController
      .animateToPage(2, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);

  void movetoMyAdmis() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const MyAdmissionPage()));
}