import 'dart:io';

import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:path_provider/path_provider.dart';

import 'home_page.dart';
import 'admission_list_page.dart';
import 'my_page.dart';
import 'reservation_list_page.dart';
import 'alarm_page.dart';
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

  void _sendBugReport() {
    BetterFeedback.of(context).show((sendBugReport) async{
      final screenshotFilePath = await _writeImageToStorage(sendBugReport.screenshot);

      final Email email = Email(
        body: sendBugReport.text,
        subject: '[메타가천] 버그 리포트',
        recipients: ['aiia.lab.dev@gmail.com'],
        attachmentPaths: [screenshotFilePath],
        isHTML: false,
      );

      await FlutterEmailSender.send(email);
    });
  }

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
      const AdmissionListPage(),
      MyPage(moveToReserList: _movetoReserList)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const SizedBox(
                width: 200,
                height: 30,
                child:
                    Icon(MGLogo.logoTypoHori, color: MGColor.base4, size: 24),
              ),
              actions: [
                if (defaultTargetPlatform == TargetPlatform.android)
                  IconButton(
                    onPressed: _sendBugReport,
                    icon: const Icon(Icons.bug_report,color: MGColor.base4, size: 24),
                  ),
                SizedBox(width: ratio.width * 1),
                /// alarm
                NotificationIcon(onPressed: _movetoAlarm),
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
                items: const [
                  BottomNavigationBarItem(icon: Icon(MGIcon.home), label: "홈"),
                  BottomNavigationBarItem(icon: Icon(MGIcon.res), label: "예약"),
                  BottomNavigationBarItem(icon: Icon(MGIcon.cert), label: "인증"),
                  BottomNavigationBarItem(icon: Icon(MGIcon.my), label: "마이")
                ],
                selectedIconTheme: const IconThemeData(
                    size: 24, color: MGColor.brandPrimary))),
        if (_loading) const ProgressScreen()
      ],
    );
  }

  Future<String> _writeImageToStorage(Uint8List feedbackScreenshot) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotPath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotPath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotPath;
  }

  void _movetoAlarm() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const Alarm()));

  void _onTap(int index) => _pageController.animateToPage(index,
      duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);

  void _onPageChanged(int index) {
    if (!mounted) return;
    setState(() => _currentPageIndex = index);
  }

  BuildContext _setLoading(bool val) {
    setState(() => _loading = val);
    return context;
  }

  void _movetoReserList() => _pageController.animateToPage(1,
      duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);

  void _movetoAdmisList() => _pageController.jumpToPage(2);
}