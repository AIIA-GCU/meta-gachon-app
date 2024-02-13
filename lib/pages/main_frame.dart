
import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/pages/home_page.dart';
import 'package:mata_gachon/pages/admission_list_page.dart';
import 'package:mata_gachon/pages/my_page.dart';
import 'package:mata_gachon/pages/reservation_list_page.dart';
import 'package:mata_gachon/pages/alarm_page.dart';
import 'package:mata_gachon/pages/my_admission_list_page.dart';
import 'package:mata_gachon/widgets/small_widgets.dart';

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
   *  - movetoReserList:
   *      예약 리스트 페이지로 이동하는 callback
   *  - movetoAdmisList:
   *      인증 리스트 페이지로 이동하는 callback
   */
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
      ReservationListPage(),
      AdmissionListPage(),
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
          title: Icon(MGLogo.logo_typo_hori, color: MGcolor.base4, size: 24),
          actions: [
            /// alarm
            NotificationIcon(onPressed: movetoAlarm),
            SizedBox(width: ratio.width * 16)
          ],
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: PageScrollPhysics(),
          children: _children,
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
            ],
            selectedIconTheme: IconThemeData(
              size: 24, color: MGcolor.primaryColor())
        )
    );
  }

  void movetoAlarm() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => Alarm()));

  void onTap(int index) => pageController
      .animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);

  void onPageChanged(int index) => setState(() => currentPageIndex = index);

  void movetoReserList() => pageController
      .animateToPage(1, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);

  void movetoAdmisList() => pageController
      .animateToPage(2, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);

  void movetoMyAdmis() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => MyAdmissionPage()));
}