
import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';

import 'home_page.dart';
import 'admission_list_page.dart';
import 'my_page.dart';
import 'reservation_list_page.dart';
import 'alarm_page.dart';
import 'select_service_page.dart';
import '../widgets/popup_widgets.dart';
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
  late int _currentPageIndex;
  late bool _loading;
  late final List<Widget> _children;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
    _loading = false;
    _pageController = PageController();
    _children = [
      HomePage(
        movetoReserList: _movetoReserList,
        movetoAdmisList: _movetoAdmisList,
        setLoading: _setLoading,
      ),
      ReservationListPage(setLoading: _setLoading),
      if (service case ServiceType.aiSpace)
        const AdmissionListPage(),
      MyPage(moveToReserList: _movetoReserList,)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: GestureDetector(
                  onTap: _backToSelectingPage,
                  behavior: HitTestBehavior.translucent,
                  child: const SizedBox(
                    width: 200,
                    height: 30,
                    child: Icon(MGLogo.logoTypoHori, color: MGColor.base4, size: 24),
                  )
              ),
              actions: [
                /// alarm
                NotificationIcon(onPressed: _moveToAlarm),
                SizedBox(width: ratio.width * 16)
              ],
            ),
            body: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: const PageScrollPhysics(),
              children: _children,
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _currentPageIndex,
                onTap: _onTap,
                items: [
                  const BottomNavigationBarItem(icon: Icon(MGIcon.home), label: "홈"),
                  const BottomNavigationBarItem(icon: Icon(MGIcon.res), label: "예약"),
                  if (service case ServiceType.aiSpace)
                    const BottomNavigationBarItem(icon: Icon(MGIcon.cert), label: "인증"),
                  const BottomNavigationBarItem(icon: Icon(MGIcon.my), label: "마이")
                ],
                selectedIconTheme: IconThemeData(
                  size: 24, color: MGColor.primaryColor())
            )
        ),

        if (_loading)
          const ProgressScreen()
      ],
    );
  }

  void _backToSelectingPage() {
    showDialog(
        context: context,
        barrierColor: MGColor.barrier,
        builder: (ctx) => AlertPopup(
            title: '서비스를 다시 선택하시겠습니까?',
            agreeMsg: '선택하기',
            onAgreed: () async {
              Navigator.pop(ctx);
              await Future.delayed(const Duration(milliseconds: 100));
              Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                      fullscreenDialog: false,
                      transitionsBuilder: slideLeft2Right,
                      pageBuilder: (_, __, ___) => const SelectingServicePage()
                  )
              );
            }
        )
    );
  }

  void _moveToAlarm() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const Alarm()));

  void _onTap(int index) => _pageController
      .animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);

  void _onPageChanged(int index) => setState(() => _currentPageIndex = index);

  void _setLoading(bool val) => setState(() => _loading = val);

  void _movetoReserList() => _pageController
      .animateToPage(1, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);

  void _movetoAdmisList() => _pageController.jumpToPage(2);
}